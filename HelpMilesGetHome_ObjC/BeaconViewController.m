//
//  BeaconViewController.m
//  HelpMilesGetHome_ObjC
//
//  Created by James McKee on 15/02/2016.
//  Copyright © 2016 James McKee. All rights reserved.
//
//  Credits and References:
//  https://developer.apple.com/library/ios/samplecode/AirLocate/Listings/ReadMe_txt.html
//  https://developer.apple.com/ibeacon/Getting-Started-with-iBeacon.pdf
//  https://www.packtpub.com/application-development/learning-ibeacon
//

#import "BeaconViewController.h"
#import "SettingsViewController.h"

@interface BeaconViewController ()
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLBeaconRegion * beaconRegion;
@end

@implementation BeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Initialise location manager that will range for beacons
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Request permission to access location
    // NSLocationAlwaysUsageDescription String required in info.plist
    [self.locationManager requestAlwaysAuthorization];
    
    // Create new beacon region, using device proximity to beacon of chosen UUID
    self.beaconRegion = [[CLBeaconRegion alloc]
                         initWithProximityUUID:[[NSUUID alloc]
                         initWithUUIDString:@"E2C56DB5-DFFB-48D2-0001-D0F5A71096E0"]
                         identifier:@"MilesMeraki"];
    
    // Setup delegate
    [self.locationManager setDelegate:self];
    
    // Begin ranging for beacons
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
    
    // Check for beacons and if none are detected exit
    if (beacons.count == 0) return;
    
    // Create beacon objects
    CLBeacon * beacon = [beacons firstObject];
    
    // Configure variables for UI behaviour changes based on beacon ranging
    NSString * fileName;
    NSString * alertMessage;
    bool showAlert = false;
    
    // Present informative UI graphics based on beacon ranging proximity results
    switch (beacon.proximity) {
        
        // When beacon has proximity of Far, update display and UI message informing user of location
        case CLProximityFar:fileName = @"Miles-Far.png";
            alertMessage = [NSString stringWithFormat:@"Miles's home is very far away (%.2fm).", beacon.accuracy];
            break;
            
            // When beacon has proximity of Near, update display and UI message informing user of location
        case CLProximityNear:fileName = @"Miles-Near.png";
            alertMessage = [NSString stringWithFormat:@"Miles's home is very close (%.2fm).", beacon.accuracy];
            break;
            
            // When beacon has proximity of Immediate, update display and UI message informing user of location
        case CLProximityImmediate:fileName = @"Miles-Home.png";
            alertMessage = [NSString stringWithFormat:@"Miles is now home!!!"];
            // Congratulate user for getting Miles home
            showAlert = true;
            break;
            
            // When beacon proximity is Unknown, update display and UI message informing user of location
        case CLProximityUnknown:
        default:
            fileName = @"Miles-Unknown";
            alertMessage = @"Miles's home is nowhere in sight!!";
            break;
    }
    
    [self.proximityImage setImage:[UIImage imageNamed:fileName]];
    [self.homeLabel setText:alertMessage];
    
    
    // Present alert when in Immediate proximity to beacon
    if (showAlert)
    
    {
        // Stop ranging for beacons
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
        
        // Create new alert view for presenting UI with message
        UIAlertController * alertView = [UIAlertController
                                         alertControllerWithTitle:@"Congratulations!!"
                                         message:@"You got Miles safely home!!"
                                         preferredStyle:UIAlertControllerStyleAlert];
                                         
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Time for a coffee!!"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                            {
                                [alertView dismissViewControllerAnimated:YES completion:nil];
                            }];
                                         
        [alertView addAction:ok];
        [self presentViewController:alertView  animated:YES completion:nil];}
    
        // Start ranging for beacons
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
