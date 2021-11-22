%-----------------------------------------------no lineal-------------------------------------------------------------------------
%myObj = functionsContainer;
%res1 = myObj.func1(a);
%res2 = myObj.func2(x);
%y = functionsContainer.func1(2) % 10
X0 = X([1:size(matrix_rest,2)])
vector_x = sym('x', [1 size(matrix_rest,2)]) %Vector fila de las xis
vector_col_func_rest = size(matrix_rest,2)*vector_x; %Esto es un vecor columna con m filas
for i=1 :size(vec_desigualdades_orientacion,1) %Las desigualdades saben cuantas rest hay
   if vec_desigualdades_orientacion(i,1) == 1 %<=
       vector_col_func_rest(i,1:end) = [vector_col_func_rest(i,1:end) <= b(i,1)]; %Creo que toca transponer vector func rest antes de pasarlo a solve por la sintax
   elseif vec_desigualdades_orientacion(i,1) == 0 %==
       vector_col_func_rest(i,1:end) = [vector_col_func_rest(i,1:end) == b(i,1)];
   elseif vec_desigualdades_orientacion(i,1) == -1 %>=
       vector_col_func_rest(i,1:end) = [vector_col_func_rest(i,1:end) >= b(i,1)];
   end
end
BB = num2cell(vector_col_func_rest);
BBB = reshape( horzcat(BB{:}), size(BB,1), []);

%Alfa1
vector_col_func_rest = transpose(vector_col_func_rest);
alfas1_encontrado = solve(vector_col_func_rest,alfa1,'ReturnConditions',True); %Pues debo especificar con respecto a que variable esta resolviendo como solo es esa talvez no sea necesario
a = alfas1_encontrado.conditions;%Es el intervalo que cumple todas las rest.
cell = cellstr(string(a));
num_alfa11 = str2double(extractAfter(cell{1}, strlength(cell{1})-1)); %Alfamax cota para alfa2

%x = myObj.helper_wrapper(X0,b,A,vector_symb_rest,vector_variables_x,vector_hashrate,vec_desigualdades_orientacion)
helper_wrapper(X0,b,matrix_rest,vector_variables_x,vector_hashrate,vec_desigualdades_orientacion)