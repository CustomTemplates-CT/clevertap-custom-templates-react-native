import UIKit

@MainActor
@objc public class SpotlightManager: NSObject {
  
  @objc public static let shared = SpotlightManager()
  
  private var spotlightData: [[String: Any]] = []
  private var currentSpotlightIndex: Int = 0
  private weak var parentView: UIView?
  // NOTE: now keyed by nativeID string (e.g. "TextView1") -> UIView
  private var targetsByString: [String: UIView] = [:]
  private var textColor: UIColor = .white
  private var spotlightShape: SpotlightShape = .circle
  private var completion: (() -> Void)?
  
  private override init() { super.init() }
  
  // MARK: - Show Spotlights from JSON
  // targets: [nativeID: UIView] (nativeID is the string that appears in nd_viewX_id)
  public func showSpotlights(fromJson json: Any,
                             parentView: UIView,
                             targets: [String: UIView],
                             onComplete: @escaping () -> Void) {
    DispatchQueue.main.async {
      print("🎬 [SpotlightManager] Starting showSpotlights")
      self.parentView = parentView
      self.targetsByString = targets
      self.currentSpotlightIndex = 0
      self.completion = onComplete
      
      var jsonDict: [String: Any] = [:]
      
      // Normalize input: string -> dict, or already dict
      if let jsonStr = json as? String,
         let data = jsonStr.data(using: .utf8),
         let parsed = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
        jsonDict = parsed
      } else if let dict = json as? [String: Any] {
        jsonDict = dict
      } else if let arr = json as? [[String: Any]], let first = arr.first {
        jsonDict = first
      } else {
        print("⚠️ [SpotlightManager] JSON format invalid. Completing")
        onComplete()
        return
      }
      print("✅ [SpotlightManager] Top-level JSON: \(jsonDict)")
      
      // --- UPDATED IF/ELSE ---
      if let customKV = jsonDict["custom_kv"] as? [String: Any] {
        if let ndJsonString = customKV["nd_json"] as? String,
           let data = ndJsonString.data(using: .utf8),
           let parsedNdJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
          jsonDict = parsedNdJson
          print("✅ [SpotlightManager] Parsed nested custom_kv.nd_json: \(jsonDict)")
        } else if let ndJsonDict = customKV["nd_json"] as? [String: Any] {
          jsonDict = ndJsonDict
          print("✅ [SpotlightManager] custom_kv.nd_json already dict: \(jsonDict)")
        } else {
          // No nd_json inside custom_kv → assume spotlight keys are here directly
          jsonDict = customKV
          print("✅ [SpotlightManager] Using custom_kv directly as spotlight payload")
        }
      }
      else if let ndJsonString = jsonDict["nd_json"] as? String,
              let data = ndJsonString.data(using: .utf8),
              let parsed = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
        jsonDict = parsed
        print("✅ [SpotlightManager] Parsed top-level nd_json: \(jsonDict)")
      }
      else if let ndJsonDict = jsonDict["nd_json"] as? [String: Any] {
        jsonDict = ndJsonDict
        print("✅ [SpotlightManager] nd_json already dict at top-level: \(jsonDict)")
      }
      
      // Count
      let spotlightCount: Int
      if let c = jsonDict["nd_spotlight_count"] as? Int {
        spotlightCount = c
      } else if let cs = jsonDict["nd_spotlight_count"] as? String, let ci = Int(cs) {
        spotlightCount = ci
      } else {
        print("⚠️ [SpotlightManager] nd_spotlight_count missing. Completing")
        onComplete()
        return
      }
      
      // Text color
      if let hex = jsonDict["nd_text_color"] as? String, let col = UIColor(ct_hex: hex) {
        self.textColor = col
      } else {
        self.textColor = .white
      }
      
      // Shape
      if let shapeString = jsonDict["nd_spotlight_shape"] as? String {
        switch shapeString.lowercased() {
        case "rectangle":
          self.spotlightShape = .rectangle
        case "roundedrectangle", "rounded_rect", "rounded":
          self.spotlightShape = .roundedRect(cornerRadius: 8)
        default:
          self.spotlightShape = .circle
        }
      }
      
      // Build spotlight steps using nativeID keys present in nd_json: nd_view1_id etc.
      var steps: [[String: Any]] = []
      for index in 1...spotlightCount {
        let idKey = "nd_view\(index)_id"
        let titleKey = "nd_view\(index)_title"
        let subtitleKey = "nd_view\(index)_subtitle"
        
        if let targetId = jsonDict[idKey] as? String,
           let title = jsonDict[titleKey] as? String,
           let subtitle = jsonDict[subtitleKey] as? String {
          // If the JS bridge supplied a UIView for this nativeID, use it; otherwise we'll search later
          if let view = self.targetsByString[targetId] {
            // directly store the view reference for immediate use
            steps.append([
              "targetViewId": targetId,
              "title": title,
              "subtitle": subtitle
            ])
            print("✅ [SpotlightManager] Step prepared for targetId '\(targetId)' (view available)")
          } else {
            // store the id; the lookup will try to find the view by searching the view hierarchy later
            steps.append([
              "targetViewId": targetId,
              "title": title,
              "subtitle": subtitle
            ])
            print("🔎 [SpotlightManager] Step prepared for targetId '\(targetId)' (view NOT yet in targets map)")
          }
        } else {
          print("⚠️ [SpotlightManager] Missing targetId/title/subtitle for index: \(index)")
        }
      }
      
      self.spotlightData = steps
      print("✅ [SpotlightManager] Prepared spotlight steps: \(steps)")
      self.showNextSpotlight()
    }
  }
  
  // Bridge-friendly function if someone passes NSDictionary of views (not used by the Swift bridge)
  @objc public func bridgeShowSpotlights(_ json: Any,
                                         parentView: UIView,
                                         targets: NSDictionary,
                                         onComplete: @escaping () -> Void) {
    // Convert NSDictionary (nativeID -> UIView) -> [String:UIView]
    var map: [String: UIView] = [:]
    for case let (key as NSString, value as UIView) in targets {
      map[key as String] = value
    }
    self.showSpotlights(fromJson: json, parentView: parentView, targets: map, onComplete: onComplete)
  }
  
  // MARK: - flow
  private func showNextSpotlight() {
    guard currentSpotlightIndex < spotlightData.count,
          let parentView = self.parentView else {
      print("🎉 [SpotlightManager] Spotlight flow completed")
      let comp = completion
      completion = nil
      DispatchQueue.main.async { comp?() }
      return
    }
    
    let step = spotlightData[currentSpotlightIndex]
    guard let targetId = step["targetViewId"] as? String else {
      currentSpotlightIndex += 1
      showNextSpotlight()
      return
    }
    
    // Try direct lookup using the string->UIView map built from the bridge
    if let targetView = targetsByString[targetId] {
      print("✅ [SpotlightManager] Found \(targetId) via targetsByString")
      presentSpotlight(over: targetView, title: step["title"] as? String ?? "", subtitle: step["subtitle"] as? String ?? "")
      return
    }
    
    // If not found, try to find a view whose accessibilityIdentifier matches nativeID (NOT preferred by your client,
    // but kept as fallback)
    if let found = findViewWithNativeID(in: parentView, nativeID: targetId) {
      targetsByString[targetId] = found
      print("✅ [SpotlightManager] Found \(targetId) via parent view traversal")
      presentSpotlight(over: found, title: step["title"] as? String ?? "", subtitle: step["subtitle"] as? String ?? "")
      return
    }
    
    // Search across all windows (React Native sometimes mounts views into other windows)
    for w in UIApplication.shared.windows {
      if let found = findViewWithNativeID(in: w, nativeID: targetId) {
        targetsByString[targetId] = found
        print("✅ [SpotlightManager] Found \(targetId) via window scan")
        presentSpotlight(over: found, title: step["title"] as? String ?? "", subtitle: step["subtitle"] as? String ?? "")
        return
      }
    }
    
    print("⚠️ [SpotlightManager] Could not find target view for id: \(targetId) — skipping")
    currentSpotlightIndex += 1
    showNextSpotlight()
  }
  
  private func presentSpotlight(over view: UIView, title: String, subtitle: String) {
    let spotlightStep = SpotlightStep(targetView: view, title: title, subtitle: subtitle, shape: spotlightShape)
    let spotlightView = SpotlightView(step: spotlightStep)
    spotlightView.titleLabel.textColor = textColor
    spotlightView.subtitleLabel.textColor = textColor
    
    spotlightView.onDismiss = { [weak self, weak spotlightView] in
      spotlightView?.removeFromSuperview()
      guard let self = self else { return }
      self.currentSpotlightIndex += 1
      self.showNextSpotlight()
    }
    
    print("🎯 [SpotlightManager] Presenting spotlight over view: \(view) title:'\(title)' subtitle:'\(subtitle)' frame:\(view.frame)")
    
    DispatchQueue.main.async {
      if let parent = self.parentView ?? UIApplication.shared.keyWindow {
        parent.addSubview(spotlightView)
        spotlightView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          spotlightView.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
          spotlightView.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
          spotlightView.topAnchor.constraint(equalTo: parent.topAnchor),
          spotlightView.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])
        spotlightView.setNeedsLayout()
        spotlightView.layoutIfNeeded()
      } else {
        print("⚠️ [SpotlightManager] No parent to present spotlight")
      }
    }
  }
  
  /// Search recursively for a view that has an accessibilityIdentifier equal to `nativeID`.
  /// NOTE: React Native `nativeID` is mapped to `accessibilityIdentifier` on iOS by RN's view manager.
  private func findViewWithNativeID(in root: UIView, nativeID: String) -> UIView? {
    // debug
    // print("🔎 scanning view: \(root) id:\(root.accessibilityIdentifier ?? "nil")")
    if root.accessibilityIdentifier == nativeID { return root }
    for sub in root.subviews {
      if let found = findViewWithNativeID(in: sub, nativeID: nativeID) {
        return found
      }
    }
    return nil
  }
}
