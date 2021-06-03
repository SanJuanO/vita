//
//  color.h
//  visitbajasur
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 24/04/13.
//  Copyright (c) 2013 IMAGEN CENTRAL. All rights reserved.
//

#ifndef visitbajasur_color_h
#define visitbajasur_color_h

#define UIColorFromRGB(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define UIColorFromRGBShadow(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]


-(UIColor *)colorDesdeString:(NSString *)cadenaColor withAlpha:(CGFloat)alpha
{    
    if(![cadenaColor isEqualToString:@""] && cadenaColor != NULL)
    {
        const char *cStr = [cadenaColor cStringUsingEncoding:NSASCIIStringEncoding];
        return UIColorFromRGB(strtol(cStr+1, NULL, 16),alpha);
    }
    else return [UIColor blackColor];
    
}

#endif
