/*****************************************************************************

		Copyright (c) My Company

 Project:  TETRISV2
 FileName: TETRISV2.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "tetrisv2.inc"

domains
  ancho=integer
  tipo=integer
  centro=integer
  orientacion=integer					
  postab=integer

  ficha=f(tipo,orientacion,postab)     

  juego=tipo*			       /* Es la secuencia de fichas a colocar */
  solucion=ficha*		       /* Es la solucion que que se genera para colocar las fichas en el tablero */
  
  filatab=postab*                      /* filatab tiene en el primer elemento la fila y en el resto los elementos de la fila
                                          4 0 0 0 0 0
                                          3 0 0 0 0 0 
                                          2 0 0 1 0 0
                                          1 0 1 1 1 0. El suelo seria [0,1,2,1,0]*/
  suelo=postab*
  tabla=filatab*
  tablero=tab(suelo,tabla)
  contador=integer
  tamanho=integer
  
  columna=integer
  
predicates

  vacia(tablero)
  pinta(tablero)
  pintafila(filatab)
  escribelista(filatab)
  
  escribesol(solucion)
  
  backtrack(juego,tablero,solucion,solucion)
  
  regla(tablero,tipo,orientacion,postab,tablero)
  
  mete(ficha,tablero,tablero)
  
  cambia_fila(tabla,suelo,postab,postab,ancho,tabla,suelo)
    
  modifica(filatab,suelo,postab,postab,ancho,filatab,suelo)
  
  obtiene_fila(postab,suelo,postab,postab)
  
  extrae_fila(filatab,tabla,postab,postab)
  
  recalcula_suelo(suelo,postab,postab,tabla,suelo)
  
  recorrefila(postab,filatab,suelo,suelo)
  
  mayor(postab,postab,postab)
  
  filallena(filatab)
  
  quitafilas(tabla,postab,postab,tabla)
  
  renumera(tabla,postab,postab,tabla)
  
  anhade(tabla,postab,postab,tabla)
  
  recorta(tabla,postab,suelo,tabla,suelo)
  
  limpia_filas(tabla,suelo,suelo,tabla)  
  
  tetris()



clauses
/* Extrae la Fila dada por el tercer parametro */
     
  extrae_fila(Fila,Tabla,Indice,Indice):-
      Tabla=[H|_],
      Fila=H.
      
  extrae_fila(Fila,[_|T],Cont,Fila_obj):-
      ContN=Cont-1,
      extrae_fila(Fila,T,ContN,Fila_obj).
     
/* El predicado permite obtener la fila de apoyo Numfila, a partir del suelos, con un contador con un limite */     
     
  obtiene_fila(Numfila,[H|_],Contador,Contador):-
     Numfila=H.
  
  obtiene_fila(Numfila,[_|T],Contador_int,Posicion):-
     ContadorN=Contador_int+1,
     obtiene_fila(Numfila,T,ContadorN,Posicion).
     
/* Recalcula el suelo nos dice por donde van los indices del suelo */

/* Ha llegado arriba del todo por lo que el suelo est? calculado */     
  recalcula_suelo(Suelo_in,Contador,Limite,_,Suelo_out):-
     Contador<Limite,
     Suelo_out=Suelo_in.
     
  recalcula_suelo(Suelo_in,Contador,Limite,Tabla,Suelo_out):-
     extrae_fila(Fila,Tabla,4,Contador),
     Fila=[Numero|Resto],
     recorrefila(Numero,Resto,Suelo_in,Suelo_int),
     Contadorn=Contador-1,
     recalcula_suelo(Suelo_int,Contadorn,Limite,Tabla,Suelo_out).
     
/* Vamos a recorrer la fila recalculando el suelo */

  recorrefila(_,[],_,[]).
     
/* Vamos iterando si hay un 0 esa posicion de suelo se queda como est? */
     
  recorrefila(Numero,[0|Cola],[S|Resto],Suelo_out):-
     recorrefila(Numero,Cola,Resto,Queda),
     Suelo_out=[S|Queda].
     	
/* Cuando hay un 1. El suelo temporalmente es la fila */
     
  recorrefila(Numero,[H|T],[S_in|Resto],Suelo_out):-         
      recorrefila(Numero,T,Resto,Queda),
      H=1,
      mayor(S_in,Numero,S_out),                                 /* Ya esta detectad el suelo por arriba del 1 que se ha encontrado */
      Suelo_out=[S_out|Queda].
      
/* Para cuando el suelo est? por encima, necesita un predicado que determine el mayor de dos cantidades */
      
  mayor(A,B,Mayor):-
      A>B,
      Mayor=A.
      
  mayor(_,M,M).
   
/* Determina si una fila esta llena de 1's */
   
  filallena([]).
  
  filallena([1|Cola]):-
  	filallena(Cola).
  	
/* Quita las filas que est?n llenas de unos */
  
  quitafilas([],Contador_in,Contador_out,Tabla_out):-
     Contador_out=Contador_in,
     Tabla_out=[],!. 
     
  quitafilas([HTabla|TTabla],Contador_in,Contador_out,Tabla_out):- 
     HTabla=[_|Numeros],    
     not(filallena(Numeros)),
     quitafilas(TTabla,Contador_in,Contador_out,Tabla_int),
     Tabla_out=[HTabla|Tabla_int].
     
  quitafilas([H|Tabla_in],Contador_in,Contador_out,Tabla_out):-  /* Es para el caso que la fila de la cabeza est? llena de 1's */
     H=[_|Numeros],
     filallena(Numeros),
     Contador_int=Contador_in-1,
     quitafilas(Tabla_in,Contador_int,Contador_out,Tabla_int),
     Tabla_out=Tabla_int.




/* Sirve para renumerar las que han quedado tras eliminar */
     
  renumera(Tabla,Contador,Limite,Tabla):-
     Contador=Limite.
     
  renumera([Fila|Resto],Contador,Limite,Tabla_out):-   
     Contadorn=Contador+1,     
     renumera(Resto,Contadorn,Limite,Tabla_int),
     Fila=[_|TF],
     NuevaFila=4-(Contadorn),
     
     Filan=[NuevaFila|TF],
     Tabla_out=[Filan|Tabla_int].


/* Sirve para a?adir tantas filas como haya eliminado */     
  anhade(Tabla_int,Contador,Limite,Tabla_out):-
     Contador>=Limite,
     Tabla_out=Tabla_int.

  anhade(Tabla_in,Contador,Limite,Tabla_out):-
     Contadorn = Contador + 1,
     FILAN=[Contadorn,0,0,0,0,0],
     Tabla_int=[FILAN|Tabla_in],
     anhade(Tabla_int,Contadorn,Limite,Tabla_out).




/*Sirve para limpiar las filas que est?n llenas de 1's */
  limpia_filas(Tabla_in,_,Suelo_out,Tabla_out):-
     quitafilas(Tabla_in,4,Quedan,Tabla_int),  /* 4 maximo de filas */
     Quedan<4,                  /* Es para el caso de que se haya quitado alguna fila */
     recorta(Tabla_int,Quedan,[0,0,0,0,0],Tabla_out,Suelo_out).

  limpia_filas(Tabla,Suelo,Suelo,Tabla).
  
  recorta(Tabla_entrada,Restantes,Suelo_entrada,Tabla_out,Suelo_out):-
     /* Renumera las que quedan */
     renumera(Tabla_entrada,0,Restantes,Tabla_semi),
     /* A?ade las nuevas vacias */
     anhade(Tabla_semi,Restantes,4,Tabla_out),
     recalcula_suelo(Suelo_entrada,4,1,Tabla_out,Suelo_out).

/* A Continuaci?n se generan los predicados que modifican el tablero con filas de un tama?o en una posicion */


/* FILAS DE 3 */
  /* Centradas en el 2 */
  modifica([A1,A2,A3,A4,A5],[_,_,_,S4,S5],Fila,2,3,Salida,Suelo_out):-
     A1=0,
     A2=0,
     A3=0,
     S1n=Fila,
     S2n=Fila,
     S3n=Fila,
     Salida=[1,1,1,A4,A5],
     Suelo_out=[S1n,S2n,S3n,S4,S5].


  /* Centradas en el 3 */ 
  modifica([A1,A2,A3,A4,A5],[S1,_,_,_,S5],Fila,3,3,Salida,Suelo_out):-
     A2=0,
     A3=0,
     A4=0,
     S2n=Fila,
     S3n=Fila,
     S4n=Fila,
     Salida=[A1,1,1,1,A5],
     Suelo_out=[S1,S2n,S3n,S4n,S5].

  /* Centradas en el 4 */   
  modifica([A1,A2,A3,A4,A5],[S1,S2,_,_,_],Fila,4,3,Salida,Suelo_out):-
     A3=0,
     A4=0,
     A5=0,
     S3n=Fila,
     S4n=Fila,
     S5n=Fila,
     Salida=[A1,A2,1,1,1],
     Suelo_out=[S1,S2,S3n,S4n,S5n].
     
/* FILAS de 2 */
  /* Centradas en el 1 */
  modifica([A1,A2,A3,A4,A5],[_,_,S3,S4,S5],Fila,1,2,Salida,Suelo_out):-
     A1=0,
     A2=0,
     S1n=Fila,
     S2n=Fila,
     Salida=[1,1,A3,A4,A5],
     Suelo_out=[S1n,S2n,S3,S4,S5].
     
  /* Centradas en el 2 */
  modifica([A1,A2,A3,A4,A5],[S1,_,_,S4,S5],Fila,2,2,Salida,Suelo_out):-
     A2=0,
     A3=0,
     S2n=Fila,
     S3n=Fila,
     Salida=[A1,1,1,A4,A5],
     Suelo_out=[S1,S2n,S3n,S4,S5].
     
 
  /* Centradas en el 3 */
  modifica([A1,A2,A3,A4,A5],[S1,S2,_,_,S5],Fila,3,2,Salida,Suelo_out):-
     A3=0,
     A4=0,
     S3n=Fila,
     S4n=Fila,
     Salida=[A1,A2,1,1,A5],
     Suelo_out=[S1,S2,S3n,S4n,S5].
     
    
  /* Centradas en el 4 */
  modifica([A1,A2,A3,A4,A5],[S1,S2,S3,_,_],Fila,4,2,Salida,Suelo_out):-
     A4=0,
     A5=0,
     S4n=Fila,
     S5n=Fila,
     Salida=[A1,A2,A3,1,1],
     Suelo_out=[S1,S2,S3,S4n,S5n].  
     
  /* Centradas en el 5 */
  modifica([A1,A2,A3,A4,A5],[S1,S2,S3,_,_],Fila,5,2,Salida,Suelo_out):-
     A4=0,
     A5=0,
     S4n=Fila,
     S5n=Fila,
     Salida=[A1,A2,A3,1,1],
     Suelo_out=[S1,S2,S3,S4n,S5n].    
     
      
/* FILAS de 1 */
  /* Centradas en el 1 */
  modifica([A1,A2,A3,A4,A5],[S1,S2,S3,S4,S5],_,1,1,Salida,Suelo_out):-
     A1=0,
     Salida=[1,A2,A3,A4,A5],
     S1n=S1+1,
     Suelo_out=[S1n,S2,S3,S4,S5].
  
  /* Centradas en el 2 */      
  modifica([A1,A2,A3,A4,A5],[S1,S2,S3,S4,S5],_,2,1,Salida,Suelo_out):-
     A2=0,
     Salida=[A1,1,A3,A4,A5],
     S2n=S2+1,
     Suelo_out=[S1,S2n,S3,S4,S5].
     
  /* Centradas en el 3 */
  modifica([A1,A2,A3,A4,A5],[S1,S2,S3,S4,S5],_,3,1,Salida,Suelo_out):-
     A3=0,
     Salida=[A1,A2,1,A4,A5],
     S3n=S3+1,
     Suelo_out=[S1,S2,S3n,S4,S5].
     
   /* Centradas en el 4 */
  modifica([A1,A2,A3,A4,A5],[S1,S2,S3,S4,S5],_,4,1,Salida,Suelo_out):-
     A4=0,
     Salida=[A1,A2,A3,1,A5],
     S4n=S4+1,
     Suelo_out=[S1,S2,S3,S4n,S5].
     
   /* Centradas en el 5 */
  modifica([A1,A2,A3,A4,A5],[S1,S2,S3,S4,S5],_,5,1,Salida,Suelo_out):-
     A5=0,
     Salida=[A1,A2,A3,A4,1],
     S5n=S5+1,
     Suelo_out=[S1,S2,S3,S4,S5n].



/* A PARTIR DE AQUI VIENEN LAS INTRODUCCIONES DE LAS FICHAS */
/*  TIPO   1. LA T invertida*/

/*        X  */
/* Ficha XXX*/
/* Orientacion 0 */     
  mete(f(1,0,Columna),Tablero_in,Tablero_out):-  /*es una T.-->1  con la base horizontal --> 0 centrada en el pivote --> 3*/
     Tablero_in=tab(Suelo_in,Tabla_in),

     Columna>1,Columna<5,

     Columna0=Columna-1,
     Columna1=Columna+1,
     obtiene_fila(Fila0,Suelo_in,1,Columna0),           
     obtiene_fila(Fila1,Suelo_in,1,Columna),
     obtiene_fila(Fila2,Suelo_in,1,Columna1),
          
     Fila2n=Fila2+1,
     Fila1n=Fila1+1,
     Fila0n=Fila0+1,
     
     Fila0n<=Fila1n,
     Fila2n<=Fila1n,
     
     Filan=Fila1n,
     Filan<4,
        
     cambia_fila(Tabla_in,Suelo_in,Filan,Columna,3,Tabla_int,Suelo_int),
     Fila22=Filan+1,
     cambia_fila(Tabla_int,Suelo_int,Fila22,Columna,1,Tabla_preout,Suelo_preout),
     limpia_filas(Tabla_preout,Suelo_preout,Suelo_out,Tabla_out),
     Tablero_out=tab(Suelo_out,Tabla_out),
     !.
     

/*       X  */
/*       XX */
/* Ficha X  */
/* Orientacion 1 */  

mete(f(1,1,Columna),Tablero_in,Tablero_out):-  /*es una T.-->1  con la base horizontal --> 0 centrada en el pivote --> 3*/
     Tablero_in=tab(Suelo_in,Tabla_in),
 
     Columna>1,Columna<=5,
     
     Columna0=Columna-1,       
     obtiene_fila(Fila1,Suelo_in,1,Columna0),
     obtiene_fila(Fila2,Suelo_in,1,Columna),
            
     Fila1n=Fila1+1,   
     Fila2n=Fila2+1,
        
     Fila2n<=Fila1n+1,
     
     Filan=Fila1n,
     Filan<3,
     
     Columnan = Columna-1,
     cambia_fila(Tabla_in,Suelo_in,Filan,Columnan,1,Tabla_int,Suelo_int),
     Fila22=Filan+1,
     cambia_fila(Tabla_int,Suelo_int,Fila22,Columnan,2,Tabla_int2,Suelo_int2),
     Fila3=Fila22+1,
     cambia_fila(Tabla_int2,Suelo_int2,Fila3,Columnan,1,Tabla_preout,Suelo_preout),
     limpia_filas(Tabla_preout,Suelo_preout,Suelo_out,Tabla_out),
     Tablero_out=tab(Suelo_out,Tabla_out),
     !.




/*       XXX  */
/* Ficha  X */
/* Orientacion 2 */     
  mete(f(1,2,Columna),Tablero_in,Tablero_out):-  /*es una T.-->1  con la base horizontal --> 0 centrada en la columna --> 3*/
     Tablero_in=tab(Suelo_in,Tabla_in),
     Columna>1,Columna<5,
     Columna0=Columna-1,
     Columna1=Columna+1,
     
     obtiene_fila(Fila0,Suelo_in,1,Columna0),           
     obtiene_fila(Fila1,Suelo_in,1,Columna),
     obtiene_fila(Fila2,Suelo_in,1,Columna1),
          
     Fila2n=Fila2+1,
     Fila1n=Fila1+1,
     Fila0n=Fila0+1,
     
     Fila0n<=Fila1n+1,
     Fila2n<=Fila1n+1,
     
     Filan=Fila1n,
     Filan<4,
     
     cambia_fila(Tabla_in,Suelo_in,Filan,Columna,1,Tabla_int,Suelo_int),
     Fila22=Filan+1,
     cambia_fila(Tabla_int,Suelo_int,Fila22,Columna,3,Tabla_preout,Suelo_preout),
     limpia_filas(Tabla_preout,Suelo_preout,Suelo_out,Tabla_out),
     
     Tablero_out=tab(Suelo_out,Tabla_out),
     !.    
     

/*        X  */
/*       XX  */
/* Ficha  X  */
/* Orientación 3 */     
mete(f(1,3,Columna),Tablero_in,Tablero_out):- 
     Tablero_in = tab(Suelo_in, Tabla_in),     
 
     Columna >= 1, Columna < 5,
     Columna1 = Columna + 1,  

     obtiene_fila(Fila0, Suelo_in, 1, Columna),  
     obtiene_fila(Fila1, Suelo_in, 1, Columna1),  
     
     Fila0n = Fila0 + 1,  
     Fila1n = Fila1 + 1, 
    
     Fila0n<=Fila1n+1,
      
     Filan=Fila1n,
     Filan<3,
     
     cambia_fila(Tabla_in,Suelo_in,Filan,Columna1,1,Tabla_int,Suelo_int),
     Fila22=Filan+1,
     cambia_fila(Tabla_int,Suelo_int,Fila22,Columna,2,Tabla_int2,Suelo_int2),
     Fila3=Fila22+1,
     cambia_fila(Tabla_int2,Suelo_int2,Fila3,Columna1,1,Tabla_preout,Suelo_preout),
     limpia_filas(Tabla_preout,Suelo_preout,Suelo_out,Tabla_out),
     Tablero_out=tab(Suelo_out,Tabla_out),
     !.




/*  TIPO   2. CUADRADO */     
/*               */
/*       XX      */
/* Ficha XX     */
/* Orientacion CUalquiera*/     
mete(f(2,_,Columna),Tablero_in,Tablero_out):-  /*es un cuadrado.-->1  con la base horizontal --> 0 centrada en la esquina izqd --> 3*/
     Tablero_in=tab(Suelo_in,Tabla_in),

     Columna>=1,Columna<5,


     Columna1=Columna+1,       
     obtiene_fila(Fila1,Suelo_in,1,Columna),
     obtiene_fila(Fila2,Suelo_in,1,Columna1),
          
     Fila2n=Fila2+1,
     Fila1n=Fila1+1,
     
     Fila2n <= Fila1n,

     Filan = Fila1n,    
     Filan<4,

     cambia_fila(Tabla_in,Suelo_in,Filan,Columna,2,Tabla_int,Suelo_int),
     Fila22=Filan+1,
     cambia_fila(Tabla_int,Suelo_int,Fila22,Columna,2,Tabla_preout,Suelo_preout),
     limpia_filas(Tabla_preout,Suelo_preout,Suelo_out,Tabla_out),
  
     Tablero_out=tab(Suelo_out,Tabla_out),
     !.



/*TIPO 3. ELE  */
/*             */
/*         X   */
/* Ficha XXX   */
     
mete(f(3,0,Columna),Tablero_in,Tablero_out):-  /*es una L.-->1  con la base horizontal --> 0 centrada en la mitad de Largo --> 3*/
     Tablero_in=tab(Suelo_in,Tabla_in),

     Columna>1,Columna<5,
	
     Columna0=Columna-1,
     Columna1=Columna+1,
     
     obtiene_fila(Fila0,Suelo_in,1,Columna0),           
     obtiene_fila(Fila1,Suelo_in,1,Columna),
     obtiene_fila(Fila2,Suelo_in,1,Columna1),
          
     Fila2n=Fila2+1,
     Fila1n=Fila1+1,
     Fila0n=Fila0+1,
     
     Fila0n<=Fila1n,
     Fila2n<=Fila1n,
     
     Filan=Fila1n,
     Filan<4,


     obtiene_fila(Fila,Suelo_in,1,Columna),
     Filan=Fila+1,Filan<4,
     cambia_fila(Tabla_in,Suelo_in,Filan,Columna,3,Tabla_int,Suelo_int),
     Fila22=Filan+1,
     Columnan=Columna+1,
     cambia_fila(Tabla_int,Suelo_int,Fila22,Columnan,1,Tabla_preout,Suelo_preout),
     limpia_filas(Tabla_preout,Suelo_preout,Suelo_out,Tabla_out),
     
     Tablero_out=tab(Suelo_out,Tabla_out),
     !.
     



     
/*FICHA ELE    */
/*       X     */
/*       X     */
/* Ficha XX    */     
mete(f(3,1,Columna),Tablero_in,Tablero_out):-  /*es una L.-->1  con la base horizontal --> 1 centrada en la columna --> 3*/
     Tablero_in=tab(Suelo_in,Tabla_in),

     Columna>=1,Columna<5,

     Columna1=Columna+1,        
     obtiene_fila(Fila1,Suelo_in,1,Columna),
     obtiene_fila(Fila2,Suelo_in,1,Columna1),
          
     Fila2n=Fila2+1,
     Fila1n=Fila1+1,
     
     Fila2n<=Fila1n,
     
     Filan=Fila1n,
     Filan<3,

     cambia_fila(Tabla_in,Suelo_in,Filan,Columna,2,Tabla_int,Suelo_int),
     Fila22=Filan+1,
     cambia_fila(Tabla_int,Suelo_int,Fila22,Columna,1,Tabla_preint,Suelo_preint),
     Fila3=Fila22+1,
     cambia_fila(Tabla_preint,Suelo_preint,Fila3,Columna,1,Tabla_preout,Suelo_preout),
     limpia_filas(Tabla_preout,Suelo_preout,Suelo_out,Tabla_out),
     
     Tablero_out=tab(Suelo_out,Tabla_out),
     !.


     
/*FICHA ELE    */
/*             */
/*       XXX   */
/* Ficha X     */     
mete(f(3,2,Columna),Tablero_in,Tablero_out):-  /*es una L.-->1  con la base horizontal --> 1 centrada en la columna --> 3*/
     Tablero_in=tab(Suelo_in,Tabla_in),
     
     Columna>1,Columna<5,

     Columna0=Columna-1,
     Columna1=Columna+1,
     obtiene_fila(Fila0,Suelo_in,1,Columna0),           
     obtiene_fila(Fila1,Suelo_in,1,Columna),
     obtiene_fila(Fila2,Suelo_in,1,Columna1),
          
     Fila2n=Fila2+1,
     Fila1n=Fila1+1,
     Fila0n=Fila0+1,
     
     Fila0n<=Fila1n,
     Fila0n<=Fila2n,
     
     Fila2n<=Fila1n,
     
     Filan=Fila0n,
     Filan<4,

     Columnan = Columna - 1,
     cambia_fila(Tabla_in,Suelo_in,Filan,Columnan,1,Tabla_int,Suelo_int),
     Fila22=Filan+1,
     cambia_fila(Tabla_int,Suelo_int,Fila22,Columna,3,Tabla_preout,Suelo_preout),
     limpia_filas(Tabla_preout,Suelo_preout,Suelo_out,Tabla_out),
     
     Tablero_out=tab(Suelo_out,Tabla_out),
     !.


/*FICHA ELE   */
/*       XX   */
/*        X   */
/* Ficha  X   */    
mete(f(3,3,Columna),Tablero_in,Tablero_out):-  /*es una L.-->1  con la base horizontal --> 1 centrada en la columna --> 3*/
     Tablero_in=tab(Suelo_in,Tabla_in),

     Columna>1,Columna<=5,

     Columna0=Columna-1,      
     obtiene_fila(Fila1,Suelo_in,1,Columna0),
     obtiene_fila(Fila2,Suelo_in,1,Columna),

     Fila2n=Fila2+1,
     Fila1n=Fila1+1,
     
     Fila2n<=Fila1n,
     
     Filan=Fila2n,
     Filan<3,

     cambia_fila(Tabla_in,Suelo_in,Filan,Columna,1,Tabla_int,Suelo_int),
     Fila22=Filan+1,
     cambia_fila(Tabla_int,Suelo_int,Fila22,Columna,1,Tabla_preint,Suelo_preint),
     Fila3=Fila22+1,
     Columnan = Columna - 1,
     cambia_fila(Tabla_preint,Suelo_preint,Fila3,Columnan,2,Tabla_preout,Suelo_preout),
     limpia_filas(Tabla_preout,Suelo_preout,Suelo_out,Tabla_out),
     
     Tablero_out=tab(Suelo_out,Tabla_out),
     !.

        
/*FICHA ELE_INV*/
/*             */
/*       X     */
/* Ficha XXX   */     
mete(f(4,0,Columna),Tablero_in,Tablero_out):-  /*es una L.-->1  con la base horizontal --> 0 centrada en la mitad palo largo --> 3*/
     Tablero_in=tab(Suelo_in,Tabla_in),

     Columna>1,Columna<5,
	
     Columna0=Columna-1,
     Columna1=Columna+1,
     
     obtiene_fila(Fila0,Suelo_in,1,Columna0),           
     obtiene_fila(Fila1,Suelo_in,1,Columna),
     obtiene_fila(Fila2,Suelo_in,1,Columna1),
          
     Fila2n=Fila2+1,
     Fila1n=Fila1+1,
     Fila0n=Fila0+1,
     
     Fila1n<=Fila0n,
     Fila2n<=Fila0n,
     
     Filan=Fila0n,
     Filan<4,


     obtiene_fila(Fila,Suelo_in,1,Columna),
     Filan=Fila+1,Filan<4,
     cambia_fila(Tabla_in,Suelo_in,Filan,Columna,3,Tabla_int,Suelo_int),
     Fila22=Filan+1,
     Columnan=Columna-1,
     cambia_fila(Tabla_int,Suelo_int,Fila22,Columnan,1,Tabla_preout,Suelo_preout),
     limpia_filas(Tabla_preout,Suelo_preout,Suelo_out,Tabla_out),
     
     Tablero_out=tab(Suelo_out,Tabla_out),
     !.



/*FICHA ELE_INV*/
/*       XX    */
/*       X     */
/* Ficha X     */ 

mete(f(4,1,Columna),Tablero_in,Tablero_out):-  /*es una L.-->1  con la base horizontal --> 0 centrada en la mitad palo largo --> 3*/

     Tablero_in=tab(Suelo_in,Tabla_in),

     Columna>=1,Columna<5,

     Columna0=Columna+1,      
     obtiene_fila(Fila1,Suelo_in,1,Columna),
     obtiene_fila(Fila2,Suelo_in,1,Columna0),

     Fila2n=Fila2+1,
     Fila1n=Fila1+1,
     
     Fila1n<=Fila2n,
     
     Filan=Fila1n,
     Filan<3,

     cambia_fila(Tabla_in,Suelo_in,Filan,Columna,1,Tabla_int,Suelo_int),
     Fila22=Filan+1,
     cambia_fila(Tabla_int,Suelo_int,Fila22,Columna,1,Tabla_preint,Suelo_preint),
     Fila3=Fila22+1,     
     cambia_fila(Tabla_preint,Suelo_preint,Fila3,Columna,2,Tabla_preout,Suelo_preout),
     limpia_filas(Tabla_preout,Suelo_preout,Suelo_out,Tabla_out),
     
     Tablero_out=tab(Suelo_out,Tabla_out),
     !.





/*FICHA EL
E_INV*/
/*             */
/*       XXX   */
/* Ficha   X   */ 


mete(f(4,2,Columna),Tablero_in,Tablero_out):-  /*es una L.-->1  con la base horizontal --> 0 centrada en la mitad palo largo --> 3*/
     
     Tablero_in=tab(Suelo_in,Tabla_in),

     Columna>1,Columna<5,

     Columna0=Columna-1,
     Columna1=Columna+1,
     obtiene_fila(Fila0,Suelo_in,1,Columna0),           
     obtiene_fila(Fila1,Suelo_in,1,Columna),
     obtiene_fila(Fila2,Suelo_in,1,Columna1),
          
     Fila2n=Fila2+1,
     Fila1n=Fila1+1,
     Fila0n=Fila0+1,
     
     Fila0n<=Fila2n+1,
     Fila1n<=Fila2n+1,
     
     Filan=Fila2n,
     Filan<4,

     Columnan = Columna + 1,
     cambia_fila(Tabla_in,Suelo_in,Filan,Columnan,1,Tabla_int,Suelo_int),
     Fila22=Filan+1,
     cambia_fila(Tabla_int,Suelo_int,Fila22,Columna,3,Tabla_preout,Suelo_preout),
     limpia_filas(Tabla_preout,Suelo_preout,Suelo_out,Tabla_out),
     
     Tablero_out=tab(Suelo_out,Tabla_out),
     !.


/*FICHA ELE_INV*/
/*         X   */
/*         X   */
/* Ficha  XX   */ 

mete(f(4,3,Columna),Tablero_in,Tablero_out):-  /*es una L.-->1  con la base horizontal --> 1 centrada en la columna --> 3*/

     Tablero_in=tab(Suelo_in,Tabla_in),

     Columna>1,Columna<=5,

     Columna0=Columna-1,        
     obtiene_fila(Fila0,Suelo_in,1,Columna0),
     obtiene_fila(Fila1,Suelo_in,1,Columna),
          
     Fila0n=Fila0+1,
     Fila1n=Fila1+1,
     
     Fila0n<=Fila1n,
     
     Filan=Fila1n,
     Filan<3,

     Columnan = Columna - 1,
     cambia_fila(Tabla_in,Suelo_in,Filan,Columnan,2,Tabla_int,Suelo_int),
     Fila22=Filan+1,
     cambia_fila(Tabla_int,Suelo_int,Fila22,Columna,1,Tabla_preint,Suelo_preint),
     Fila3=Fila22+1,
     cambia_fila(Tabla_preint,Suelo_preint,Fila3,Columna,1,Tabla_preout,Suelo_preout),
     limpia_filas(Tabla_preout,Suelo_preout,Suelo_out,Tabla_out),
     
     Tablero_out=tab(Suelo_out,Tabla_out),
     !.

     
     
/*  FIN DE LAS FICHAS  */
     
  cambia_fila([],S,_,_,_,[],S).
  
  cambia_fila([H|T],Suelo_in,Fila,Columna,Ancho,Tabla_out,Suelo_out):-
     H=[FilaH|Resto],
     Fila=FilaH,
     /*write(Fila,'\t',FilaH,'\t',Columna,'\t',Ancho,'\n'),*/
     modifica(Resto,Suelo_in,Fila,Columna,Ancho,Resto_out,Suelo_out),
     H_out=[FilaH|Resto_out],
     Tabla_out=[H_out|T].
     
  cambia_fila([H|T],Suelo_in,Fila,Columna,Ancho,Tabla_out,Suelo_out):-
     /*NO es esta fila */ /*No se producen cambios en el Suelo*/
     cambia_fila(T,Suelo_in,Fila,Columna,Ancho,Tabla_int,Suelo_out),
     Tabla_out=[H|Tabla_int].
     
/* Predicados de inicializaci?n e impresion de resultados */
     
  vacia(Tablero):-     
     Suelo=[0,0,0,0,0],
     Filastab=[[4, 0, 0, 0, 0, 0],
               [3, 0, 0, 0, 0, 0],
               [2, 0, 0, 0, 0, 0],
               [1, 0, 0, 0, 0, 0]],
     Tablero=tab(Suelo,Filastab).
     
  pinta(tab(_,[])).
     
  pinta(tab(Suelo,Tablero)):-
     Tablero=[H|T],
     pintafila(H),
     write('\n'),
     pinta(tab(Suelo,T)).
     
  escribelista([]).
  
  escribelista([H|T]):-
  	write(H,'\t'),
  	escribelista(T).
     
  pintafila([H|T]):-
     write("Fila: ",H,'\t'),
     escribelista(T).

/* Predicado para describir las soluciones de como se colocan las fichas */     
  escribesol([]).
  
  escribesol([H|T]):-
     escribesol(T),
     write(H,'\n').
     
     
/* Empiezan las reglas de colocacion */
/* Columna 1*/ 

	regla(Tab_in, Ficha, 0, 1, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha), 
	    write(" con O = 0, en C = 1"), nl,
	    mete(f(Ficha, 0, 1), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha), 
	    write(" con O = 0, en C = 1"),
	    write("\n\n\n"), nl.

	regla(Tab_in, Ficha, 1, 1, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha), 
	    write(" con O = 1, en C = 1"), nl,
	    mete(f(Ficha, 1, 1), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha), 
	    write(" con O = 1, en C = 1"),
	    write("\n\n\n"), nl.

	regla(Tab_in, Ficha, 2, 1, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha), 
	    write(" con O = 2, en C = 1"), nl,
	    mete(f(Ficha, 2, 1), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha), 
	    write(" con O = 2, en C = 1"),
	    write("\n\n\n"), nl.

	regla(Tab_in, Ficha, 3, 1, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha), 
	    write(" con O = 3, en C = 1"), nl,
	    mete(f(Ficha, 3, 1), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha), 
	    write(" con O = 3, en C = 1"),
	    write("\n\n\n"), nl.

/* Columna 2 */
	regla(Tab_in, Ficha, 0, 2, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 0, en C = 2"), nl,
	    mete(f(Ficha, 0, 2), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 0, en C = 2"),
	    write("\n\n\n"), nl.

	regla(Tab_in, Ficha, 1, 2, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 1, en C = 2"), nl,
	    mete(f(Ficha, 1, 2), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 1, en C = 2"),
	    write("\n\n\n"), nl.

	regla(Tab_in, Ficha, 2, 2, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 2, en C = 2"), nl,
	    mete(f(Ficha, 2, 2), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 2, en C = 2"),
	    write("\n\n\n"), nl.

	regla(Tab_in, Ficha, 3, 2, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 3, en C = 2"), nl,
	    mete(f(Ficha, 3, 2), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 3, en C = 2"),
	    write("\n\n\n"), nl.

/* Columna 3 */
	regla(Tab_in, Ficha, 0, 3, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 0, en C = 3"), nl,
	    mete(f(Ficha, 0, 3), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 0, en C = 3"),
	    write("\n\n\n"), nl.

	regla(Tab_in, Ficha, 1, 3, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 1, en C = 3"), nl,
	    mete(f(Ficha, 1, 3), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 1, en C = 3"),
	    write("\n\n\n"), nl.

	regla(Tab_in, Ficha, 2, 3, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 2, en C = 3"), nl,
	    mete(f(Ficha, 2, 3), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 2, en C = 3"),
	    write("\n\n\n"), nl.

	regla(Tab_in, Ficha, 3, 3, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 3, en C = 3"), nl,
	    mete(f(Ficha, 3, 3), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 3, en C = 3"),
	    write("\n\n\n"), nl.

/* Columna 4 */
	regla(Tab_in, Ficha, 0, 4, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 0, en C = 4"), nl,
	    mete(f(Ficha, 0, 4), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 0, en C = 4"),
	    write("\n\n\n"), nl.

	regla(Tab_in, Ficha, 1, 4, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 1, en C = 4"), nl,
	    mete(f(Ficha, 1, 4), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 1, en C = 4"),
	    write("\n\n\n"), nl.

	regla(Tab_in, Ficha, 2, 4, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 2, en C = 4"), nl,
	    mete(f(Ficha, 2, 4), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 2, en C = 4"),
	    write("\n\n\n"), nl.

	regla(Tab_in, Ficha, 3, 4, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 3, en C = 4"), nl,
	    mete(f(Ficha, 3, 4), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 3, en C = 4"),
	    write("\n\n\n"), nl.

/* Columna 5 */
	regla(Tab_in, Ficha, 0, 5, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 0, en C = 5"), nl,
	    mete(f(Ficha, 0, 5), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 0, en C = 5"),
	    write("\n\n\n"), nl.
	
	regla(Tab_in, Ficha, 1, 5, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 1, en C = 5"), nl,
	    mete(f(Ficha, 1, 5), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 1, en C = 5"),
	    write("\n\n\n"), nl.

	regla(Tab_in, Ficha, 2, 5, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 2, en C = 5"), nl,
	    mete(f(Ficha, 2, 5), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 2, en C = 5"),
	    write("\n\n\n"), nl.

	regla(Tab_in, Ficha, 3, 5, Tab_int) :-
	    write("Pruebo la ficha: T = "), write(Ficha),
	    write(" con O = 3, en C = 5"), nl,
	    mete(f(Ficha, 3, 5), Tab_in, Tab_int),
	    pinta(Tab_int),
	    write("He probado la ficha: T = "), write(Ficha),
	    write(" con O = 3, en C = 5"),
	    write("\n\n\n"), nl.

     
   /* 
  regla(Tab_in,Ficha,_,_,_):-
    write("Backtrack....",'\t'),write("Ficha: ",'\t'),write(Ficha,'\n'),pinta(Tab_in),write('\n'),fail.
  */ 

/* C?digo de backtrack */



  /* CASO BASE */
  
  backtrack([],Tablero,Solucion,Solucion):- 
     write("========================================\n"),
     write("                    SOLUCIÓN FINAL             \n"), 
     write("========================================\n\n"),
     pinta(Tablero),
     escribesol(Solucion).
   
   
  /* CASO RECURSIVO */
  
  backtrack([Ficha | RestoFichas], Tab_in, SolucionParcial, SolucionFinal) :-
     regla(Tab_in, Ficha, Fila, Columna, Tab_int),
     backtrack(RestoFichas, Tab_int, [f(Ficha, Fila, Columna) | SolucionParcial], SolucionFinal).
  
  

  tetris():-
  
     vacia(T),
     
     write("========================================\n"),
     write("=                         ˇ JUGANDO !                             =\n"), 
     write("========================================\n\n"),
     backtrack([1,2,3,3],T,[],Solucion_Final),
     write("\n\nORDEN DE LAS FICHAS: \n\n"),
     write(Solucion_Final,'\n').



goal
  
  tetris().