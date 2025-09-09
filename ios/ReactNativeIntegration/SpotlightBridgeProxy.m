#import <React/RCTBridgeModule.h>

// This declares the Swift class to the RN ObjC loader.
// Note: do NOT provide a second implementation of the methods here.
@interface RCT_EXTERN_MODULE(SpotlightBridge, NSObject)

// Method signature must exactly match the Swift @objc signature.
// (NSString *)json, (NSDictionary *)targets, resolver, rejecter
RCT_EXTERN_METHOD(showSpotlights:(NSString *)json
                  targets:(NSDictionary *)targets
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end
