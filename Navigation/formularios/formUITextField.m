//
//  formUITextField.m
//  otroEjemplo
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 14/08/13.
//  Copyright (c) 2013 Imagen Central. All rights reserved.
//

#import "formUITextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation formUITextField
@synthesize tipo = _tipo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
    }
    return self;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    if([self.tipo isEqualToString:@"AO"] || [self.tipo isEqualToString:@"D"])
    {
        return CGRectZero;
    }
    else
    {
        CGRect r = [super caretRectForPosition:position];
        
        return r;
    }
    
}

-(void)awakeFromNib
{
    [self setBorderStyle:UITextBorderStyleNone];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
