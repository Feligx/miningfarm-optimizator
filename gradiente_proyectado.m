%Dado f, A, b, X0 Donde A es la matriz de restricciones, b es el lado
%derecho de las restricciones 
%Paso 0 Encontrar w y Aw
%Quiero reemplazar en cada restriccion y la que de 0 esa es la que esta
%activa para eso cada fila de W son los coeficientes con sus x[s
%respectivos e igualados al b
num_rest = size(A, 1): %Cantidad e filas en la matriz A
%Revisa cuales son las rest activas:



%Esto de aca abajo crea Aw
for i=1: num_rest
    if i == w(1,i)  %como w es un vec fila le digo que en la dim 1 y que el i de esa pose lo compare con el i actual, esto es para ver que i sea el 
        Aw = A(1,i) %Agregamos las filas correspondientes a las rest activas
    end
end



%Paso 1 Calcular proyector y direccion
