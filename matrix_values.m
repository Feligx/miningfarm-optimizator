%inputs dados en la entrega final por el ususario en un csv
min_profit = 400
daily_hours = 18*39 %Hacer que cada xi no sea mayor a 18

M = readmatrix('crypto-data-vals.csv')

c = transpose( M(1:end ,size(M,2)))
profit_moneda1 = M(1:end ,size(M,2)-1)
profit_moneda2 = M(1:end ,size(M,2)-2)
profit_moneda3 = M(1:end ,size(M,2)-3)
vec = [] % REST1
lim_horas = rand(size(M,1),1)*daily_hours %hi's 
for i = 1 :size(profit_moneda3,1)
    vec = [vec profit_moneda1(i)/24 profit_moneda2(i)/24 profit_moneda3(i)/24] 
    %vec2 = [vec profit_moneda1(i) profit_moneda2(i) profit_moneda3(i)] 
end
h = ones(1,size(M,1))
matrix_rest_maq = diag(h)% REST2
vec_tot_horas = h % REST3

matrix_rest = [vec;matrix_rest_maq;vec_tot_horas] %Matriz de restricciones


    
