//
//  formKSEnhancedKeyboard.m
//  otroEjemplo
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 14/08/13.
//  Copyright (c) 2013 Imagen Central. All rights reserved.
//

#import "formKSEnhancedKeyboard.h"

@implementation formKSEnhancedKeyboard

// KSEnhancedKeyboard.m

- (UIToolbar *)getToolbarWithPrevEnabled:(BOOL)prevEnabled NextEnabled:(BOOL)nextEnabled DoneEnabled:(BOOL)doneEnabled
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    
    UISegmentedControl *leftItems = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previo", @"Siguiente", nil]];
    //leftItems.segmentedControlStyle = UISegmentedControlStyleBar;
    [leftItems setEnabled:prevEnabled forSegmentAtIndex:0];
    [leftItems setEnabled:nextEnabled forSegmentAtIndex:1];
    leftItems.momentary = YES; // do not preserve button's state
    [leftItems addTarget:self action:@selector(nextPrevHandlerDidChange:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *nextPrevControl = [[UIBarButtonItem alloc] initWithCustomView:leftItems];
    [toolbarItems addObject:nextPrevControl];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [toolbarItems addObject:flexSpace];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDidClick:)];
    [toolbarItems addObject:doneButton];
    
    toolbar.items = toolbarItems;
    
    return toolbar;
}

- (void)nextPrevHandlerDidChange:(id)sender
{
    if (!self.delegate) return;
    
    switch ([(UISegmentedControl *)sender selectedSegmentIndex])
    {
        case 0:
            [self.delegate previousDidTouchDown];
            break;
        case 1:
            [self.delegate nextDidTouchDown];
            break;
        default:
            break;
    }
}

- (void)doneDidClick:(id)sender
{
    if (!self.delegate) return;
    [self.delegate doneDidTouchDown];
}
@end
