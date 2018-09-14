#import "WifiLockPlugin.h"

@implementation WifiLockPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"wifi_lock"
            binaryMessenger:[registrar messenger]];
  WifiLockPlugin* instance = [[WifiLockPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  result(true);
}

@end
