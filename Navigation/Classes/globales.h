#ifndef Navigation_globales_h
#define Navigation_globales_h


extern int screenMultiplier;
extern CGFloat screenWidth;
extern CGFloat screenHeight;
extern CGFloat versionSistema;
extern CGFloat alturaStatus;

extern NSString* GAPIURLImages;
extern NSString* GAPIURL;
extern NSString* GAPIShare;
extern NSString* GAPICiudad;
extern NSString* GAPIContentType;
extern NSString* imagenMails;
extern NSString *imagenPredeterminada;


extern NSString* stringToPass;
extern NSString* stringToPass1;
extern NSString* stringToPass2;
extern NSMutableDictionary* dictionaryToPass;

extern NSString* APIlocale;
extern NSString* APIDocDir;

extern NSString *token;
extern NSString *uid;
extern NSString *tokenCMS;
extern NSString *tokenName;
extern NSString *tokenImagen;
// tokenTeam,tokenMember,tokenManager
extern NSString *tokenTeam;
extern NSString *tokenMember;
extern NSString *tokenManager;
extern BOOL recienFirmado;

extern NSString *googleAdID;
extern BOOL googleProbando;
extern NSString *googleTest;

extern NSString *dispositivo;
extern NSString *stringToPass;
extern NSDictionary *dictionaryToPass1,*dictionaryToPass2,*dictionaryToPass3;
extern BOOL popOverEstaAbierto;
extern NSString *proximaVentana;
extern NSDictionary *proximoDiccionario;
extern NSString *cBase;

extern double multiplicadorFuente;
extern NSString *colorFuenteGlobal;
extern BOOL cambioFuenteAhora;
// VARIABLES PARA FORMULARIOS
extern NSString *fuenteEspecial;
extern NSString *cDestacado;
extern NSString *cGris80;

extern NSMutableDictionary *configPrincipal,*configPrincipal1,*configPrincipal2;

//Para notificaciones push
extern NSDictionary *tagsDictionary;

extern NSString *urlRC;

extern BOOL audioReproduciendo;
extern float audioDuracion,audioProgreso;
extern NSString *audioArchivo;
#endif
