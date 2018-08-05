#import "RNIBeacontransmit.h"

@interface RNIBeacontransmit()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;

@end

@implementation RNIBeacontransmit

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(startSharedAdvertisingBeaconWithString:(NSString *)uuid major:(int)major minor:(int)minor identifier:(NSString *)identifier)
{
    [[RNIBeacontransmit sharedInstance] startAdvertisingBeaconWithString: uuid major: major minor: minor identifier: identifier];
}

RCT_EXPORT_METHOD(stopSharedAdvertisingBeacon)
{
    [[RNIBeacontransmit sharedInstance] stopAdvertisingBeacon];
}

#pragma mark - Common

+ (id)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (void)startAdvertisingBeaconWithString:(NSString *)uuid major:(int)major minor:(int)minor identifier:(NSString *)identifier
{
    NSLog(@"Turning on iBeacon advertising...");
    
    [self createBeaconRegionWithString:uuid major:major minor:minor identifier:identifier];
    
    if (!self.peripheralManager)
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    [self turnOnAdvertising];
}

- (void)stopAdvertisingBeacon
{
    if ([self.peripheralManager isAdvertising]) {
        [self.peripheralManager stopAdvertising];
    }
    
    NSLog(@"iBeacon advertising turned off.");
}

- (void)createBeaconRegionWithString:(NSString *)uuid major:(int)major minor:(int)minor identifier:(NSString *)identifier
{
    //    if (self.beaconRegion)
    //        return;
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:uuid];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID major:major minor:minor identifier:identifier];
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
}

- (void)createLocationManager
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
}

#pragma mark - Beacon advertising

- (void)turnOnAdvertising
{
    if (self.peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Peripheral device manager is turned off.");
        return;
    }
    
    time_t t;
    srand((unsigned) time(&t));
    
    UInt16 major = [self.beaconRegion.major unsignedShortValue];
    UInt16 minor = [self.beaconRegion.minor unsignedShortValue];
    
    NSLog(@"Minor xoxoxo: %d", minor);
    
    
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:self.beaconRegion.proximityUUID
                                                                     major: major
                                                                     minor: minor
                                                                identifier:self.beaconRegion.identifier];
    NSDictionary *beaconPeripheralData = [region peripheralDataWithMeasuredPower:nil];
    [self.peripheralManager startAdvertising:beaconPeripheralData];
    
    NSLog(@"Turning on iBeacon advertising for region: %@.", region);
}

#pragma mark - Beacon advertising delegate methods
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheralManager error:(NSError *)error
{
    if (error) {
        NSLog(@"iBeacon advertising could not be turned on: %@", error);
        return;
    }
    
    if (peripheralManager.isAdvertising) {
        NSLog(@"iBeacon advertising successfully turned on.");
    }
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheralManager
{
    if (peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Peripheral device manager is turned off.");
        return;
    }
    
    NSLog(@"Peripheral device manager is turned on.");
    [self turnOnAdvertising];
}


@end
