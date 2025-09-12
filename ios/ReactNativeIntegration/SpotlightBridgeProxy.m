//#import <React/RCTBridgeModule.h>
//
//@interface RCT_EXTERN_MODULE(SpotlightBridge, NSObject)
//
//// Existing Spotlights bridge
//RCT_EXTERN_METHOD(
//  showSpotlights:(NSString *)json
//  targets:(NSDictionary *)targets
//  resolver:(RCTPromiseResolveBlock)resolver
//  rejecter:(RCTPromiseRejectBlock)rejecter
//)
//
//// ✅ New Tooltips bridge
//RCT_EXTERN_METHOD(
//  showTooltips:(NSString *)json
//  targets:(NSDictionary *)targets
//  resolver:(RCTPromiseResolveBlock)resolver
//  rejecter:(RCTPromiseRejectBlock)rejecter
//)
//
//@end

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(SpotlightBridge, NSObject)

// ✅ Spotlights bridge
RCT_EXTERN_METHOD(
  showSpotlights:(NSString *)json
  targets:(NSDictionary *)targets
  resolver:(RCTPromiseResolveBlock)resolver
  rejecter:(RCTPromiseRejectBlock)rejecter
)

// ✅ Tooltips bridge
RCT_EXTERN_METHOD(
  showTooltips:(NSString *)json
  targets:(NSDictionary *)targets
  resolver:(RCTPromiseResolveBlock)resolver
  rejecter:(RCTPromiseRejectBlock)rejecter
)

// ✅ Coachmarks bridge
RCT_EXTERN_METHOD(
  showCoachmarks:(NSString *)json
  targets:(NSDictionary *)targets
  resolver:(RCTPromiseResolveBlock)resolver
  rejecter:(RCTPromiseRejectBlock)rejecter
)

@end


