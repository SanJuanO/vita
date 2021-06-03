//
//  cellFormMemo.m
//  tenerMascota
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 16/08/13.
//  Copyright (c) 2013 Imagen Central. All rights reserved.
//

#import "cellFormMemo.h"

@implementation cellFormMemo
@synthesize texto = _texto;
@synthesize imagen=_imagen;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
