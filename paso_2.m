function[decider,Xkk,W,Aw] = paso_2(f, direccion,grad_func,W,Aw,A,X0,b,vector_hashrate, matrix_rest, vec_desigualdades_orientacion,vector_variables_x) %Asumiendo que vector_hashrate_triplicado es un vector fila
syms alfa1
syms alfa2
decider  = 0;
Xkk = X0;
Awt = transpose(Aw);
Awtt = inv(Aw*Awt);
Xkk_temp = 0;
if direccion == 0
    miu = -Awtt*Awt*vpa(subs(grad_func,vector_variables_x, transpose(X0))); %No se si es Awt o Aw confirmar
    disp(miu);
    
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
    vector_col_func_rest = matrix_rest*Xkk_temp;
    
%     
%     disp("X + alfa*d");
%     disp(Xkk_temp);
%     disp("Fin X + alfa*d");
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
    
    
    
    disp("Restricciones")
    disp(vector_col_func_rest);
    disp("Fin restricciones")
    
    alfas1_encontrado = solve(vector_col_func_rest,'ReturnConditions',true); %Pues debo especificar con respecto a que variable esta resolviendo como solo es esa talvez no sea necesario
    a = alfas1_encontrado.conditions;%Es el intervalo que cumple todas las rest.
    
    disp(alfas1_encontrado.conditions);
    
%     if class(a) == "sym"
%         msg = "Alfa1 es igual a 0";
%         error(msg);
%     end
    
    
%      cell = cellstr(string(a));
%      str_alfa11 = extractAfter(cell{1}, "z <= "); %Alfamax cota para alfa2
%      disp(str_alfa11);
%      num_alfa11 = str2double(extractBefore(str_alfa11," <= z"));
%      disp("Alfa1");
%      disp(num_alfa11);
%      disp("Fin alfa1");

    
    %Alfa2
    Xkk_temp = X0 + (alfa2*direccion);
    vec_func = 0; %Usar para el grad
    assume(alfa2,'real')
    for i=1: (size(Xkk_temp))
        vec_func = vec_func + Xkk_temp(i,1)*log(Xkk_temp(i,1)+vector_hashrate(i,1));
    end
    %vec_limites = [3 a/2 a];
    %alfa2_encontrado = Ajuste_cuadratico(vpa(subs(f,vector_variables_x,Xkk_temp')), vec_limites, 0.001);
    fun = matlabFunction(vpa(subs(f,vector_variables_x,Xkk_temp')));
    a = 1;
    alfa2_encontrado = fminbnd(fun,0,a);
    
    fplot(fun);
    %alfa2_encontrado = alfa2_encontrado.conditions
%     disp(alfa2_encontrado);
    Xkk = X0 + (alfa2_encontrado*direccion); %Ya le damos un valor a alfa1
    Xkk = double(Xkk);
    %Decider en 2 vuelve a ejecutar desde paso 0 y recalcula W y Aw a
    %pesar de que no sean vacios
    decider = 2;
    return
end
end