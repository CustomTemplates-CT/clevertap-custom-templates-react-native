import UIKit

@MainActor
@objc public class CoachmarkManager: NSObject {
  
  @objc public static let shared = CoachmarkManager()
  
  private var coachmarksData: [[String: Any]] = []
  private var currentCoachmarkIndex: Int = 0
  private weak var parentView: UIView?
  private var targetsByString: [String: UIView] = [:]
  private var completion: (() -> Void)?
  
  private override init() { super.init() }
  
  // MARK: - Show Coachmarks from JSON
  @objc public func showCoachmarks(fromJson json: Any,
                                   parentView: UIView,
                                   targets: [String: UIView],
                                   onComplete: @escaping () -> Void) {
    DispatchQueue.main.async {
      self.parentView = parentView
      self.targetsByString = targets
      self.currentCoachmarkIndex = 0
      self.completion = onComplete
      
      var jsonDict: [String: Any] = [:]
      
      // -------- Normalize input --------
      if let jsonStr = json as? String,
         let data = jsonStr.data(using: .utf8),
         let parsed = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
        jsonDict = parsed
      } else if let dict = json as? [String: Any] {
        jsonDict = dict
      } else if let arr = json as? [[String: Any]], let first = arr.first {
        jsonDict = first
      } else {
        print("⚠️ [CoachmarkManager] Invalid JSON format. Completing")
        onComplete()
        return
      }
      print("✅ [CoachmarkManager] Top-level JSON: \(jsonDict)")
      
      // -------- Flexible parsing --------
      if let customKV = jsonDict["custom_kv"] as? [String: Any],
         let ndJsonString = customKV["nd_json"] as? String,
         let data = ndJsonString.data(using: .utf8),
         let parsedNdJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
        jsonDict = parsedNdJson
        print("✅ [CoachmarkManager] Parsed nested nd_json from custom_kv: \(jsonDict)")
        
      } else if let customKV = jsonDict["custom_kv"] as? [String: Any],
                customKV.keys.contains(where: { $0.hasPrefix("nd_") }) {
        jsonDict = customKV
        print("✅ [CoachmarkManager] Using direct custom_kv keys: \(jsonDict)")
        
      } else if jsonDict.keys.contains(where: { $0.hasPrefix("nd_") }) {
        print("✅ [CoachmarkManager] Using top-level nd_* keys directly")
        
      } else {
        print("⚠️ [CoachmarkManager] No coachmark keys found. Completing")
        onComplete()
        return
      }
      
      // -------- Count --------
      let coachmarkCount: Int
      if let c = jsonDict["nd_coachmarks_count"] as? Int {
        coachmarkCount = c
      } else if let cs = jsonDict["nd_coachmarks_count"] as? String, let ci = Int(cs) {
        coachmarkCount = ci
      } else {
        print("⚠️ [CoachmarkManager] nd_coachmarks_count missing. Completing")
        onComplete()
        return
      }
      print("✅ [CoachmarkManager] Found \(coachmarkCount) coachmarks")
      
      // -------- Steps --------
      var steps: [[String: Any]] = []
      for index in 1...coachmarkCount {
        let idKey = "nd_view\(index)_id"
        let titleKey = "nd_view\(index)_title"
        let subtitleKey = "nd_view\(index)_subtitle"
        
        if let targetId = jsonDict[idKey] as? String,
           let title = jsonDict[titleKey] as? String,
           let message = jsonDict[subtitleKey] as? String {
          steps.append([
            "targetViewId": targetId,
            "title": title,
            "message": message
          ])
          print("✅ [CoachmarkManager] Step prepared for targetId '\(targetId)'")
        } else {
          print("⚠️ [CoachmarkManager] Skipping step \(index) — missing id/title/message")
        }
      }
      
      self.coachmarksData = steps
      print("✅ [CoachmarkManager] Prepared coachmark steps: \(steps)")
      
      // -------- Buttons --------
      self.showNextCoachmark(jsonDict: jsonDict)
    }
  }
  
  // MARK: - Show Next
  private func showNextCoachmark(jsonDict: [String: Any]) {
    guard currentCoachmarkIndex < coachmarksData.count,
          let parentView = self.parentView else {
      print("🎉 [CoachmarkManager] Coachmark flow completed")
      let comp = completion
      completion = nil
      DispatchQueue.main.async { comp?() }
      return
    }
    
    let step = coachmarksData[currentCoachmarkIndex]
    guard let targetId = step["targetViewId"] as? String else {
      print("⚠️ [CoachmarkManager] Step missing targetViewId, skipping")
      currentCoachmarkIndex += 1
      showNextCoachmark(jsonDict: jsonDict)
      return
    }
    
    // Resolve target view
    guard let targetView = resolveTargetView(for: targetId, in: parentView) else {
      print("⚠️ [CoachmarkManager] Could not find target view for id: \(targetId) — skipping")
      currentCoachmarkIndex += 1
      showNextCoachmark(jsonDict: jsonDict)
      return
    }
    
    let title = step["title"] as? String ?? ""
    let message = step["message"] as? String ?? ""
    
    // Button configs
    let positiveButtonText = jsonDict["nd_positive_button_text"] as? String ?? "Next"
    let skipButtonText = jsonDict["nd_skip_button_text"] as? String ?? "Skip"
    let positiveButtonBackgroundColor = jsonDict["nd_positive_button_background_color"] as? String ?? "#E83938"
    let skipButtonBackgroundColor = jsonDict["nd_skip_button_background_color"] as? String ?? "#FFFFFF"
    let positiveButtonTextColor = jsonDict["nd_positive_button_text_color"] as? String ?? "#FFFFFF"
    let skipButtonTextColor = jsonDict["nd_skip_button_text_color"] as? String ?? "#000000"
    let finalButtonText = jsonDict["nd_final_positive_button_text"] as? String ?? "Ready to Explore"
    
    let coachmark = CoachmarkView(
      targetView: targetView,
      title: title,
      message: message,
      currentIndex: currentCoachmarkIndex + 1,
      totalSteps: coachmarksData.count,
      frame: parentView.bounds,
      positiveButtonText: positiveButtonText,
      skipButtonText: skipButtonText,
      positiveButtonBackgroundColor: positiveButtonBackgroundColor,
      skipButtonBackgroundColor: skipButtonBackgroundColor,
      positiveButtonTextColor: positiveButtonTextColor,
      skipButtonTextColor: skipButtonTextColor,
      finalButtonText: finalButtonText
    )
    
    coachmark.onNext = { [weak self, weak coachmark] in
      coachmark?.removeFromSuperview()
      self?.currentCoachmarkIndex += 1
      self?.showNextCoachmark(jsonDict: jsonDict)
    }
    
    coachmark.onSkip = { [weak self, weak coachmark] in
      coachmark?.removeFromSuperview()
      self?.currentCoachmarkIndex = self?.coachmarksData.count ?? 0
      self?.showNextCoachmark(jsonDict: jsonDict)
    }
    
    parentView.addSubview(coachmark)
  }
  
  // MARK: - Target Resolution
  private func resolveTargetView(for targetId: String, in parent: UIView) -> UIView? {
    if let cached = targetsByString[targetId] { return cached }
    if let found = findViewWithNativeID(in: parent, nativeID: targetId) {
      targetsByString[targetId] = found
      return found
    }
    for w in UIApplication.shared.windows {
      if let found = findViewWithNativeID(in: w, nativeID: targetId) {
        targetsByString[targetId] = found
        return found
      }
    }
    return nil
  }
  
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

