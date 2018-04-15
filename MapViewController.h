//
//  MapViewController.h
//  Foxbrowser
//
//  Created by Asif Seraje on 1/12/18.
//  Copyright © 2018 Asif Seraje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UITextField *txt2;
@property (weak, nonatomic) IBOutlet UIButton *buttonDone;
@property (weak, nonatomic) IBOutlet MKMapView *maPview;


@end
