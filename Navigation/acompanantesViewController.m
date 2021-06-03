//
//  acompanantesViewController.m
//  centrovita
//
//  Created by Laura Fernández on 29/01/16.
//  Copyright © 2016 Tammy L Coron. All rights reserved.
//

#import "acompanantesViewController.h"

@interface acompanantesViewController ()

@end

@implementation acompanantesViewController
-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue{
    //NSLog(@"json %@",json);
    if([senderValue isEqualToString:@"leerAsistentes"]){
        NSDictionary *response = [APIConnection getDictionaryJSON:json withKey:@"response"];
        asistentes = [APIConnection getArrayJSON:response withKey:@"asistentes"];
       
        [self.tabla reloadData];
    }
    else{
       [APIConnection connectAPI:[NSString stringWithFormat:@"actDetalle.php?idreal=%@&modo=leerAsistentes",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:YES onErrorReturn:false withSender:@"leerAsistentes" willContinueLoading:false];
       

    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    APIConnection=[[iwantooAPIConnection alloc] init];
    APIConnection.delegationListener=self;
    
    asistentes = [[NSMutableArray alloc] init];
    self.tabla.dataSource = self;
    self.tabla.delegate = self;
    
    [APIConnection connectAPI:[NSString stringWithFormat:@"actDetalle.php?idreal=%@&modo=leerAsistentes",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:YES onErrorReturn:false withSender:@"leerAsistentes" willContinueLoading:false];
    

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)regresar:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [asistentes count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *asistente = [asistentes objectAtIndex:indexPath.row];
    
    asistentesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"celdaAsistente"];
    if (cell == nil) {
        cell = [[asistentesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"celdaAsistente"];
    }
    NSString *nombre =[APIConnection getStringJSON:asistente withKey:@"nombreacta" widthDefValue:@""];
   int modo = [APIConnection getIntJSON:asistente withKey:@"modoactacta" widthDefValue:0];
   if(modo==0) cell.boton.hidden = true;
   else cell.boton.hidden=false;
    if([nombre isEqualToString:@""]) nombre = @"Escriba el nombre del acompañante";
    cell.nombre.text = nombre ;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   NSDictionary *asistente = [asistentes objectAtIndex:indexPath.row];
   int modo = [APIConnection getIntJSON:asistente withKey:@"modoactacta" widthDefValue:0];
   if(modo>0){
   NSString *nombre =[APIConnection getStringJSON:asistente withKey:@"nombreacta" widthDefValue:@""];
   
   UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Editar asistencia" message:nil delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Guardar",nil];
   alert.alertViewStyle = UIAlertViewStylePlainTextInput;
   UITextField * alertTextField = [alert textFieldAtIndex:0];
   alertTextField.text = nombre;
   alertTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
   alertTextField.placeholder = @"Escriba el nombre del acompañante";
   alert.delegate = self;
   alert.tag = indexPath.row;
      [alert show];
   }
   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   if(buttonIndex == 1)
   {
      NSDictionary *asistente = [asistentes objectAtIndex:alertView.tag];
   
      [APIConnection connectAPI:[NSString stringWithFormat:@"actDetalle.php?idreal=%@&modo=guardarAsistentes&idacta=%d&nombreacta=%@",self.idreal,[APIConnection getIntJSON:asistente withKey:@"idreal" widthDefValue:@""],[alertView textFieldAtIndex:0].text] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:YES onErrorReturn:false withSender:@"guardarAsistentes" willContinueLoading:YES];
      

   }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)viewDidAppear:(BOOL)animated
{
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
