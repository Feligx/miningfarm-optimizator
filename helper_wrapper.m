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
%disp(vector_input);
X_optimo = helper(vector_input);
return
end