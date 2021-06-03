//
//  fontMuseo.m
//  iwantoo
//
//  Created by Abogado Arturo on 20/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "fontMuseo.h"
#import "globales.h"

@implementation fontMuseo



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
    }
    return self;
}


-(float)fontPaint:(NSString *)textShow withFont:(NSString *)font withSize:(int)size withColor:(NSString *)color
{       
    [self setFont:[UIFont fontWithName:font size:size ]];
    self.text = [NSString stringWithFormat:@"%@",textShow];
    if(![color isEqualToString:@""])
    {
        const char *cStr = [color cStringUsingEncoding:NSASCIIStringEncoding];
        self.textColor = UIColorFromRGB2(strtol(cStr+1, NULL, 16));
    }  
    CGFloat newPos = self.frame.origin.x + [self expectedWidth];
    
    return newPos;
}

-(float)fontPaintWithFormat:(NSString *)textShow withFont:(NSString *)font withSize:(int)size withColor:(NSString *)color
{     
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[textShow intValue]]];
    
    [self setFont:[UIFont fontWithName:font size:size ]];
    
    self.text = formatted;
    if(![color isEqualToString:@""])
    {
        const char *cStr = [color cStringUsingEncoding:NSASCIIStringEncoding];
        self.textColor = UIColorFromRGB2(strtol(cStr+1, NULL, 16));
    }  
    CGFloat newPos = self.frame.origin.x + [self expectedWidth];
    
    return newPos;
}

-(void)fontPaintOnly:(NSString *)font withSize:(int)size withColor:(NSString *)color
{       
    [self setFont:[UIFont fontWithName:font size:size ]];
    
    if(![color isEqualToString:@""])
    {
        const char *cStr = [color cStringUsingEncoding:NSASCIIStringEncoding];
        self.textColor = UIColorFromRGB2(strtol(cStr+1, NULL, 16));
    }  
}

-(void)fontPaintShadow:(NSString *)color withXPosition:(int)xPosition withYPosition:(int)yPosition
{      
    const char *cStr = [color cStringUsingEncoding:NSASCIIStringEncoding];
    self.shadowColor = UIColorFromRGB2(strtol(cStr+1, NULL, 16));
    self.shadowOffset = CGSizeMake(xPosition,yPosition);
}

-(void)fontPaintShadowAlpha:(NSString *)color withXPosition:(int)xPosition withYPosition:(int)yPosition withAlpha:(float)alpha
{
    const char *cStr = [color cStringUsingEncoding:NSASCIIStringEncoding];
    self.shadowColor = UIColorFromRGBShadow2(strtol(cStr+1, NULL, 16),alpha);
    self.shadowOffset = CGSizeMake(xPosition,yPosition);
}


-(void)fontChangeX:(float)newX
{
    [self setFrame:CGRectMake(newX, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
}

-(float)expectedWidth{
    [self setNumberOfLines:1];
    
    CGSize maximumLabelSize = CGSizeMake(9999,self.frame.size.height);
    
    /*CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:[self lineBreakMode]];*/
    
    CGRect expectedLabelRect = [[self text] boundingRectWithSize:maximumLabelSize
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName: [self font]}
                                            context:nil];
    CGSize expectedLabelSize=CGSizeMake(ceilf(expectedLabelRect.size.width), ceilf(expectedLabelRect.size.height));

    return expectedLabelSize.width;
}

-(void)textoSombra:(NSString *)textShow withFont:(NSString *)font withSize:(int)size withColor:(NSString *)color withShadowColor:(NSString *)shadowColor
{
    [self fontPaint:textShow withFont:font withSize:size withColor:color];
    [self fontPaintShadow:shadowColor withXPosition:1 withYPosition:1];
}

@end
