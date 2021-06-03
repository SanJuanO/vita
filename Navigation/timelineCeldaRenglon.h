//
//  timelineCeldaRenglon.h
//  micartelera
//
//  Created by Guillermo on 05/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timelineCeldaRenglon : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *texto;
-(void)pintaNormal;
-(void)pintaInvertido;
@end
