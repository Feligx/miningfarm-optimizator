%La matriz M tiene 7 columnas: hashrate, wats,proftit-flux,NICE
%HASH-ETHASH,horas de trabajo de cada maquina
%proftit-eth,proftit-Nice hash
%M = readmatrix(input(prompt,'s')) %Debe estar en la misma carpeta
M = readmatrix('crypto-data-vals.csv');
%inputs dados en la entrega final por el ususario en un csv
prompt = 'Ingrese la ganancia minima';
min_profit = input(prompt);
prompt = 'Ingrese las horas de trabajo maximas diarias';
daily_hours = input(prompt)*size(M,1); %Hacer que cada xi no sea mayor a 18


d = transpose( M(1:end ,size(M,2)-1));
c = [];
for i =1: size(d,2)
    c = [c d(1,i) d(1,i) d(1,i)];
end
profit_moneda1 = M(1:end ,size(M,2)-2);
profit_moneda2 = M(1:end ,size(M,2)-3);
profit_moneda3 = M(1:end ,size(M,2)-4);
vec = []; % REST1
lim_horas = rand(size(M,1),1)*daily_hours ;%hi's 
for i = 1 :size(profit_moneda3,1)
    vec = [vec profit_moneda1(i)/24 profit_moneda2(i)/24 profit_moneda3(i)/24] ;
end
h = ones(1,size(M,1)*3);

matrixp = zeros(size(M,1),size(M,1)*3);%Matriz 39*117 Rest2
j = 1;
for i = 1: size(M,1) %Pues son size*3 unos
    matrixp(i,j ) = 1;
    matrixp(i,j+1 ) = 1;
    matrixp(i,j+2 ) = 1;
    j = j+3;
end

vec_tot_horas = h ;% REST3
matrix_rest = [vec;matrixp;vec_tot_horas]; %Matriz de restricciones
b = M(1:end ,size(M,2));
% <= corresponde a 1, = corresponde a 0, >= corresponde a -1
vec_desigualdades = [min_profit;b;daily_hours];
vec_desigualdades_orientacion = [-1;ones(size(M,1),1);1];
    
