// Copyright 2015-present 650 Industries. All rights reserved.

#import "EXFrameReactAppManager.h"
#import "EXKernel.h"
#import "EXKernelBridgeRegistry.h"
#import "EXKernelDevMotionHandler.h"
#import "EXKernelReactAppManager.h"

#import <React/RCTUtils.h>

@import UIKit;

static NSNotificationName EXShakeGestureNotification = @"EXShakeGestureNotification";

@implementation UIWindow (EXKernelDevMotionHandler)

- (void)EX_motionEnded:(__unused UIEventSubtype)motion withEvent:(UIEvent *)event
{
  if (event.subtype == UIEventSubtypeMotionShake) {
    [[NSNotificationCenter defaultCenter] postNotificationName:EXShakeGestureNotification object:nil];
  }
}

@end

@implementation EXKernelDevMotionHandler

+ (void)initialize
{
  // capture shake gesture for any bridge
  SEL EXMotionSelector = NSSelectorFromString(@"EX_motionEnded:withEvent:");
  RCTSwapInstanceMethods([UIWindow class], @selector(motionEnded:withEvent:), EXMotionSelector);
}

+ (instancetype)sharedInstance
{
  static EXKernelDevMotionHandler *instance;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    if (!instance) {
      instance = [[EXKernelDevMotionHandler alloc] init];
    }
  });
  return instance;
}

- (instancetype)init
{
  if (self = [super init]) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_handleShakeGesture)
                                                 name:EXShakeGestureNotification
                                               object:nil];
  }
  return self;
}

- (void)_handleShakeGesture
{
  EXKernelBridgeRegistry *bridgeRegistry = [EXKernel sharedInstance].bridgeRegistry;
  EXKernelBridgeRecord *foregroundBridgeRecord = [bridgeRegistry recordForBridge:bridgeRegistry.lastKnownForegroundBridge];
  if (foregroundBridgeRecord) {
    [foregroundBridgeRecord.appManager handleShake];
  } else {
    // maybe handle kernel shake
    [bridgeRegistry.kernelAppManager handleShake];
  }
}

@end
