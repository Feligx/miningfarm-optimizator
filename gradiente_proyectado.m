%Dado f, A, b, vec_rest,vec_symb_rest,X0 Donde A es la matriz de restricciones, b es el lado derecho de las restricciones 
%Paso 0 Encontrar w y Aw
function[W,Aw,grad_func,matrix_rest] = paso_init(X0,f,b,A,vector_rest,vector_symb_rest,vector_variables_x)
    Aw = []
    W = []
    grad_func = gradient(f,vector_variables_x); %Encuentra el gradiente respecto a las variables del vector x
    %Primero hayar W
    for i=1 :size(matrix_rest,2) %Pues es una rest por columna
         rest =  A(i,:)
         if rest*X0 == b(i,1)
            Aw = [Aw;rest] 
            W = [W i]
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

function[decider,Xkk] = paso_2(f,direccion,grad_func,W,Aw,A,X0,vector_desigualadades,b)
   syms alfa1
   syms alfa2
   decider  = 0
   Xkk = X0
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
          return decirder,Xkk %Decider en 0 significa que seguimos iterando
      end
   else
       Xkk_temp = X0 + (alfa1*direccion)%Como alfa es simbolica matlab la usa como variable 
       vector_col_func_rest = A*Xkk_temp
       for i=1 :size(vector_desigualadades,1)
           if vector_desigualadades(i,1) == -1 %<=
               vector_col_func_rest[i,:] = [vector_col_func_rest[i,:] <= b[i,1]] %Creo que toca transponer vector func rest antes de pasarlo a solve por la sintax
           elseif vector_desigualadades(i,1) == 0 %==
               vector_col_func_rest[i,:] = [vector_col_func_rest[i,:] == b[i,1]]
           elseif vector_desigualadades(i,1) == 1 %>=
               vector_col_func_rest[i,:] = [vector_col_func_rest[i,:] >= b[i,1]]
           end
       end
       vector_col_func_rest = transpose(vector_col_func_rest)
       alfas1_encontrado = solve(vector_col_func_rest,alfa1,'ReturnConditions',True) %Pues debo especificar con respecto a que variable esta resolviendo como solo es esa talvez no sea necesario
       a = alfas1_encontrado.conditionsl;%Es el intervalo que cumple todas las rest.
       cell = cellstr(string(a));
       alfa11 = str2double(cell);
       func_eval_Xkk = %No se bien como plantear esto
       alfa2 = min() %Ver si es posible darle una restriccion o si lo hago con un if si no pos usar una busqueda de linea que puedo llamar desde otro archivo y sale
       Xkk = Xk + (alfa1_encontrado*direccion) %Ya le damos un valor a alfa1
   end
end


function[xoptimo] = helper(X0,f,b,A,vector_rest,vector_symb_rest,vector_variables_x)
    
end