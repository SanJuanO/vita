//
//  popOverHerramientas.h
//  kiwilimon
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 21/05/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#ifndef kiwilimon_popOverHerramientas_h
#define kiwilimon_popOverHerramientas_h




// agregado por memo
-(void)abrePopOver:(UIViewController *)controlador conAlto:(CGFloat)alto
{
    popOver = [[UIPopoverController alloc] initWithContentViewController:controlador];
    popOver.delegate = self;
    if(alto !=0)
        popOver.popoverContentSize = CGSizeMake(320, alto);
    self.popoverImageViewController = popOver;
    
     //   [self.popoverImageViewController presentPopoverFromRect:CGRectMake(512,384-alto,1,1) inView:self.view permittedArrowDirections:0 animated:YES];
    [self showPopoverForSize:popOver.popoverContentSize center:self.view.center];
}

- (void) showPopoverForSize:(CGSize) size center:(CGPoint) center {
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat x = center.x - width / 2;
    CGFloat y = center.y - height / 2;
    CGRect frame = CGRectMake(x, y, width, height);
    
    [self.popoverImageViewController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (popOver.isPopoverVisible)
    {
        popOverEstaAbierto=true;
        [self.popoverImageViewController dismissPopoverAnimated:false];
    }
    
}

-(void)rotoPopOver
{
    if (popOverEstaAbierto)
    {
        popOverEstaAbierto=false;
        [self showPopoverForSize:popOver.popoverContentSize center:self.view.center];
    }
    
}
#endif
