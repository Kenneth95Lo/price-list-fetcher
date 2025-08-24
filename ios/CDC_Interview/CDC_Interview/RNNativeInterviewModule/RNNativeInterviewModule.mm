
#import "RNNativeInterviewModule.h"
#import "CDC_Interview-Swift.h"

@interface RNNativeInterviewModule()
@property (nonatomic, strong) RNNativeInterviewModuleImpl * _impl;
@end

@implementation RNNativeInterviewModule

RCT_EXPORT_MODULE(NativeInterviewModule);

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const facebook::react::ObjCTurboModule::InitParams &)params { 
    return std::make_shared<facebook::react::NativeInterviewModuleSpecJSI>(params);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        __impl = [[RNNativeInterviewModuleImpl alloc] init];
    }
    
    return self;
}

-(void)fetchPriceList:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    // TODO: Implement price list fetching
    // 1. use allPriceUsecase or usdPriceUseCase to fetch data
    // 2. if feature flag .supportEUR is true, use fetchAllPriceList else use fetchUSDPriceList
    // 3. success: return response of allPriceList or usdPriceList
    
    [__impl fetchPriceListWithOptions:options handler:^(NSArray * array, NSError * error) {
        if (error != nil) {
            reject(@"error", nil, error);
        } else {
            resolve(@{@"type": @"success", @"data": array});
        }
    } completionHandler:^{
    }];
    
}

@end


