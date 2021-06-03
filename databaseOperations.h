//
//  databaseOperations.h
//  vitrina
//
//  Created by Abogado Arturo on 01/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef vitrina_databaseOperations_h
#define vitrina_databaseOperations_h


NSFileManager *fileMgr;
NSString *homeDir;

-(void)creaCampos
{
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"kiwilimon.sqlite"];
    sqlite3 *database;
    sqlite3_stmt *statement;
    if(sqlite3_open([cruddatabase UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *updateSQL = [NSString stringWithFormat: @"ALTER TABLE categorias ADD COLUMN botonDestino TEXT"];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
       /* if(sqlite3_step(statement)==SQLITE_DONE)
            NSLog(@"si");
            else
                NSLog(@"no");*/
                
        NSString *updateSQL2 = [NSString stringWithFormat: @"ALTER TABLE categorias ADD COLUMN urlDestino TEXT"];
        const char *update_stmt2 = [updateSQL2 UTF8String];
        sqlite3_prepare_v2(database, update_stmt2, -1, &statement, NULL);
               /* if(sqlite3_step(statement)==SQLITE_DONE)
                    NSLog(@"si");
                    else
                        NSLog(@"no");*/
        

        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
}
-(NSString *)GetDocumentDirectory{
    fileMgr = [NSFileManager defaultManager];
    homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return homeDir;
}

-(void)CopyDbToDocumentsFolder{
    NSError *err=nil;
    fileMgr = [NSFileManager defaultManager];
    NSString *dbpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"kiwilimon.sqlite"];
    NSString *copydbpath = [self.GetDocumentDirectory stringByAppendingPathComponent:@"kiwilimon.sqlite"];
    BOOL success = [fileMgr fileExistsAtPath:copydbpath];
    if(!success)
    {
        [fileMgr removeItemAtPath:copydbpath error:&err];
        if(![fileMgr copyItemAtPath:dbpath toPath:copydbpath error:&err])
        {
            //[self createAlert:@"Error" withMessage:@"DB Error" withCancelButton:nil withActivity:false];
        }
    }
    
}

-(sqlite3_stmt *)databaseSelect:(NSString *)query
{
    sqlite3 *databaseInUse;
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"kiwilimon.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &databaseInUse);
    
    const char *sql = [query UTF8String];
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(databaseInUse, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        return nil;
    }
    else {
        return statement;
    }
    sqlite3_finalize(statement);
    sqlite3_close(databaseInUse);
}
-(BOOL)databaseDelete:(NSString *)query
{
    sqlite3 *databaseInUse;
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"kiwilimon.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &databaseInUse);
    
    const char *sql = [query UTF8String];
    sqlite3_stmt    *statement;
    sqlite3_prepare_v2(databaseInUse, sql,  -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        return true;
    } else {
        return false;
    }
    sqlite3_finalize(statement);
    sqlite3_close(databaseInUse);
    
}
-(BOOL)databaseUpdate:(NSString *)query
{
    sqlite3 *databaseInUse;
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"kiwilimon.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &databaseInUse);
    
    const char *sql = [query UTF8String];
    sqlite3_stmt    *statement;
    sqlite3_prepare_v2(databaseInUse, sql,  -1, &statement, NULL);
    
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        return true;
    } else {
        NSLog(@"error: %s", sqlite3_errmsg(databaseInUse));
        return false;
    }
    sqlite3_finalize(statement);
    sqlite3_close(databaseInUse);
}


-(NSString *)databaseInsert:(NSString *)query
{
    sqlite3 *databaseInUse;
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"kiwilimon.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &databaseInUse);
    
    NSString *devolver=@"";
    const char *sql = [query UTF8String];
    sqlite3_stmt    *statement;
    sqlite3_prepare_v2(databaseInUse, sql,  -1, &statement, NULL);
    
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        long valor = sqlite3_last_insert_rowid(databaseInUse);
        devolver = [NSString stringWithFormat:@"%ld",valor];
    }
    sqlite3_finalize(statement);
    sqlite3_close(databaseInUse);
    return devolver;
}


- (NSString *)readConfig:name // reads the config setting
{
    NSString *dato=@"";
    sqlite3_stmt *sqlStatement = [self databaseSelect:[NSString stringWithFormat:@"SELECT valor from config where identificador='%@'",name]];
    while (sqlite3_step(sqlStatement)==SQLITE_ROW)
    {
        dato= [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement,0)];
    }
    
    if([dato isEqualToString:@""] && [name isEqualToString:@"fuente"])
    {
        dato=@"1";
        NSString *updateSQL = @"insert into config (valor,identificador) VALUES ('1','fuente')";
        NSLog(@"%@",updateSQL);
        [self databaseInsert:updateSQL];
        
        
    }
    if([dato isEqualToString:@""] && [name isEqualToString:@"fuenteColor"])
    {
        dato=@"1";
        NSString *updateSQL = @"insert into config (valor,identificador) VALUES ('1','fuenteColor')";
        NSLog(@"%@",updateSQL);
        [self databaseInsert:updateSQL];
        
        
    }
    return dato;
}

// write config setting
-(void)saveConfig:(NSString *)name withValue1:(NSString *)value1
{
    NSString *updateSQL = [NSString stringWithFormat: @"UPDATE config SET valor='%@' where identificador='%@'", value1,name];
    [self databaseUpdate:updateSQL];
}

-(NSString *)leeCalendario:(NSString *)tipoCal conidregistrocal:(NSString *)idregistrocal conidusuariocal:(NSString *)idusuariocal
{
    NSString *dato=@"";
    sqlite3_stmt *sqlStatement = [self databaseSelect:[NSString stringWithFormat:@"SELECT idcalendario from calendario where tipo='%@' and idregistro=%@ and idusuario=%@", tipoCal,idregistrocal,idusuariocal]];
    while (sqlite3_step(sqlStatement)==SQLITE_ROW)
    {
        dato= [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement,0)];
    }
    
    
    return dato;
}

-(void)guardaCalendario:(NSString *)tipoCal conidregistrocal:(NSString *)idregistrocal conidusuariocal:(NSString *)idusuariocal conidcalendariocal:(NSString *)idcalendariocal
{
    
    //sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",

    NSString *insertSQL = [NSString stringWithFormat: @"insert into calendario (tipo,idregistro,idusuario,idcalendario) VALUES ('%@',%@,%@,'%@')", tipoCal,idregistrocal,idusuariocal,idcalendariocal];
          // NSString *insertSQL = [NSString stringWithFormat: @"insert into calendario SET tipo='%@',idregistro=%@,idusuario=%@,idcalendario='%@'", tipoCal,idregistrocal,idusuariocal,idcalendariocal];
    [self databaseUpdate:insertSQL];
    NSLog(@"%@",insertSQL);
}

-(void)borrarCalendario:(NSString *)tipoCal conidregistrocal:(NSString *)idregistrocal conidusuariocal:(NSString *)idusuariocal
{
    
    NSString *insertSQL = [NSString stringWithFormat: @"delete from calendario where tipo='%@' and idregistro=%@ and idusuario=%@", tipoCal,idregistrocal,idusuariocal];
    [self databaseUpdate:insertSQL];
}


-(BOOL)revisaVacio:(NSString *)valor
{
    if(![valor isEqualToString:@""] && valor!=nil)
        return FALSE;
    else return TRUE;
}

-(int)databaseCuenta:(NSString *)query
{
    sqlite3 *databaseInUse;
    NSString *cruddatabase = [self.GetDocumentDirectory stringByAppendingPathComponent:@"kiwilimon.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &databaseInUse);
    
    const char *sql = [query UTF8String];
    int total = 0;
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(databaseInUse, sql, -1, &statement, NULL) != SQLITE_OK)
    {
        total=0;
    }
    else {
        if( sqlite3_step(statement) == SQLITE_ROW )
        {
            total=sqlite3_column_int(statement, 0);
            }
    }
    sqlite3_finalize(statement);
    sqlite3_close(databaseInUse);
    return total;
}

-(NSMutableArray *)consultaDictionary:(NSMutableDictionary *)args withTabla:(NSString *)tabla
{
    
    NSDictionary *relacionesTablas = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"pasillos",@"ipasillo",
                                      nil];
    NSDictionary *relacionesCampos = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"nombrepasillo",@"ipasillo",
                                      nil];
    NSDictionary *relacionesITs = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"",@"ipasillo",
                                     nil];
    
    
    
    NSMutableArray *row_final_array = [[NSMutableArray alloc] init];
    
    NSString *sql;
    if([self revisaVacio:[args objectForKey:@"campos"]])
        sql = [NSString stringWithFormat:@"SELECT * FROM %@", tabla];
    else sql = [NSString stringWithFormat:@"SELECT id as idreal,%@ FROM %@", [args objectForKey:@"campos"],tabla];
    
    if(![self revisaVacio:[args objectForKey:@"sql_extra"]])
    sql = [NSString stringWithFormat:@" %@ where (%@)",sql,[args objectForKey:@"sql_extra"]];
        
    if(![self revisaVacio:[args objectForKey:@"order"]])
        sql = [NSString stringWithFormat:@"%@ order by %@",sql,[args objectForKey:@"order"]];
            
    if(![self revisaVacio:[args objectForKey:@"numero_pagina"]] && ![[args objectForKey:@"numero_pagina"] isEqualToString:@"0"] )
    {
        if(([[args objectForKey:@"items_por_pagina"] isEqualToString:@""] && [args objectForKey:@"items_por_pagina"]==nil) || [[args objectForKey:@"items_por_pagina"] isEqualToString:@"0"])
            [args setObject:@"20" forKey:@"items_por_pagina"];
                
        int tempoInt = ([[args objectForKey:@"numero_pagina"] intValue]-1)*[[args objectForKey:@"items_por_pagina"] intValue];
                
        sql = [NSString stringWithFormat:@"%@ limit %d,%@",sql,tempoInt,[args objectForKey:@"items_por_pagina"]];
    }
    
    NSString *columna,*valor;
    NSDictionary *renglonLeido;
     NSMutableDictionary *consultaInterna =[[NSMutableDictionary alloc] init];
    
    NSMutableArray *columnasArray,*valoresArray,*arrayInterno,*elementosDatabase;
    columnasArray = [[NSMutableArray alloc] init];
    valoresArray = [[NSMutableArray alloc] init];
    arrayInterno = [[NSMutableArray alloc] init];
    elementosDatabase = [[NSMutableArray alloc] init];
    sqlite3_stmt *sqlStatement = [self databaseSelect:sql];

    while (sqlite3_step(sqlStatement)==SQLITE_ROW)
    {
        [columnasArray removeAllObjects];
        [valoresArray removeAllObjects];

        for(int i=0; i<=sqlite3_column_count(sqlStatement)-1; i++)
        {
            // leamos la columna
            columna = [NSString stringWithUTF8String:(char *)sqlite3_column_name(sqlStatement,i)];
            if([columna isEqualToString: @"id"]) columna = @"idreal"; // si la columna es id, la llamaremos idreal
                
            // leamos el valor
            valor=[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement,i)];
                
            // agregamos a los arreglos
            [columnasArray addObject:columna];
            [valoresArray addObject:valor];

            // vamos a revisar los ITs
            if (![self revisaVacio:[args objectForKey:@"ITs"]]) // en efecto hay ITs
            {
                // el IT está en la lista de campos
                if([[args objectForKey:@"ITs"] rangeOfString:[NSString stringWithFormat:@",%@,",columna]].location != NSNotFound)
                {
                    [consultaInterna removeAllObjects]; // limpiamos el arreglo
                    
                    // preparemos el arreglo
                    [consultaInterna setObject:[relacionesCampos objectForKey:columna] forKey:@"campos"];
                    [consultaInterna setObject:[relacionesITs objectForKey:columna] forKey:@"ITs"];
                    [consultaInterna setObject:[NSString stringWithFormat:@"id=%@",valor] forKey:@"sql_extra"];
                    [consultaInterna setObject:@"1" forKey:@"es_IT"];
                    
                    // hagamos la consulta
                    arrayInterno = [self consultaDictionary:consultaInterna withTabla:[relacionesTablas objectForKey:columna]];
                    if([arrayInterno count]>0)
                    {
                        NSArray* elementosDatabase = [[relacionesCampos objectForKey:columna] componentsSeparatedByString: @","];
                        for(int z=0; z<=[elementosDatabase count]-1; z++)
                        {
                            [columnasArray addObject:elementosDatabase[z]];
                            [valoresArray addObject:[arrayInterno[0] objectForKey:elementosDatabase[z]]];
                        }
                    }
                }
            }

            
        }
        renglonLeido = [NSDictionary dictionaryWithObjects:valoresArray forKeys:columnasArray];
        
        [row_final_array addObject:renglonLeido];
    }
    sqlite3_finalize(sqlStatement);
    return row_final_array;

}

-(void)mueveVertical:(float)posicion conObjeto:(UIView*)objeto
{
    CGRect marco = objeto.frame;
    marco.origin.y=posicion;
    objeto.frame=marco;
}

-(NSString *)extraeArchivoReal:(NSString *)archivo conModo:(NSString *)modo
{
    if([archivo length]>5)
    {
        NSString *nombreArchivo = [archivo substringToIndex:[archivo length]-4];
        nombreArchivo = [nombreArchivo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *extension = [archivo substringFromIndex:[archivo length]-4];
        extension = [extension lowercaseString];
        NSString *extra=@"";
        if ([[UIScreen mainScreen]  respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale >= 2.0)) {
            if([modo isEqualToString:@"M"]) extra=@"_movHMini";
                else extra=@"_movHNormal";
                    } else {
                        if([modo isEqualToString:@"M"]) extra=@"_movLM";
                            else extra=@"_movLNormal";
                                }
        nombreArchivo=[nombreArchivo stringByReplacingOccurrencesOfString:@"/fotos/" withString:@"/fotos/stock/"];        
        return [NSString stringWithFormat:@"%@%@%@%@",GAPIURLImages,nombreArchivo,extra,extension];
    }
    else return @"";
}


#endif
