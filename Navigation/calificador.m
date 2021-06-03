//
//  calificador.m
//  kiwilimon
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 17/05/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "calificador.h"
#import "PureLayout.h"

@implementation calificador
@synthesize view=_view;
@synthesize estrella1=_estrella1;
@synthesize estrella2=_estrella2;
@synthesize estrella3=_estrella3;
@synthesize estrella4=_estrella4;
@synthesize estrella5=_estrella5;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self)
    {
        [self setup];
        
    }
    return self;
}

-(void)setup
{
    
    [[NSBundle mainBundle] loadNibNamed:@"calificador" owner:self options:nil];
    [self addSubview:self.view];
    [self.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

-(void)califica:(int)calificacion conActivo:(BOOL)activo
{
    activoInterno=activo;
    
    [self.estrella1 setBackgroundImage:[UIImage imageNamed:@"estrella0"] forState:UIControlStateNormal];
    [self.estrella2 setBackgroundImage:[UIImage imageNamed:@"estrella0"] forState:UIControlStateNormal];
    [self.estrella3 setBackgroundImage:[UIImage imageNamed:@"estrella0"] forState:UIControlStateNormal];
    [self.estrella4 setBackgroundImage:[UIImage imageNamed:@"estrella0"] forState:UIControlStateNormal];
    [self.estrella5 setBackgroundImage:[UIImage imageNamed:@"estrella0"] forState:UIControlStateNormal];
    
    if(calificacion>=1)
        [self.estrella1 setBackgroundImage:[UIImage imageNamed:@"estrella1"] forState:UIControlStateNormal];
    if(calificacion>=2)
        [self.estrella2 setBackgroundImage:[UIImage imageNamed:@"estrella1"] forState:UIControlStateNormal];
    if(calificacion>=3)
        [self.estrella3 setBackgroundImage:[UIImage imageNamed:@"estrella1"] forState:UIControlStateNormal];
    if(calificacion>=4)
        [self.estrella4 setBackgroundImage:[UIImage imageNamed:@"estrella1"] forState:UIControlStateNormal];
    if(calificacion>=5)
        [self.estrella5 setBackgroundImage:[UIImage imageNamed:@"estrella1"] forState:UIControlStateNormal];
}

@end
