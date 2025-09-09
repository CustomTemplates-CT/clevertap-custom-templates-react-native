import Foundation
import UIKit
import React

@objc(SpotlightBridge)
class SpotlightBridge: NSObject {
  
  // React Native registration
  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  // Signature: showSpotlights(jsonString, targetsObject) -> Promise
  // JS calls: SpotlightBridge.showSpotlights(JSON.stringify(displayUnit), targets)
  @MainActor
  @objc(showSpotlights:targets:resolver:rejecter:)
  func showSpotlights(
    _ json: NSString,
    targets: NSDictionary,
    resolver: @escaping RCTPromiseResolveBlock,
    rejecter: @escaping RCTPromiseRejectBlock
  ) {
    
    // logs for debugging
    print("🔵 [SpotlightBridge] showSpotlights called (Swift). Raw json length:", json.length)
    print("🔵 [SpotlightBridge] Received targets (raw NSDictionary):", targets)
    
    // Get the bridge instance from the default RCTBridge in the app.
    // In some RN setups you may prefer to store a reference to the bridge when the module is initialized.
    guard let bridge = RCTBridge.current() else {
      print("❌ [SpotlightBridge] RCTBridge.current() is nil")
      rejecter("no_bridge", "RCTBridge not available", nil)
      return
    }
    
    // uiManager to resolve react tags -> UIViews
    guard let uiManager = bridge.uiManager else {
      print("❌ [SpotlightBridge] uiManager not found on bridge")
      rejecter("no_ui_manager", "UIManager not found", nil)
      return
    }
    
    // Build map: nativeID (String) -> reactTag (NSNumber)
    var tagMapByNativeID: [String: NSNumber] = [:]
    for case let (k as NSString, v as NSNumber) in targets {
      tagMapByNativeID[k as String] = v
    }
    print("🔵 [SpotlightBridge] tagMapByNativeID:", tagMapByNativeID)
    
    // We'll resolve each reactTag → UIView on the main thread with a retry (100ms) if it's not present yet.
    var resolvedTargets: [String: UIView] = [:]
    let dispatchGroup = DispatchGroup()
    
    for (nativeID, reactTag) in tagMapByNativeID {
      dispatchGroup.enter()
      
      // Use main queue to interact with UI manager and views
      DispatchQueue.main.async {
        if let view = uiManager.view(forReactTag: reactTag) {
          resolvedTargets[nativeID] = view
          print("✅ [SpotlightBridge] Resolved view for nativeID '\(nativeID)' immediate -> \(view) frame=\(view.frame)")
          dispatchGroup.leave()
        } else {
          // Retry after short delay in case RN hasn't mounted the view yet
          print("⚠️ [SpotlightBridge] view(forReactTag:) returned nil for tag \(reactTag) (nativeID:\(nativeID)). Will retry after 0.1s")
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
            if let retryView = uiManager.view(forReactTag: reactTag) {
              resolvedTargets[nativeID] = retryView
              print("✅ [SpotlightBridge] Resolved view for nativeID '\(nativeID)' on retry -> \(retryView) frame=\(retryView.frame)")
            } else {
              print("❌ [SpotlightBridge] Still couldn't resolve view for nativeID '\(nativeID)' tag:\(reactTag)")
            }
            dispatchGroup.leave()
          }
        }
      }
    }
    
    // When all attempts are done, call SpotlightManager on main thread
    dispatchGroup.notify(queue: .main) {
      print("🔵 [SpotlightBridge] All resolution attempts finished. Resolved keys:", resolvedTargets.keys)
      
      guard let rootVC = UIApplication.shared.delegate?.window??.rootViewController,
            let rootView = rootVC.view else {
        print("❌ [SpotlightBridge] No root view available")
        rejecter("no_root_view", "Root view not available", nil)
        return
      }
      
      // Now call manager with json and the resolved map (nativeID -> UIView)
      print("🔵 [SpotlightBridge] Calling SpotlightManager with \(resolvedTargets.count) resolved targets")
      SpotlightManager.shared.showSpotlights(fromJson: json, parentView: rootView, targets: resolvedTargets) {
        print("🟢 [SpotlightBridge] SpotlightManager completed callback")
        resolver("Spotlight flow completed")
      }
    }
  }
}
