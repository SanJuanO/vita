//
//  selectorClase.m
//  cut
//
//  Created by Guillermo on 24/07/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "selectorClase.h"

@implementation selectorClase
#import "color.h"
#import "globales.h"
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)inicializa:(UIView *)contenedor conAltura:(long)altura
{
    self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.frame = CGRectMake(0, 0, contenedor.frame.size.width, altura);
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    self.verticalDividerEnabled = NO;
    self.selectionIndicatorColor=[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0];
    self.selectionIndicatorBoxOpacity=1.0;
    
    [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIFont fontWithName:@"Voltaire" size:14.0],NSFontAttributeName,
                                  [self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo2"] withAlpha:1.0],NSForegroundColorAttributeName,
                                  nil]];
    
    [self setSelectedTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"Voltaire" size:14.0],NSFontAttributeName,
                                          [self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0],NSForegroundColorAttributeName,
                                          nil]];
    [self setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo2"] withAlpha:1.0]];
    [contenedor addSubview:self];
    
    UIView *linea= [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    [linea setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorLineas"] withAlpha:1.0]];
    [self addSubview:linea];

}

-(void)inicializa2:(UIView *)contenedor conPosicion:(long)posicion conAltura:(long)altura
{
    self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.frame = CGRectMake(0, posicion, contenedor.frame.size.width, altura);
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    self.verticalDividerEnabled = NO;
    self.selectionIndicatorColor=[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0];
    self.selectionIndicatorBoxOpacity=0.7;
    [self setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo2"] withAlpha:1.0]];

    [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIFont fontWithName:@"Voltaire" size:13.0],NSFontAttributeName,
                                  [self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo2"] withAlpha:1.0],NSForegroundColorAttributeName,
                                  nil]];
    
    [self setSelectedTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"Voltaire" size:13.0],NSFontAttributeName,
                                          [self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0],NSForegroundColorAttributeName,
                                          nil]];
    
    
    [contenedor addSubview:self];
    /*[self setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}];
        return attString;
    }];*/
}
@end
