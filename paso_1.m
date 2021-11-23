function[direccion] = paso_1(Aw,grad_func, vector_variables_x, X0)
I = eye(size(Aw,2)); %Tamano de las columnas de AW
Awt = transpose(Aw);
Awtt = inv(Aw*Awt);
proyector = I - ( Awt * Awtt * Aw);
%disp(grad_func);
direccion = -proyector * subs(grad_func,vector_variables_x, transpose(X0));
disp("Direccion")
disp(direccion)
disp("Final direccion")
end