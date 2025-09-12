import UIKit

@MainActor
@objc public class TooltipManager: NSObject {
  
  @objc public static let shared = TooltipManager()
  
  private var tooltipsData: [[String: Any]] = []
  private var currentTooltipIndex: Int = 0
  private weak var parentView: UIView?
  private var targetsByString: [String: UIView] = [:]
  private var completion: (() -> Void)?
  
  private override init() { super.init() }
  
  // MARK: - Show Tooltips from JSON
  @objc public func showTooltips(fromJson json: Any,
                                 parentView: UIView,
                                 targets: [String: UIView],
                                 onComplete: @escaping () -> Void) {
    DispatchQueue.main.async {
      self.parentView = parentView
      self.targetsByString = targets
      self.currentTooltipIndex = 0
      self.completion = onComplete
      
      var jsonDict: [String: Any] = [:]
      
      // Normalize input
      if let jsonStr = json as? String,
         let data = jsonStr.data(using: .utf8),
         let parsed = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
        jsonDict = parsed
      } else if let dict = json as? [String: Any] {
        jsonDict = dict
      } else if let arr = json as? [[String: Any]], let first = arr.first {
        jsonDict = first
      } else {
        print("⚠️ [TooltipManager] JSON format invalid. Completing")
        onComplete()
        return
      }
      print("✅ [TooltipManager] Top-level JSON: \(jsonDict)")
      
      // -------- Flexible parsing like SpotlightManager --------
      
      // Case 1: Nested custom_kv.nd_json string
      if let customKV = jsonDict["custom_kv"] as? [String: Any],
         let ndJsonString = customKV["nd_json"] as? String,
         let data = ndJsonString.data(using: .utf8),
         let parsedNdJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
        jsonDict = parsedNdJson
        print("✅ [TooltipManager] Parsed nested nd_json: \(jsonDict)")
        
        // Case 2: custom_kv already has nd_* keys
      } else if let customKV = jsonDict["custom_kv"] as? [String: Any],
                customKV.keys.contains(where: { $0.hasPrefix("nd_") }) {
        jsonDict = customKV
        print("✅ [TooltipManager] Using direct custom_kv keys: \(jsonDict)")
        
        // Case 3: top-level nd_* keys
      } else if jsonDict.keys.contains(where: { $0.hasPrefix("nd_") }) {
        print("✅ [TooltipManager] Using top-level nd_* keys directly")
        
      } else {
        print("⚠️ [TooltipManager] No tooltip keys found. Completing")
        onComplete()
        return
      }
      
      // -------- Continue building steps --------
      let tooltipCount: Int
      if let c = jsonDict["nd_tooltips_count"] as? Int {
        tooltipCount = c
      } else if let cs = jsonDict["nd_tooltips_count"] as? String, let ci = Int(cs) {
        tooltipCount = ci
      } else {
        print("⚠️ [TooltipManager] nd_tooltips_count missing. Completing")
        onComplete()
        return
      }
      
      var steps: [[String: Any]] = []
      for index in 1...tooltipCount {
        let idKey = "nd_view\(index)_id"
        let messageKey = "nd_view\(index)_tooltip"
        let gravityKey = "nd_view\(index)_tooltip_gravity"
        let colorKey = "nd_background_color"
        let textColorKey = "nd_text_color"
        
        if let targetId = jsonDict[idKey] as? String,
           let message = jsonDict[messageKey] as? String {
          
          let gravityString = (jsonDict[gravityKey] as? String ?? "right").lowercased()
          let gravity: TooltipGravity
          switch gravityString {
          case "top": gravity = .top
          case "bottom": gravity = .bottom
          case "left": gravity = .left
          default: gravity = .right
          }
          
          let bgColorHex = (jsonDict[colorKey] as? String) ?? "#FF0000"
          let bubbleColor = UIColor(ct_hex: bgColorHex) ?? .systemRed
          
          let textColorHex = (jsonDict[textColorKey] as? String) ?? "#FFFFFF"
          let textColor = UIColor(ct_hex: textColorHex) ?? .white
          
          steps.append([
            "targetViewId": targetId,
            "message": message,
            "gravity": gravity,
            "bubbleColor": bubbleColor,
            "textColor": textColor
          ])
          print("✅ [TooltipManager] Step prepared for targetId '\(targetId)'")
        }
      }
      
      self.tooltipsData = steps
      print("✅ [TooltipManager] Prepared tooltip steps: \(steps)")
      self.showNextTooltip()
    }
  }
  
  
  private func showNextTooltip() {
    guard currentTooltipIndex < tooltipsData.count,
          let parentView = self.parentView else {
      print("🎉 [TooltipManager] Tooltip flow completed")
      let comp = completion
      completion = nil
      DispatchQueue.main.async { comp?() }
      return
    }
    
    let step = tooltipsData[currentTooltipIndex]
    guard let targetId = step["targetViewId"] as? String else {
      currentTooltipIndex += 1
      showNextTooltip()
      return
    }
    
    // Try direct lookup using the string->UIView map
    if let targetView = targetsByString[targetId] {
      presentTooltip(over: targetView, step: step)
      return
    }
    
    // Search in parent view hierarchy
    if let found = findViewWithNativeID(in: parentView, nativeID: targetId) {
      targetsByString[targetId] = found
      presentTooltip(over: found, step: step)
      return
    }
    
    // Search all windows
    for w in UIApplication.shared.windows {
      if let found = findViewWithNativeID(in: w, nativeID: targetId) {
        targetsByString[targetId] = found
        presentTooltip(over: found, step: step)
        return
      }
    }
    
    print("⚠️ [TooltipManager] Could not find target view for id: \(targetId) — skipping")
    currentTooltipIndex += 1
    showNextTooltip()
  }
  
  private func presentTooltip(over view: UIView, step: [String: Any]) {
    let message = step["message"] as? String ?? ""
    let gravity = step["gravity"] as? TooltipGravity ?? .right
    let bubbleColor = step["bubbleColor"] as? UIColor ?? .systemRed
    let textColor = step["textColor"] as? UIColor ?? .white
    
    TooltipView.show(message: message,
                     for: view,
                     in: parentView!,
                     gravity: gravity,
                     bubbleColor: bubbleColor,
                     bubbleTextColor: textColor) { [weak self] in
      guard let self = self else { return }
      self.currentTooltipIndex += 1
      self.showNextTooltip()
    }
  }
  
  /// Recursive search for view with accessibilityIdentifier = nativeID
  private func findViewWithNativeID(in root: UIView, nativeID: String) -> UIView? {
    if root.accessibilityIdentifier == nativeID { return root }
    for sub in root.subviews {
      if let found = findViewWithNativeID(in: sub, nativeID: nativeID) {
        return found
      }
    }
    return nil
  }
}
