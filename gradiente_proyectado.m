%Dado f, A, b, vec_rest,vec_symb_rest,X0 Donde A es la matriz de restricciones, b es el lado derecho de las restricciones 
%Paso 0 Encontrar w y Aw
%Xo es un vector fila

function[W,Aw] = paso_init(X0,f,b,A,vector_variables_x)
    Aw = []
    W = []
    %Primero hayar W
    for i=1 :size(A,1) %Pues es una rest por columna
         rest =  A(i,:)
         if rest*X0(1,i) == b(i,1)%Falta decirle la pose de X0
            Aw = [Aw;rest] 
            W = [W i]
         end
    end
    return W,Aw %Talvez sobre esta linea
end

%Paso 1 Calcular proyector y direccion
function[direccion] = paso_1(W,Aw,grad_func)
    I = eye(size(Aw,2)) %Tamano de las columnas de AW
    Awt = transpose(Aw)
    Awtt = inv(Aw*Awt)
    proyector = I - ( Awt * Awtt * Aw)
    direccion = -proyector * grad_func
end

%Paso 2 
function[decider,Xkk,W,Aw] = paso_2(f,direccion,grad_func,W,Aw,A,X0,vector_desigualadades,b,vector_hashrate_triplicado,X) %Asumiendo que vector_hashrate_triplicado es un vector fila
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
          %Decider en 1 retorna el punto optimo
          return decider,Xkk,W,Aw %El decider sera util para saber si ese Xkk es el siguiente punto de la ejecucion(0) o si es el optimo(1) ed ir a paso 1 y repetir todo
      else
          min_miu = min(miu) %Variable dual mas negativa
          dual_mas_neg = find(miu==min_miu) %En teoria me da el indice de la variable dual mas negativa que eliminare de W
          W(:,dual_mas_neg) = []%W es un vector fila y elimina la columna dual_mas_neg asi redifinimos el espacio de trabajo
          Aw(dual_mas_neg,:) = [] %Elimina la fila correspondiente a la restriccion que elimminamos
          return decirder,Xkk,W,Aw %Decider en 0 significa que seguimos iterando
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
       %Alfa1
       vector_col_func_rest = transpose(vector_col_func_rest)
       alfas1_encontrado = solve(vector_col_func_rest,alfa1,'ReturnConditions',True) %Pues debo especificar con respecto a que variable esta resolviendo como solo es esa talvez no sea necesario
       a = alfas1_encontrado.conditions;%Es el intervalo que cumple todas las rest.
       cell = cellstr(string(a));
       num_alfa11 = str2double(extractAfter(cell{1}, strlength(cell{1})-1)); %Alfamax cota para alfa2
       %Alfa2
       Xkk_temp = X0 + (alfa2*direccion)
       
       vec_func = 0 %Usar para el grad
       for i=1: (size(Xkk_temp))
           vec_func = vec_func + Xkk_temp(1,i)*log(Xkk_temp(1,i)*vector_hashrate_triplicado(1,i))
       end
       alfa2_encontrado = solve([vec_func alfa2<=num_alfa11 alfa2>=0 ],alfa2,'ReturnConditions',True)
       b = alfa2_encontrado.conditions;%Es el intervalo que cumple todas las rest.
       cell2 = cellstr(string(b));
       num_alfa22 = str2double(extractAfter(cell2{1}, strlength(cell2{1})-1)); %Alfamax cota para alfa2
       Xkk = X0 + (num_alfa22*direccion) %Ya le damos un valor a alfa1
       %Decider en 2 vuelve a ejecutar desde paso 0 y recalcula W y Aw a
       %pesar de que no sean vacios
       decider = 2
       return decirder,Xkk,W,Aw
   end
end

function[xoptimo] = helper(f,X0,b,A,vector_symb_rest,vector_variables_x,vector_hashrate,grad_func)
    if grad_func == []
        grad_func = gradient(f,vector_variables_x); %Encuentra el gradiente respecto a las variables del vector x
    %PASO 0
    if W == [] & Aw == [] %Talvez sea solo un &
        W,Aw = paso_init(X0,f,b,A,vector_variables_x)
    end
        
    %PASO 0
    %-------------------------------------------------------------------------
    %PASO 1
    direccion = []
    direccion = paso_1(W,Aw,grad_func)
    %PASO 1
    %-------------------------------------------------------------------------
    %PASO 2
    decider = 0
    decider,Xk,W,Aw = paso_2(f,direccion,grad_func,W,Aw,A,X0,vector_desigualadades,b,vector_hashrate_triplicado,X) %Asumiendo que vector_hashrate_triplicado es un vector fila
    if decider == 1
        return Xk %Definirlo para que lo tome de paso 2
    elseif decider == 0 %Itera luego de haber encontrado el nuevo punto Xk
        Aw = []
        W = []
        helper(f,X0,b,A,vector_symb_rest,vector_variables_x,vector_hashrate,grad_func) %Ver como actualizo Aw, W y Xk
    else %Es decir vuelve a iterar por los mius redifiniendo el w en este caso no debe hacer que vuelvan a calcular el A y el W
         helper(f,X0,b,A,vector_symb_rest,vector_variables_x,vector_hashrate,grad_func) %Ver como actualizo Aw, W y Xk
    end
    %PASO 2
    %-------------------------------------------------------------------------
    end
    
function[xoptimo] = helper_wrapper(f,X0,b,A,vector_symb_rest,vector_variables_x,vector_hashrate,grad_func,X)
    f = 0
    for i=1: (size(X))
           f = f + X(1,i)*log(X(1,i)*vector_hashrate_triplicado(1,i))
    end %Define la funcion objetivo
    helper_wrapper(f,X0,b,A,vector_symb_rest,vector_variables_x,vector_hashrate,grad_func)
end