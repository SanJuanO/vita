//
//  fontMuseo.h
//  iwantoo
//
//  Created by Abogado Arturo on 20/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UIColorFromRGB2(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBShadow2(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

@interface fontMuseo : UILabel

-(float)fontPaint:(NSString *)textShow withFont:(NSString *)font withSize:(int)size withColor:(NSString *)color;
-(void)fontPaintShadow:(NSString *)color withXPosition:(int)xPosition withYPosition:(int)yPosition;
-(void)fontChangeX:(float)newX;
-(void)fontPaintOnly:(NSString *)font withSize:(int)size withColor:(NSString *)color;
-(float)fontPaintWithFormat:(NSString *)textShow withFont:(NSString *)font withSize:(int)size withColor:(NSString *)color;

-(float)expectedWidth;
//-(void)fontPaintShadowOpacity:(NSString *)color withXPosition:(int)xPosition withYPosition:(int)yPosition;
-(void)fontPaintShadowAlpha:(NSString *)color withXPosition:(int)xPosition withYPosition:(int)yPosition withAlpha:(float)alpha;
-(void)textoSombra:(NSString *)textShow withFont:(NSString *)font withSize:(int)size withColor:(NSString *)color withShadowColor:(NSString *)shadowColor;

@end
