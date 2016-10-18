// Copyright 2015-present 650 Industries. All rights reserved.

#import "EXReactAppManager.h"

NS_ASSUME_NONNULL_BEGIN

@class EXFrame;

@interface EXFrameReactAppManager : EXReactAppManager

- (instancetype)initWithEXFrame:(EXFrame *)frame;
- (void)logKernelAnalyticsEventWithParams:(NSDictionary *)params;

@property (nonatomic, weak, readonly) EXFrame *frame;

@end

NS_ASSUME_NONNULL_END
