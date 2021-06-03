//
//  acompanantesViewController.h
//  centrovita
//
//  Created by Laura Fernández on 29/01/16.
//  Copyright © 2016 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iwantooAPIConnection.h"
#import "asistentesTableViewCell.h"
@interface acompanantesViewController : UIViewController<APIConnectionDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
    
    iwantooAPIConnection *APIConnection;
    NSMutableArray *asistentes;
}

@property (weak, nonatomic) IBOutlet UITableView *tabla;

@property NSString *idreal;
@end
