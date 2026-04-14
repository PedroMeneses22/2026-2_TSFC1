# # Tarea 2: Diferenciación automática

# ## Ejercicio 1
#
# a. Definan una estructura en Julia `Dual` que represente a los números duales;
# los nombres de los campos internos serán `fun` y `der`.
# Por sencillez, pueden considerar que los campos de `Dual` son del tipo `Float64`,
# aunque pueden *osar* a implementar el caso paramétrico `Dual{T <: Real}`,
# donde `T` es el tipo de *ambos* campos.

struct Dual{T<:Real}
	fun::T
	der::T
end
#
# b. Sobrecarguen las operaciones aritméticas (en Base) de tal manera que cuando involucren `Dual`es den el resultado correcto.
#

#Sobrecargamos la función suma para los Duales
function Base.:+(u::Dual, w::Dual)
	return Dual(u.fun + w.fun, u.der + w.der)
end

#Sobrecargamos la función resta para los Duales
function Base.:-(u::Dual, w::Dual)
	return Dual(u.fun - w.fun, u.der - w.der)
end

#Sobrecargamos la función producto para los Duales
function Base.:*(u::Dual, w::Dual)
	return Dual(u.fun * w.fun, u.der * w.fun + u.fun * w.der)
end

#Sobrecargamos la función división para los Duales
function Base.:/(u::Dual, w::Dual)
    @assert w.fun != 0 "Error! Para u/w donde u y w son duales, w.fun debe de ser distinto de cero."
	return Dual(u.fun / w.fun, (u.der - (u.fun / w.fun) * w.der) / w.fun)
end

#Sobrecargamos la función potencia para los duales
function Base.:^(u::Dual, n::Real)
	return Dual(u.fun ^ n, n* u.der * u.fun ^(n - 1))
end




# c. Definan un método específico para crear duales (constructor externo), a partir de
# un sólo valor (en lugar de los dos requeridos). Esto corresponderá a
# $\mathbb{D}_{x_0}c = (c, 0)$, donde $c$ es una constante (real).
#

#Nombrando la función constante como f(x) = cons:
Dual(cons::T) where {T<:Real} = Dual{T}(cons, zero(T))

# d. Extiendan los métodos que permitan sumar/restar y multiplicar/dividir un
# número (`::Real`) y un `::Dual`. (Recuerden que ciertas operaciones son conmutativas!).
# NOTA: Este ejercicio lo pueden hacer escribiendo todos los métodos, uno a uno. Otra
# opción es usar `promote` y `convert` para definir reglas de promoción y conversión;
# la documentación de Julia tiene más información sobre esto.

begin
    #=
    Definimos la conversión a que cualquier número, pueda verse como $\mathbb{D}_{x_0}c = (c, 0)$
    =#

    Base.convert(::Type{Dual}, cons::T) where {T<:Real} = Dual{T}(cons, zero(T))

    #=
    Definimos la promoción: si tenemos un dual del tipo Dual{T} donde T<:Real y un número del tipo S<:Real
    Entonces va promover ya sea T o S al tipo S o T, para que sean del mismo tipo.   
    =#

    Base.promote_rule(::Type{Dual{T}}, ::Type{S}) where {T<:Real, S<:Real} = Dual{promote_type(T,S)}

    #Ahora definamos los métodos para sumar/restar y multiplicar/dividir un número (::Real) y un ::Dual.
    #Suma
    Base.:+(u::T, w::Dual) where {T<:Real} = +(promote(u,w)...)
    #Resta
    Base.:-(u::T, w::Dual) where {T<:Real} = -(promote(u,w)...)
    #Producto
    Base.:*(u::T, w::Dual) where {T<:Real} = *(promote(u,w)...)
    #División
    Base.:/(u::T, w::Dual) where {T<:Real} = /(promote(u,w)...)
    
end


#
# e. Definan las funciones `fun` y `der` que, al ser aplicadas a un `Dual` devuelven
# la parte que corresponde a la función y la parte que corresponde a la derivada
# del `Dual`, respectivamente.
#
fun(u::Dual) = u.fun
der(u::Dual) = u.der

# f. Incluyan varios casos (propuestos por ustedes mismos) donde se *compruebe*
# que lo que
# implementaron da el resultado que debería ser. Para esto, pueden usar la librería
# estándard [`Test`](https://docs.julialang.org/en/v1/stdlib/Test/) de Julia.

using Test

@testset "Pruebas Dual" begin

    #Punto de evaluación
    a = 2.0
    u = Dual(a, 1.0)


    #1. Suma
    f = u + u
    @test fun(f) ≈ 2a
    @test der(f) ≈ 2.0

    #2. Producto
    f = u * u   # a^2
    @test fun(f) ≈ a^2
    @test der(f) ≈ 2a

    #3. División
    f = u / u   # 1
    @test fun(f) ≈ 1.0
    @test der(f) ≈ 0.0

    #4. Potencia
    f = u^3
    @test fun(f) ≈ a^3
    @test der(f) ≈ 3a^2

    #5. Función compuesta (polinomio)
    #f(x) = x^3 + 2x
    f = u^3 + 2u
    @test fun(f) ≈ a^3 + 2a
    @test der(f) ≈ 3a^2 + 2

    #6. Mezcla Dual y Real
    f = u + 3
    @test u + 3 == 3 + u
    @test u - 3 == -1*(3 - u)
    @test fun(f) ≈ a + 3
    @test der(f) ≈ 1.0

    f = 3 * u
    @test 3 * u == u * 3  
    @test fun(f) ≈ 3a
    @test der(f) ≈ 3.0

    f = u/3
    @test fun(f) ≈ a/3
    @test der(f) ≈ 1/3

    f = 3/u
    @test fun(f) ≈ 3/a
    @test der(f) ≈ - (3/a)*(1.0)/a

    #7. Función no Trivial
    #f(x) = (x^2 + 1)/(x + 1)
    f = (u^2 + 1) / (u + 1)

    @test fun(f) ≈ (a^2 + 1)/(a + 1)

    #derivada analítica:
    #f' = [(2x)(x+1) - (x^2+1)] / (x+1)^2
    @test der(f) ≈ ((2a)*(a+1) - (a^2+1)) / (a+1)^2
end

# ## Ejercicio 2
#
# Definan una nueva función `dual(x_0)` cuyo resultado sea un `Dual` que corresponde
# a la variable independiente $x$ evaluada en `x_0`. Con esta función
# obtengan $f'(2)$ para la función
# ```math
# f(x) = \frac{3x^2-8x+1}{7x^3-1}.
# ```

#Definiremos la función dual(x_0) como:

dual(x_0::T) where {T<:Real} = Dual{T}(x_0, one(T))
#=
Por propiedades de los duales ocurrirá que para una función f(x) con derivada f'(x), f(dual(x_0)) va a ser un
número dual tal que fun(f(dual(x_0))) = f(x_0) y der(f(dual(x_0))) = f'(x_0). Entonces, para la función (que 
llamaremos g) dada en el problema tendremos que:
=#

g(x) = (3x^2-8x+1)/(7x^3-1)
gd = g(dual(2))

#Derivando g, tenemos que g'(x) = (8 - 6x - 21x^2 + 112x^3 - 21x^4)/(7x^3 - 1)^2
g′(x) = (8 - 6x - 21x^2 + 112x^3 - 21x^4)/(7x^3 - 1)^2

#Veamos der(gd) y g'(2):
der(gd)
g′(2)

#Notemos que:
der(gd) == g′(2)

# ## Ejercicio 3
#
# - A partir de lo visto en clase, *extiendan* las funciones elementales usuales para que funcionen con Duales, es decir, `sin(a::Dual)`, `cos(a::Dual)`, `tan(a::Dual)`, `^(a::Dual, n::Int)`, `sqrt(a::Dual)`, `exp(a::Dual)` y `log(a::Dual)`.
#
# - Al igual que antes, construyan algún conjunto de pruebas que muestre, de manera
# sencilla, que lo que hicieron da lo que uno esperaría obtener.
