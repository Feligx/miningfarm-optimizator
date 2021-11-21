%Dado f, A, b, vec_rest,vec_symb_rest,X0 Donde A es la matriz de restricciones, b es el lado derecho de las restricciones 
%Paso 0 Encontrar w y Aw
function[W,Aw,grad_func,matrix_rest] = paso_init(X0,f,b,A,vector_rest,vector_symb_rest,vector_variables_x)
    matrix_rest = [vector_rest;vector_symb_rest;b]; %La idea es que en cada columna se vea una restriccion
    grad_func = gradient(f,vector_variables_x); %Encuentra el gradiente respecto a las variables del vector x
    %Primero hayar W
    for i=1 :size(matrix_rest,2) %Pues es una rest por columna
        restric_i = matrix_rest(2,i); %Dim 2 para columnas e i es para la fila correspondiente
        func_rest_i = restric_i(1,1) - restric_i(1,3); %1 para columna y 1 para la fila 1 que es la funcion de la rest y le restamos el b para que al evaluar deba ser 0 si no, no esta activa
        restric_i_evaluada = feval(func_rest_i,X0);%Siento que debo hacer un ciclo para encontrar el vector X0 para indicarle 
        if restric_i_evaluada == 0 %Ed esta activa
            W = W[1,i] %Agrega el i correspondiente a la rest activa en el punto X0
            Aw = Aw[1,A(1,i)] %Agrega la fila correspondiente a la restriccion activa en el punto X0
        end
    end
end

%Paso 1 Calcular proyector y direccion
W = []
Aw = []
grad_func = []
W,Aw,grad_func = paso_init(X0,f,b,A,vector_rest,vector_symb_rest,vector_variables_x)

function[direccion] = paso_1(W,Aw,grad_func)
    I = eye(size(Aw,2)) %Tamano de las columnas de AW
    Awt = transpose(Aw)
    Awtt = inv(Aw*Awt)
    proyector = I - ( Awt * Awtt * Aw)
    direccion = -proyector * grad_func
end

%Paso 2 Esta ya es el wrapper de las otras dos y es la que se llamaara 
direccion = []
direccion = paso_1(W,Aw,grad_func)

function[decider,Xkk] = paso_2(f,direccion,Xk,grad_func,W,Aw,matrix_rest)
   syms alfa1
   syms alfa2
   decider  = 0
   Xkk = Xk
   Awt = transpose(Aw)
   Awtt = inv(Aw*Awt)
   Xkk_temp = 0
   if direccion == 0
      miu = -Awtt*Awt*grad_func %No se si es Awt o Aw confirmar
      if miu >= 0 % Aqui paramos la ejecucion
          disp('Fin de la ejecucion por miu');
          decider = 1;
          return decider,Xkk %El decider sera util para saber si ese Xkk es el siguiente punto de la ejecucion(0) o si es el optimo(1) ed ir a paso 1 y repetir todo
      else
          min_miu = min(miu) %Variable dual mas negativa
          dual_mas_neg = find(miu==min_miu) %En teoria me da el indice de la variable dual mas negativa que eliminare de W
          W(:,dual_mas_neg) = []%W es un vector fila y elimina la columna dual_mas_neg asi redifinimos el espacio de trabajo
          Aw(dual_mas_neg,:) = [] %Elimina la fila correspondiente a la restriccion que elimminamos
          return decirder,Xkk
      end
   else
       Xkk_temp = Xk + (alfa1*direccion)%Como alfa es simbolica matlab la usa como variable 
       alfa1_encontrado = 
       func_eval_Xkk = %No se bien como plantear esto
       alfa2 = min() %Ver si es posible darle una restriccion o si lo hago con un if si no pos usar una busqueda de linea que puedo llamar desde otro archivo y sale
       Xkk_temp = Xk + (alfa1_encontrado*direccion) %Ya le damos un valor a alfa1
   end
end