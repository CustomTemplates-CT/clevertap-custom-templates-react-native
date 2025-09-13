import Foundation
import UIKit
import React
import CTCustomTemplates

@objc(CTCustomTemplatesBridge)
class CTCustomTemplatesBridge: NSObject {

  // ============================
  // React Native registration
  // ============================
  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }

  // ============================
  // Spotlights
  // ============================
  @MainActor
  @objc(showSpotlights:targets:resolver:rejecter:)
  func showSpotlights(
    _ json: NSString,
    targets: NSDictionary,
    resolver: @escaping RCTPromiseResolveBlock,
    rejecter: @escaping RCTPromiseRejectBlock
  ) {

    print("🔵 [CTCustomTemplatesBridge] showSpotlights called. Raw json length:", json.length)
    print("🔵 [CTCustomTemplatesBridge] Received targets (NSDictionary):", targets)

    guard let bridge = RCTBridge.current(),
          let uiManager = bridge.uiManager else {
      rejecter("no_bridge_or_ui", "RCTBridge or UIManager not available", nil)
      return
    }

    var resolvedTargets: [String: UIView] = [:]
    let group = DispatchGroup()

    for case let (k as NSString, v as NSNumber) in targets {
      group.enter()
      DispatchQueue.main.async {
        if let view = uiManager.view(forReactTag: v) {
          resolvedTargets[k as String] = view
          group.leave()
        } else {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
            if let retryView = uiManager.view(forReactTag: v) {
              resolvedTargets[k as String] = retryView
            }
            group.leave()
          }
        }
      }
    }

    group.notify(queue: .main) {
      guard let rootVC = UIApplication.shared.delegate?.window??.rootViewController,
            let rootView = rootVC.view else {
        rejecter("no_root_view", "Root view not available", nil)
        return
      }

      SpotlightManager.shared.showSpotlights(fromJson: json, parentView: rootView, targets: resolvedTargets) {
        resolver("Spotlight flow completed")
      }
    }
  }

  // ============================
  // Tooltips
  // ============================
  @MainActor
  @objc(showTooltips:targets:resolver:rejecter:)
  func showTooltips(
    _ json: NSString,
    targets: NSDictionary,
    resolver: @escaping RCTPromiseResolveBlock,
    rejecter: @escaping RCTPromiseRejectBlock
  ) {

    guard let bridge = RCTBridge.current(),
          let uiManager = bridge.uiManager else {
      rejecter("no_bridge_or_ui", "RCTBridge or UIManager not available", nil)
      return
    }

    var resolvedTargets: [String: UIView] = [:]
    let group = DispatchGroup()

    for case let (k as NSString, v as NSNumber) in targets {
      group.enter()
      DispatchQueue.main.async {
        if let view = uiManager.view(forReactTag: v) {
          resolvedTargets[k as String] = view
          group.leave()
        } else {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
            if let retryView = uiManager.view(forReactTag: v) {
              resolvedTargets[k as String] = retryView
            }
            group.leave()
          }
        }
      }
    }

    group.notify(queue: .main) {
      guard let rootVC = UIApplication.shared.delegate?.window??.rootViewController,
            let rootView = rootVC.view else {
        rejecter("no_root_view", "Root view not available", nil)
        return
      }

      TooltipManager.shared.showTooltips(fromJson: json, parentView: rootView, targets: resolvedTargets) {
        resolver("Tooltips flow completed")
      }
    }
  }

  // ============================
  // Coachmarks
  // ============================
  @MainActor
  @objc(showCoachmarks:targets:resolver:rejecter:)
  func showCoachmarks(
    _ json: NSString,
    targets: NSDictionary,
    resolver: @escaping RCTPromiseResolveBlock,
    rejecter: @escaping RCTPromiseRejectBlock
  ) {

    guard let bridge = RCTBridge.current(),
          let uiManager = bridge.uiManager else {
      rejecter("no_bridge_or_ui", "RCTBridge or UIManager not available", nil)
      return
    }

    var resolvedTargets: [String: UIView] = [:]   // 🔹 FIXED (was Int: UIView)
    let group = DispatchGroup()

    for case let (k as NSString, v as NSNumber) in targets {
      group.enter()
      DispatchQueue.main.async {
        if let view = uiManager.view(forReactTag: v) {
          resolvedTargets[k as String] = view     // 🔹 Use nativeID string
          group.leave()
        } else {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
            if let retryView = uiManager.view(forReactTag: v) {
              resolvedTargets[k as String] = retryView
            }
            group.leave()
          }
        }
      }
    }

    group.notify(queue: .main) {
      guard let rootVC = UIApplication.shared.delegate?.window??.rootViewController,
            let rootView = rootVC.view else {
        rejecter("no_root_view", "Root view not available", nil)
        return
      }

      CoachmarkManager.shared.showCoachmarks(fromJson: json, parentView: rootView, targets: resolvedTargets) {
        resolver("Coachmarks flow completed")
      }
    }
  }

}
