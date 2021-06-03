//
//  formKSEnhancedKeyboard.h
//  otroEjemplo
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 14/08/13.
//  Copyright (c) 2013 Imagen Central. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol KSEnhancedKeyboardDelegate
- (void)nextDidTouchDown;
- (void)previousDidTouchDown;
- (void)doneDidTouchDown;
@end

@interface formKSEnhancedKeyboard : NSObject
- (UIToolbar *)getToolbarWithPrevEnabled:(BOOL)prevEnabled NextEnabled:(BOOL)nextEnabled DoneEnabled:(BOOL)doneEnabled;
 @property (nonatomic, strong) id <KSEnhancedKeyboardDelegate> delegate;
@end
