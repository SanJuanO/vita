//
//  AppDelegate.h
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "actividadesViewController.h"
#import "iwantooAPIConnection.h"
#import "firmaViewController.h"
#import "perfilViewController.h"
#import <StoreKit/StoreKit.h>
#import <AVFoundation/AVFoundation.h>

#import "navigationViewController.h"
//onesignal
#import "OneSignal/OneSignal.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,APIConnectionDelegate,UIAlertViewDelegate,SKPaymentTransactionObserver,UIAlertViewDelegate>
{
    navigationViewController *navigationController;
    AVAudioPlayer *avSound;
    iwantooAPIConnection *APIConnection;
    NSString *tokenTemporalGlobal;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AVPlayer *movieplayer;
@property (strong, nonatomic) id<NSObject> timeObserverToken;

//onesignal
@property (strong, nonatomic) OneSignal *oneSignal;
-(void)cargaAudio:(NSString *)urlCargar;
-(void)limpiaAudio;
-(void)audioAccion:(NSString *)archivo;

@end
