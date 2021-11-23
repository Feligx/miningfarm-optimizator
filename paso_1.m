function[direccion] = paso_1(Aw,grad_func)
I = eye(size(Aw,2)); %Tamano de las columnas de AW
Awt = transpose(Aw);
Awtt = inv(Aw*Awt);
proyector = I - ( Awt * Awtt * Aw);
disp(grad_func);
direccion = -proyector * grad_func;
end