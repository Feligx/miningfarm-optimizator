%Dado f, A, b, X0 Donde A es la matriz de restricciones, b es el lado
%derecho de las restricciones 
%Paso 0 Encontrar w y Aw
%Quiero reemplazar en cada restriccion y la que de 0 esa es la que esta
%activa para eso cada fila de W son los coeficientes con sus x[s
%respectivos e igualados al b
num_rest = size(A, 1): %Cantidad e filas en la matriz A
%Revisa cuales son las rest activas:

function[x0 = X0,restriccion] = evaluar(valor_evaluado)%Inicializo la x para que no tenga que pedirla al usario ni poonerla cuando llame la funcion
    valor_evaluado = %Poner que reemplace los x[s del punto inicial para poder calcular y sale
end

matriz_A = matrix_rest; %sin formato estandar
X = rest_ig_desig %Vector columna con cada coponente siendo una restricci[on sin sus coeficientes no tengo muy claro esto
b = vec_desigualdades; 
desigualdades = vec_desigualdades_orientacion; % <= corresponde a 1, = corresponde a 0, >= corresponde a -1

Ax_b = [matriz_A desigualdades b];

for i=1: size(X,1) %Numero de rest
    if valor_evaluado(X0,) %La fila i evaluada en el x inicial
end

%Esto de aca abajo crea Aw
for i=1: num_rest
    if i == w(1,i)  %como w es un vec fila le digo que en la dim 1 y que el i de esa pose lo compare con el i actual, esto es para ver que i sea el 
        Aw = A(1,i) %Agregamos las filas correspondientes a las rest activas
    end
end



%Paso 1 Calcular proyector y direccion
