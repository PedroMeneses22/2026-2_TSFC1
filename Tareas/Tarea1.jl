# # Tarea 1

# Tarea 1

# ## 1. Triángulo de Pascal
#
# a. Generen el triángulo de Pascal, hasta cierto orden `ord`, usando una
# matriz de enteros, en la que cada renglón representa un orden distinto.
# Hagan que la apariencia de este vector sea lo más simétrico posible.


"""
Función para crear el triangulo de pascal de orden ord a partir de una matriz de 
enteros cuadrada de longitud ord, en la que cada renglón representa un orden distinto. 
Al principio es una matriz de ceros y poco a poco se va llenando cada renglón hasta formar 
una matriz diagonal que será nuestro triángulo de Pascal.  
"""

function triangulo_pascal(ord::Int)

    #matriz de enteros
    A = zeros(Int, ord, ord)

    for i in 1:ord
        A[i,1] = 1
        A[i,i] = 1

        for j in 2:i-1
            A[i,j] = A[i-1,j-1] + A[i-1,j]
        end
    end
    return A
end


"""
Función que imprime un triangulo simétrico a partir de la diagonal de una matriz cuadrada. 
En el contexto de este problema nos ayudará a ver el triángulo de pascal.
"""

function imprimir_diagonal_triangulo(A::Matrix{Int})

    ord = size(A)[1]
    if size(A)[1] != size(A)[2]
        return "Debe ser una matriz cuadrada"
    
    #Impresión simétrica
    else
        for i in 1:ord
            espacios = " "^(ord - i)
            fila = join(A[i,1:i], " ")
            println(espacios * fila)
        end
    end
end

triangulo_pascal(6)

imprimir_diagonal_triangulo(triangulo_pascal(6))



# b. Usen la matriz creada para generar *otra*, en que todos los números
# pares aparezcan como `false` y los impares como `true`, o alternativamente
# como 0 y 1, respectivamente. Las funciones `isodd` o `iseven` pueden
# serles útiles.
#

"""
Función que convierte cualquier matriz de 2 dimensiones de enteros en una nueva matriz de 
booleanos, si el número es par entonces coloca 'false' y si es impar coloca 'true'.
"""


function par_impar_matriz(mat::Matrix{Int})
    #Mide la matriz 
    rangos = size(mat)
    #Crea una nueva matriz de enteros
    A = zeros(Int, rangos)
    for j in 1:rangos[2]
        for i in 1:rangos[1]
            #Verifica si el número es par o impar
            if isodd(mat[i,j])
                A[i,j] = true
            elseif iseven(mat[i,j])
                A[i,j] = false
            end
        end
    end
    return A
end

par_impar_matriz(triangulo_pascal(6))

imprimir_diagonal_triangulo(par_impar_matriz(triangulo_pascal(6)))


# c. Dibujen (con puntos) todos los valores impares del triángulo de Pascal
# para `ord=256`. Repitan el ejercicio para `ord=1024`.




# ## 2. Triángulo equilátero
#
# Sean $X_1$, $X_2$ y $X_3$ los vértices de un triángulo equilátero en el
# plano. Implementen el siguiente algoritmo.
#
# a. Elijan al azar un punto dentro del triángulo equilátero, que llamaré $Y_0$.
# Es la condición inicial.
# b. Elijan al azar uno de los vértices $X_1$, $X_2$ y $X_3$, que llamaré
# $A_0$.
#
# c. Obtengan el punto medio de $Y_0$ y $A_0$; el
# resultado lo etiquetaremos $Y_1$. Guarden el valor de $Y_1$.
#
# d. Repitan el algoritmo (pasos b y c), paso b para obtener $A_r$, y c para
# obtener $Y_{r+1}$ usando como el punto medio de $A_r$ y
# $Y_{r}$ (obtenido antes), guardando los iterados.
#
# e. Grafiquen todos los iterados $Y_n$ que guardaron, considerando
# muuuuchos puntos.


# ## 3. Proporción distinta
#
# Repitan el ejercicio anterior usando ahora, no el punto medio, sino 1/3
# de la distancia entre el vértice elegido al azar y el iterado $Y_n$.
#
