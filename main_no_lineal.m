%-----------------------------------------------no lineal-------------------------------------------------------------------------
%myObj = functionsContainer;
%res1 = myObj.func1(a);
%res2 = myObj.func2(x);
%y = functionsContainer.func1(2) % 10



%Esto es un vecor columna con m filas

% BB = num2cell(vector_col_func_rest);
% BBB = reshape( horzcat(BB{:}), size(BB,1), []);

%Alfa1
%vector_col_func_rest = transpose(vector_col_func_rest);

%x = myObj.helper_wrapper(X0,b,A,vector_symb_rest,vector_variables_x,vector_hashrate,vec_desigualdades_orientacion)
helper_wrapper(X0,b,matrix_rest,vector_x,vector_hashrate,vec_desigualdades_orientacion)