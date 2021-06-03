//
//  imagenViewController.h
//  cut
//
//  Created by Guillermo on 24/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PureLayout.h"
#import "scroll.h"

@interface imagenViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagen;
@property (nonatomic,strong) NSString *archivo;
@property (weak, nonatomic) IBOutlet scrollX *scroll;

@end
