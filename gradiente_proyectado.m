%Dado f, A, b, vec_rest,vec_symb_rest,X0 Donde A es la matriz de restricciones, b es el lado derecho de las restricciones 
%Paso 0 Encontrar w y Aw
%Xo es un vector fila



classdef gradiente_proyectado 
    methods (Static)
        function[W,Aw] = paso_0(X0,b,A)
            Aw = [];
            W = [];
            %Primero hayar W
            for i=1 :size(A,1) %Pues es una rest por columna
                 rest =  A(i,:);
                 if rest*X0(1,i) == b(i,1)%Falta decirle la pose de X0
                    Aw = [Aw;rest];
                    W = [W i];
                 end
            end
            return
        end

        %Paso 1 Calcular proyector y direccion
        function[direccion] = paso_1(Aw,grad_func)
            I = eye(size(Aw,2)); %Tamano de las columnas de AW
            Awt = transpose(Aw);
            Awtt = inv(Aw*Awt);
            proyector = I - ( Awt * Awtt * Aw);
            direccion = -proyector * grad_func;
        end

        %Paso 2 
        function[decider,Xkk,W,Aw] = paso_2(direccion,grad_func,W,Aw,A,X0,vector_desigualdades,vector_hashrate) %Asumiendo que vector_hashrate_triplicado es un vector fila
           syms alfa1
           syms alfa2
           decider  = 0;
           Xkk = X0;
           Awt = transpose(Aw);
           Awtt = inv(Aw*Awt);
           Xkk_temp = 0;
           if direccion == 0
              miu = -Awtt*Awt*grad_func; %No se si es Awt o Aw confirmar
              if miu >= 0 % Aqui paramos la ejecucion
                  disp('Fin de la ejecucion por miu');
                  decider = 1;
                  %Decider en 1 retorna el punto optimo
                  return %El decider sera util para saber si ese Xkk es el siguiente punto de la ejecucion(0) o si es el optimo(1) ed ir a paso 1 y repetir todo
              else
                  min_miu = min(miu); %Variable dual mas negativa
                  dual_mas_neg = find(miu==min_miu); %En teoria me da el indice de la variable dual mas negativa que eliminare de W
                  W(:,dual_mas_neg) = [];%W es un vector fila y elimina la columna dual_mas_neg asi redifinimos el espacio de trabajo
                  Aw(dual_mas_neg,:) = []; %Elimina la fila correspondiente a la restriccion que elimminamos
                  return %Decider en 0 significa que seguimos iterando
              end
           else
               Xkk_temp = X0 + (alfa1*direccion);%Como alfa es simbolica matlab la usa como variable 
               %vector_col_func_rest = A*Xkk_temp; %Esto puede estar mal pues puede tomarlo como producto de vectores
               vector_col_func_rest = matrix_rest*transpose(Xkk_temp);
               for i=1 :size(vec_desigualdades_orientacion,1) %Las desigualdades saben cuantas rest hay
                   if vec_desigualdades_orientacion(i,1) == 1 %<=
                       vector_col_func_rest(i,:) = [vector_col_func_rest(i,1:end) <= b(i,1)]; %Creo que toca transponer vector func rest antes de pasarlo a solve por la sintax
                   elseif vec_desigualdades_orientacion(i,1) == 0 %==
                       vector_col_func_rest(i,:) = [vector_col_func_rest(i,1:end) == b(i,1)];
                   elseif vec_desigualdades_orientacion(i,1) == -1 %>=
                       vector_col_func_rest(i,:) = [vector_col_func_rest(i,1:end) >= b(i,1)];
                   end
                end
               %Alfa1
               vector_col_func_rest = transpose(vector_col_func_rest);
               alfas1_encontrado = solve(vector_col_func_rest,'ReturnConditions',True); %Pues debo especificar con respecto a que variable esta resolviendo como solo es esa talvez no sea necesario
               a = alfas1_encontrado.conditions;%Es el intervalo que cumple todas las rest.
               cell = cellstr(string(a));
               num_alfa11 = str2double(extractAfter(cell{1}, strlength(cell{1})-1)); %Alfamax cota para alfa2
               %Alfa2
               Xkk_temp = X0 + (alfa2*direccion);
               vec_func = 0; %Usar para el grad
               for i=1: (size(Xkk_temp))
                   vec_func = @(alfa2) vec_func + Xkk_temp(1,i)*log(Xkk_temp(1,i)*vector_hashrate(1,i));
               end
               vec_limites = [0 num_alfa11/2 num_alfa11];
               alfa2_encontrado = Ajuste_cuadratico(vec_func, vec_limites, 0,001);
               Xkk = X0 + (alfa2_encontrado*direccion); %Ya le damos un valor a alfa1
               %Decider en 2 vuelve a ejecutar desde paso 0 y recalcula W y Aw a
               %pesar de que no sean vacios
               decider = 2;
               return
           end
        end

        function[Xk] = helper(vector_input)
            f = cell2sym(vector_input(1,1));
            X0 = cell2mat(vector_input(1,2));
            b = cell2mat(vector_input(1,3));
            A = cell2mat(vector_input(1,4));
            vector_variables_x = vector_input(1,5);
            B = [vector_variables_x{:}];
            
            vector_variables_x = B;
            grad_func = cell2sym(vector_input(1,6));
            vector_hashrate = cell2mat(vector_input(1,7));
            
            W = cell2mat(vector_input(1,8));
            Aw = cell2mat(vector_input(1,9));
            
            vector_desigualdades = cell2mat(vector_input(1,10));
            
            %if grad_func == []
                %grad_func = gradient(f,vector_variables_x); %Encuentra el gradiente respecto a las variables del vector x
            %end
            %PASO 0
            if W == [] && Aw == [] %Talvez sea solo un &
                [W,Aw] = paso_0(X0,b,A);
            end
            %PASO 0
            %-------------------------------------------------------------------------
            %PASO 1
            direccion = [];
            direccion = paso_1(W,Aw,grad_func);
            %PASO 1
            %-------------------------------------------------------------------------
            %PASO 2
            decider = 0;
            Xk = 0;
            [decider,Xk,W,Aw] = paso_2(f,direccion,grad_func,W,Aw,A,X0,vector_desigualdades,b,vector_hashrate); %Asumiendo que vector_hashrate_triplicado es un vector fila
            if decider == 1
                return %Definirlo para que lo tome de paso 2
            elseif decider == 0 %Itera luego de haber encontrado el nuevo punto Xk
                Aw = [];
                W = [];
                vector_input = {f X b A vector_variables_x vector_hashrate grad_func W Aw vector_desigualdades};
                helper(vector_input) %Ver como actualizo Aw, W y Xk
            else %Es decir vuelve a iterar por los mius redifiniendo el w en este caso no debe hacer que vuelvan a calcular el A y el W
                vector_input = {f X b A vector_variables_x vector_hashrate grad_func W Aw vector_desigualdades};
                helper(vector_input) %Ver como actualizo Aw, W y Xk
            end
            %PASO 2
            %-------------------------------------------------------------------------
        end
        %vector_desigualdades que es un vector columna
        function[X_optimo] = helper_wrapper(vector_input)
            X = cell2mat(vector_input(1,1));            
            b = cell2mat(vector_input(1,2));
            A = cell2mat(vector_input(1,3));
            vector_variables_x = vector_input(1,4);
            B = [vector_variables_x{:}];

            vector_variables_x = B;
            
            vector_hashrate = cell2mat(vector_input(1,5));  
            vector_desigualdades = cell2mat(vector_input(1,6));
            f = 0;
            grad_func = [];
            for i=1: (size(vector_variables_x,2))
                f = f + vector_variables_x(1,i)*log(vector_variables_x(1,i)+vector_hashrate(i,1));
            end %Define la funcion objetivo
            grad_func = gradient(f);
            W = [];
            Aw = [];
            vector_input = {f X b A vector_variables_x vector_hashrate grad_func W Aw vector_desigualdades};  
            disp(vector_input);
            X_optimo = helper(vector_input);
            return
        end
    end
end