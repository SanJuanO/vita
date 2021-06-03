//
//  viedo2ViewController.m
//  centrovita
//
//  Created by GuillermoFernandez on 11/26/19.
//  Copyright © 2019 Tammy L Coron. All rights reserved.
//

#import "viedo2ViewController.h"

@interface viedo2ViewController ()

@end

@implementation viedo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
      [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
      [UINavigationController attemptRotationToDeviceOrientation];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (BOOL)shouldAutorotate {


    return NO;

}

-(void)viewWillDisappear:(BOOL)animated
{
    
}
@end
