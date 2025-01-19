from heapq import heappush, heappop

class Tetris:
    def __init__(self):
        self.tablero = self.crear_tablero()
        self.suelo = [0, 0, 0, 0, 0]  

    @staticmethod

    def crear_tablero():
        """Crea un tablero vacío."""
        return [[0 for _ in range(5)] for _ in range(4)]

    def obtener_fila(self, columna):
        """Obtiene la fila más alta ocupada en una columna."""
        return self.suelo[columna]

    def recalcular_suelo(self):
        """Recalcula el nivel del suelo basado en el tablero actual."""
        self.suelo = [0] * len(self.tablero[0])

        for col in range(len(self.tablero[0])):  
            
            for fila in range(len(self.tablero)):
               
                if self.tablero[fila][col] == 1:
                    self.suelo[col] =  fila + 1 
                     




    def limpiar_filas(self):
        """Verifica si hay filas llenas, las elimina y mueve las superiores hacia abajo."""
       
        nuevo_tablero = []
        ejemplo = [1, 1, 1, 1, 1]

        

        for fila in self.tablero:
            
            if not(fila == ejemplo):  
                nuevo_tablero.append(fila)
              
        
        while len(nuevo_tablero) < len(self.tablero):
            nuevo_tablero.insert(3, [0] * len(self.tablero[0]))

        self.tablero = nuevo_tablero

        self.recalcular_suelo()


    def meter_ficha(self, ficha):
        """
        Inserta una ficha en el tablero.
        ficha: (tipo, orientacion, columna) -> tupla que describe la ficha.
        """
        tipo, orientacion, columna = ficha

        exito = False  

        if tipo == 1:  # Ficha T
            if orientacion == 0:
                exito = self.insertar_T1_O0(columna)
            elif orientacion == 1:
                exito = self.insertar_T1_O1(columna)
            elif orientacion == 2:
                exito = self.insertar_T1_O2(columna)
            elif orientacion == 3:
                exito = self.insertar_T1_O3(columna)

        elif tipo == 2:
            exito = self.insertar_T2(columna)

        elif tipo == 3:
            if orientacion == 0:
                exito = self.insertar_T3_O0(columna)
            elif orientacion == 1:
                exito = self.insertar_T3_O1(columna)
            elif orientacion == 2:
                exito = self.insertar_T3_O2(columna)
            elif orientacion == 3:
                exito = self.insertar_T3_O3(columna)
            
        elif tipo == 4:
            if orientacion == 0:
                exito = self.insertar_T4_O0(columna)
            elif orientacion == 1:
                exito = self.insertar_T4_O1(columna)
            elif orientacion == 2:
                exito = self.insertar_T4_O2(columna)
            elif orientacion == 3:
                exito = self.insertar_T4_O3(columna)

        if exito:
                self.limpiar_filas()

        return exito

    #
    #        1
    #      1 1 1
    #

    def insertar_T1_O0(self, columna):
        """Inserta una ficha T horizontalmente (orientación 0).
             F
            FFF"""
        if 1 <= columna <= 3:

            fila1n = self.obtener_fila(columna - 1)
            fila2n = self.obtener_fila(columna)
            fila3n = self.obtener_fila(columna + 1)


            if fila1n<=fila2n and fila3n<=fila2n and fila2n <= 2:
                
                self.tablero[fila2n][columna - 1] = 1
                self.tablero[fila2n][columna] = 1
                self.tablero[fila2n][columna + 1] = 1
                
                if fila2n + 1 <= 3:
                    self.tablero[fila2n + 1][columna] = 1
                    self.recalcular_suelo()
                    return True
                else:
                    return False
            else:
                return False
        else:
            return False


    #
    #      1
    #      1 1 
    #      1
    #

    def insertar_T1_O1(self, columna):
            """
            Inserta una ficha 'X' en orientación 1:
            F
            FF
            F   """


            if columna > 0 and columna <= 4:
                

                fila1n = self.obtener_fila(columna - 1)
                fila2n = self.obtener_fila(columna)
                

                if fila1n<=fila2n+1 and fila1n <= 1:
                    self.tablero[fila1n][columna - 1] = 1 

                    if fila1n + 1 <= 2:

                        self.tablero[fila1n + 1][columna - 1] = 1  
                        self.tablero[fila1n + 1][columna] = 1  
                    else:
                        return False
                    
                    if fila1n + 2 <= 3:
                        self.tablero[fila1n + 2][columna - 1] = 1
                        self.recalcular_suelo()
                        return True
                    else:
                        return False
                else:
                    return False
            else:
                return False



    #
    #      
    #     1 1 1 
    #       1
    #

    def insertar_T1_O2(self, columna):
        """
            Inserta una ficha 'X' en orientación 2:
            FFF
             F   
        
        """
        if 1 <= columna <= 3: 
               
    
            fila1n = self.obtener_fila(columna - 1)
            fila2n = self.obtener_fila(columna)
            fila3n = self.obtener_fila(columna + 1)
                 
            if fila1n <= fila2n + 1 and fila3n<=fila2n + 1 and fila2n <=2: 
             
                self.tablero[fila2n][columna] = 1
                
                if fila2n + 1 <= 3:
                    
                    self.tablero[fila2n + 1][columna - 1] = 1
                    self.tablero[fila2n + 1][columna] = 1
                    self.tablero[fila2n + 1][columna + 1] = 1
                    self.recalcular_suelo()
                    return True

                else:
                    return False
            else:
                return False
        else:
            return False


    #
    #       1
    #     1 1 
    #       1
    #


    def insertar_T1_O3(self, columna):
        """
            Inserta una ficha 'X' en orientación 3:
             F
            FF
             F   
        
        """

        if columna >= 0 and columna < 4:  
        

            fila1n = self.obtener_fila(columna)
            fila2n = self.obtener_fila(columna + 1)
          
            if fila1n <= fila2n + 1 and fila2n <= 1:
             
                self.tablero[fila2n][columna + 1] = 1  

                if fila2n + 1 <= 2:
                    self.tablero[fila2n + 1][columna] = 1  
                    self.tablero[fila2n + 1][columna + 1] = 1  
                else:
                    return False

                if fila2n + 2 <= 3:
                    self.tablero[fila2n + 2][columna + 1] = 1 
                    self.recalcular_suelo()
                    return True
                else:
                    return False
            else:
                return False
        else:
            return False


    #
    #     1 1
    #     1 1 
    #       

    def insertar_T2(self, columna):
        """
            Inserta una ficha 'X':
            FF
            FF
        
        """
        if 0 <= columna < 4:  

            fila1n = self.obtener_fila(columna)
            fila2n= self.obtener_fila(columna + 1)


            if fila2n<=fila1n and fila1n <= 2:

                self.tablero[fila1n][columna] = 1
                self.tablero[fila1n][columna + 1] = 1 

                if fila1n + 1 <= 3:
                    self.tablero[fila1n +1][columna] = 1
                    self.tablero[fila1n +1][columna + 1] = 1 
                    self.recalcular_suelo()
                    return True
                else:
                    return False
            else:
                return False
        else:
            return False


    #
    #         1
    #     1 1 1
    #       

    def insertar_T3_O0(self, columna):
        """Inserta una ficha L horizontalmente (orientación 0)."""

        if 1 <= columna <= 3:

            fila1n = self.obtener_fila(columna - 1)
            fila2n = self.obtener_fila(columna)
            fila3n = self.obtener_fila(columna + 1)

            if fila1n<=fila2n and fila3n<= fila2n and fila2n <= 2:
             
                self.tablero[fila2n][columna - 1] = 1
                self.tablero[fila2n][columna] = 1
                self.tablero[fila2n][columna + 1] = 1
               
                if fila2n + 1 <=3:
                    self.tablero[fila2n + 1][columna+1] = 1
                    self.recalcular_suelo()
                    return True
            else:
                return False

        else:
            return False

    #
    #     1    
    #     1 
    #     1 1 

    def insertar_T3_O1(self, columna):
        """Inserta una ficha L horizontalmente (orientación 1)."""

        if 0 <= columna < 4:

            fila1n = self.obtener_fila(columna)
            fila2n= self.obtener_fila(columna + 1)

            if fila2n<=fila1n and fila1n <= 1:
                self.tablero[fila1n][columna] = 1
                self.tablero[fila1n][columna + 1] = 1
                
                if fila1n + 1 <= 2:
                    self.tablero[fila1n + 1][columna] = 1
                else:
                    return False
                if fila1n + 1 <= 3:
                    self.tablero[fila1n + 2][columna] = 1
                    self.recalcular_suelo()
                    return True
                else:
                    return False
            else:
                return False
        else:
            return False

    
    #   
    #     1 1 1 
    #     1  
    #

    def insertar_T3_O2(self, columna):
        """Inserta una ficha L horizontalmente (orientación 2)."""
        if 1 <= columna <= 3: 

            fila1n = self.obtener_fila(columna - 1)
            fila2n = self.obtener_fila(columna)
            fila3n = self.obtener_fila(columna + 1)
         
            if (fila1n<=fila2n or fila1n<=fila3n) and fila1n <= 2 and fila3n<=fila2n: 
             
                self.tablero[fila1n][columna - 1] = 1
                
                if fila1n + 1 <= 3:

                    self.tablero[fila1n+1][columna] = 1
                    self.tablero[fila1n+1][columna - 1] = 1
                    self.tablero[fila1n+1][columna + 1] = 1

                    self.recalcular_suelo()
                    return True
                else:
                    return False
            else:
                return False
        else:
            return False

    #   1 1
    #     1  
    #     1  
    #
    def insertar_T3_O3(self, columna):
        """Inserta una ficha L horizontalmente (orientación 3)."""
        if 1 <= columna <= 4: 
     
            fila1n = self.obtener_fila(columna - 1)
            fila2n = self.obtener_fila(columna)


            if fila1n<=fila2n+2  and fila2n <= 1: 
            
            
                self.tablero[fila2n][columna] = 1


                if fila2n + 1 <= 2:
                    self.tablero[fila2n + 1][columna] = 1

                else:
                    return False

                if fila2n + 1 <= 3:
                    self.tablero[fila2n + 2][columna] = 1
                    self.tablero[fila2n + 2][columna - 1] = 1
                    self.recalcular_suelo()
                    
                    self.recalcular_suelo()
                    return True
                else:
                    return False
            else:
                return False
        else:
            return False


    #   
    #     1 
    #     1 1 1 
    #     

    def insertar_T4_O0(self, columna):
        """Inserta una ficha L inversa (orientación 0)."""

        if 1 <= columna <= 3:

            fila1n = self.obtener_fila(columna - 1)
            fila2n = self.obtener_fila(columna)
            fila3n = self.obtener_fila(columna + 1)

            if fila1n<=fila2n and fila3n<= fila2n and fila2n <= 2:
                
                self.tablero[fila2n][columna - 1] = 1
                self.tablero[fila2n][columna] = 1
                self.tablero[fila2n][columna + 1] = 1
                
                if fila2n + 1 <= 3:
                    self.tablero[fila2n + 1][columna - 1] = 1
                    self.recalcular_suelo()
                    return True
                else:
                    return False
            else:
                return False

        else:
            return False

    #   
    #     1 1
    #     1  
    #     1

    def insertar_T4_O1(self, columna):
        """Inserta una ficha L inversa (orientación 1)."""

        if 0 <= columna < 4: 
     

            fila1n = self.obtener_fila(columna)
            fila2n = self.obtener_fila(columna + 1)

         
            if fila2n<=fila1n+2 and fila1n <= 1: 
             
                self.tablero[fila1n][columna] = 1

                if fila1n + 1 <= 2:
                    self.tablero[fila1n + 1][columna] = 1
                else:
                    return False
                
                if fila1n + 2 <= 3:
                    self.tablero[fila1n + 2][columna] = 1
                    self.tablero[fila1n + 2][columna + 1] = 1
                    self.recalcular_suelo()
                    return True
                else:
                    return False
            else:
                return False
        else:
            return False

    #   
    #     1 1 1
    #         1  
    #     

    def insertar_T4_O2(self, columna):
        """Inserta una ficha L inversa (orientación 2)."""
        if 1 <= columna <= 3: 
     
 
            fila1n = self.obtener_fila(columna - 1)
            fila2n = self.obtener_fila(columna)
            fila3n = self.obtener_fila(columna + 1)
         
            if (fila3n<=fila1n or fila3n<=fila2n) and fila3n <= 2: 
             
                self.tablero[fila3n][columna + 1] = 1

                if fila3n + 1 <= 3:
                    self.tablero[fila3n + 1][columna] = 1
                    self.tablero[fila3n + 1][columna - 1] = 1
                    self.tablero[fila3n + 1][columna + 1] = 1
                    self.recalcular_suelo()
                    return True
                else:
                    return False
            else:
                return False
        else:
            return False

    #   
    #         1
    #         1  
    #       1 1     
    #


    def insertar_T4_O3(self, columna):
        """Inserta una ficha L inversa (orientación 3)."""
        if 0 < columna <= 4:


            fila1n = self.obtener_fila(columna - 1)
            fila2n= self.obtener_fila(columna)


            if fila1n<=fila2n and fila2n <= 1:

                self.tablero[fila2n][columna] = 1
                self.tablero[fila2n][columna-1] = 1
                

                if fila2n + 1 <=2:
                    self.tablero[fila2n + 1][columna] = 1
                else:
                    return False
                if fila2n + 2 <=3:
                    self.tablero[fila2n + 2][columna] = 1
                    self.recalcular_suelo()
                    return True
                else:
                    return False
            else:
                return False

        else:
            return False



    def backtrack(self, fichas, index=0):
        if index == len(fichas):  
            return True

        tipo = fichas[index]

        for col in range(5):  # Hay 4 orientaciones posibles
            for orient in range(4):  # Hay 5 columnas en el tablero
                # Guardar estado actual
                tablero_snapshot = [fila[:] for fila in self.tablero]
                suelo_snapshot = self.suelo[:]
                print(f'Pruebo la ficha: T = {tipo} con O = {orient}, en C = {col} ')
                # Intentar colocar la ficha
                if self.meter_ficha((tipo, orient, col)):
                    self.imprimir_tablero()
                    if self.backtrack(fichas, index + 1):  
                        return True

                # Restaurar estado si no funcionó
                self.tablero = tablero_snapshot
                self.suelo = suelo_snapshot

        return False 


    def heuristica(self):
        """
        Calcula el puntaje heurístico de la configuración actual del tablero.
        Penaliza los huecos y las diferencias de altura entre columnas.
        """
        # Penalización por huecos debajo del suelo
        huecos = 0


        for col in range(len(self.suelo)):
            altura = self.suelo[col]
            for fila in range(0, altura):
                if self.tablero[fila][col] == 0:
                    huecos += 1


        # Penalización por desnivel entre columnas
        desnivel = 0
        for i in range(len(self.suelo) - 1):
            desnivel += abs(self.suelo[i] - self.suelo[i + 1])

        # Penalización por altura máxima
        altura_maxima = max(self.suelo)

        puntaje = huecos * 10 + desnivel * 5 + altura_maxima * 2
        print(f"Heurística calculada: huecos={huecos}, desnivel={desnivel}, altura_maxima={altura_maxima}, puntaje={puntaje}")
        return puntaje

    
    def resolver_a_star(self, fichas):
        estado_inicial = (0, 0, [fila[:] for fila in self.tablero], self.suelo[:], [])  # (costo, índice_ficha, tablero, suelo)
        cola = []
        heappush(cola, estado_inicial)  # Insertar estado inicial en la cola de prioridad

        print("Estado inicial agregado a la cola.")

        # Lista para registrar las fichas colocadas exitosamente
        fichas_colocadas = []

        while cola:
            costo_actual, indice_ficha, tablero_actual, suelo_actual, fichas_colocadas = heappop(cola)

            self.tablero = [fila[:] for fila in tablero_actual]
            self.suelo = suelo_actual[:]

            print("###################################################################################\n")
            print(f"Estado actual extraído de la cola: costo_actual={costo_actual}, índice_ficha={indice_ficha}\n")
            self.imprimir_tablero()
            print("###################################################################################\n")

            # Si se han colocado todas las fichas, se encontró una solución
            if indice_ficha == len(fichas):
                print("=======================================")
                print("           SOLUCIÓN FINAL")
                print("=======================================")

                print("\n")
                juego.imprimir_tablero()


                print("\nFichas colocadas:")
                for ficha in fichas_colocadas:
                     print(f"Ficha: tipo={ficha[0]}, orientación={ficha[1]}, columna={ficha[2]}")
                print(f"\nCoste Final:{costo_actual}")
                
                return True

            # Generar vecinos (intentar todas las orientaciones y columnas para la ficha actual)
            tipo = fichas[indice_ficha]
            print(f"Intentando colocar ficha {indice_ficha} (tipo={tipo}).")
            for col in range(5):  # Hay 5 columnas en el tablero
                for orient in range(4):  # Hay 4 orientaciones posibles

                    tablero_snapshot = [fila[:] for fila in self.tablero]
                    suelo_snapshot = self.suelo[:]

                    if self.meter_ficha((tipo, orient, col)):
                        print("================================================================================\n")
                        print(f"Ficha {indice_ficha} colocada: tipo={tipo}, orientación={orient}, columna={col}")

                        g_n = costo_actual + 1  # Cada movimiento tiene un costo real de 1
                        h_n = self.heuristica()  # Heurística para este estado
                        f_n = g_n + h_n

                        print(f"Costo g(n)={g_n}, Heurística h(n)={h_n}, Costo total f(n)={f_n}")
                        
                        # Agregar el vecino a la cola con su puntaje
                        nuevas_fichas_colocadas = fichas_colocadas + [(tipo, orient, col)]
                        heappush(cola, (f_n, indice_ficha + 1, [fila[:] for fila in self.tablero], self.suelo[:],nuevas_fichas_colocadas))
                        print("Estado vecino agregado a la cola.\n\n")
                        self.imprimir_tablero()
                        print("\nFichas colocadas en este estado:")
                        for ficha in nuevas_fichas_colocadas:
                            print(f"Ficha: tipo={ficha[0]}, orientación={ficha[1]}, columna={ficha[2]}")


                    # Restaurar estado si no funcionó
                    self.tablero = tablero_snapshot
                    self.suelo = suelo_snapshot

        print("No se encontró una solución tras explorar todos los estados posibles.")
        return False  


    def imprimir_tablero(self):
        """Imprime el tablero actual con índices de filas y columnas."""
        columnas = len(self.tablero[0])  
        print("   " + " ".join(f"{i:2}" for i in range(columnas)))  
        
        for i, fila in enumerate(reversed(self.tablero)): 
            print(f"{len(self.tablero) - 1 - i:2} " + " ".join(f"{x:2}" for x in fila))
        
        print(f"Suelo: {self.suelo}\n")



  

juego = Tetris()

fichas = [1,2,3,4]

print("=======================================")
print("          ¡ JUGANDO !")
print("=======================================")
                

if juego.resolver_a_star(fichas):
    print("\n¡Se encontró una solución con A*!")
else:
    print("No se encontró una solución.") 