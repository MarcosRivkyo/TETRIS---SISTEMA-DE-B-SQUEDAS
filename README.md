Fundamentos de Sistemas Inteligentes

Práctica de Sistemas de Búsqueda
“JUGANDO AL TETRIS”

Se plantea desarrollar sendos algoritmos para que un ordenador juegue al Tetris con suma
destreza. Las fichas son las conocidas
- Tipo 1. -Forma T. Centrada en el elemento central
- Tipo 2. - Forma Cuadrado. Centrada en la esquina inferior izquierda
- Tipo 3. - Forma L. Centrada en el medio de elemento largo
- Tipo 4. - Forma L invertida. Centrada en el medio de elemento largo
- Tipo 5. - Forma Subida. Centrada en la esquina de subida (Implementación
opcional)
- Tipo 6. - Forma Bajada. Centrada en la esquina de bajada (Implementación
opcional)
- Tipo 7. - Forma Palo. 4 piezas alineadas. Centrada en el segundo elemento
(Implementación opcional)
Como todo el mundo conoce las fichas se pueden desplazar de izquierda a derecha,
siempre que entren, y pueden girar de forma que puedan adquirir las 4 orientaciones
numeradas del 0 al 3.
Cuando una fila está llena de elementos se borran la fila completa dejando espacio. Gana
el jugador si consigue colocar todas las piezas de una secuencia conocida que se
proporciona como dato entrada. Se considera como índice la altura de la composición de
fichas (la variable suelo que se proporciona)
Práctica 1.- Implementación en Prolog.
Se implementará una estrategia de Backtrack no informada. Se proporciona al alumno una
parte significativa del código donde se podrán observar “HUECOS”.
Figura 1.- Ejemplo de zona vacía donde se espera que el alumno introduzca código
Éstos se deben rellenar para el correcto funcionamiento del código. Asimismo, el alumno
debe analizar los principales predicados del código proporcionando en un informe la
descripción (interpretación) de los principales predicados del código. En todos los casos la
entrada es la secuencia de tipos de ficha a colocar, esto es: [1 2 3 3] y la salida los
movimientos (orientación y columna) para cada una de las 4 piezas implicadas.
Para facilitar el proceso, se entiende que el tablero es de anchura 5 y altura 4. El alumno
puede realizar las modificaciones para otros casos.
Práctica 2.- Implementación en otro lenguaje de una estrategia de exploración de
grafos A*.
El alumno debe proponer una heurística para que se produzca la mejor solución. ¿Cómo
mediría la calidad de la solución? Esta debe ser el punto de partida para la definición de
función heurística
En este caso el alumno debe realizar una implementación del sistema de producción
propuesto (Tablero vacio y lista de figuras a colocar) mediante una estrategia de búsqueda
de exploración de grafos A*. El algoritmo implementado debe ser A* sin excepciones en sus
funcionalidades
