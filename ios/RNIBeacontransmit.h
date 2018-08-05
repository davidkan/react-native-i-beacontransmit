#import "RCTBridgeModule.h"

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

#import "RCTBridgeModule.h"

#else
//#import <React/RCTBridgeModule.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

#endif

@interface RNIBeacontransmit : NSObject <RCTBridgeModule, CLLocationManagerDelegate, CBPeripheralManagerDelegate>

@end
  
