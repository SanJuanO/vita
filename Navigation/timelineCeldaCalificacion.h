//
//  timelineCeldaCalificacion.h
//  micartelera
//
//  Created by Guillermo on 07/10/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol timelineCeldaCalificacionProtocol <NSObject>
@optional
-(void)califica:(long)cual conCalificacion:(NSString *)calificacion;
@end

@interface timelineCeldaCalificacion : UITableViewCell
{
    id<timelineCeldaCalificacionProtocol> delegate;

}
@property (nonatomic,assign) id<timelineCeldaCalificacionProtocol> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *stara0;
@property (weak, nonatomic) IBOutlet UIImageView *stara1;
@property (weak, nonatomic) IBOutlet UIImageView *stara2;
@property (weak, nonatomic) IBOutlet UIImageView *stara3;
@property (weak, nonatomic) IBOutlet UIImageView *stara4;

-(void)pintaCalificacion:(NSString *)valorProceso;
-(void)pintaElementos;
@end


