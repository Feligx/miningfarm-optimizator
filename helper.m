function[Xk] = helper(vector_input)
k=1;
%disp(k);
f = cell2sym(vector_input(1,1));
X0 = cell2mat(vector_input(1,2));
b = cell2mat(vector_input(1,3));
A = cell2mat(vector_input(1,4));
vector_variables_x = vector_input(1,5);
B = [vector_variables_x{:}];

vector_variables_x = B;
grad_func = cell2sym(vector_input(1,7));
vector_hashrate = cell2mat(vector_input(1,6));

W = cell2mat(vector_input(1,8));
Aw = cell2mat(vector_input(1,9));

vector_desigualdades = cell2mat(vector_input(1,10));

matrix_rest = cell2mat(vector_input(1,11));

vec_desigualdades_orientacion = cell2mat(vector_input(1,12));

%if grad_func == []
%grad_func = gradient(f,vector_variables_x); %Encuentra el gradiente respecto a las variables del vector x
%end
%PASO 0
if isempty(W) && isempty(Aw) %Talvez sea solo un &
    [W,Aw] = paso_0(X0,b,A);
end
%PASO 0
%-------------------------------------------------------------------------
%PASO 1
direccion = [];
direccion = paso_1(Aw,grad_func, vector_variables_x, X0);
%PASO 1
%-------------------------------------------------------------------------
%PASO 2
decider = 0;
Xk = 0;
[decider,Xk,W,Aw] = paso_2(f, direccion,grad_func,W,Aw,A,X0,b,vector_hashrate, matrix_rest, vec_desigualdades_orientacion, vector_variables_x); %Asumiendo que vector_hashrate_triplicado es un vector fila
if decider == 1
    return %Definirlo para que lo tome de paso 2
elseif decider == 0 %Itera luego de haber encontrado el nuevo punto Xk
    Aw = [];
    W = [];
    vector_input = {f Xk b A vector_variables_x vector_hashrate grad_func W Aw vector_desigualdades, matrix_rest, vec_desigualdades_orientacion};
    k=k+1;
    helper(vector_input) %Ver como actualizo Aw, W y Xk
else %Es decir vuelve a iterar por los mius redifiniendo el w en este caso no debe hacer que vuelvan a calcular el A y el W
    vector_input = {f Xk b A vector_variables_x vector_hashrate grad_func W Aw vector_desigualdades, matrix_rest, vec_desigualdades_orientacion};
%     disp(vector_input);
    k=k+1;
    helper(vector_input) %Ver como actualizo Aw, W y Xk
end
%PASO 2
%-------------------------------------------------------------------------
end