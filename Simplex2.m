%Implementación méotodo simplex
prompt= "Para modo silencioso presione (1), para modo verbose presione (2) ";
respuesta = input(prompt);
if respuesta == 1
	modo_silencioso = 1;
elseif respuesta == 2
	modo_silencioso = 0;
end

%Entrada datos del problema 
max_min = 1; %1 para minimizacion 0 para maximizacion
c = c; %Coeficiente de costos
matriz_A = matrix_rest; %sin formato estandar
b = vec_desigualdades; 
desigualdades = vec_desigualdades_orientacion; % <= corresponde a 1, = corresponde a 0, >= corresponde a -1

Ax_b = [matriz_A desigualdades b];
no_variables = size(c,2);
[filas_A, columnas_A] = size(matriz_A);

%Formato estandar 
if max_min ~= 1
    c = -c;  %si el problema es de maximizacion, pasarlo a un problema de minimizacion (estandar)
end
%Se añadaen las variables de holgura y se convierten a igualdades
matriz_holgura = eye(filas_A);


for k_filasA = 1:filas_A
    if Ax_b(k_filasA,columnas_A+1) == -1
        matriz_holgura(k_filasA,k_filasA) = -1; %Si la desigualdad corresponde a un ≥, se expresa la VH negativa
    end
    if Ax_b(k_filasA,columnas_A+1) == 0
        matriz_holgura(k_filasA,k_filasA) = 0; %Si la desigualdad corresponde a un=, se omite la VH
    end
end
    
matriz_A = [matriz_A matriz_holgura]; 

matriz_A_fase2 = matriz_A;


c_completo = zeros(1, size(matriz_A,2));

for pos_costo = 1:size(c,2)
	%disp(c(1,pos_costo));
	c_completo(1,pos_costo) = c(1,pos_costo); 
end


%Acaba formato estandar
%Comienza fase 1

%Se añaden las Variables Artificiales
x_a = eye(filas_A);
matriz_A = [matriz_A x_a];

i_a = [size(matriz_A,2)-filas_A+1:size(matriz_A,2)];

[filas_A, columnas_A] = size(matriz_A);

%Se selecciona la base 
i_b = [columnas_A-filas_A+1: columnas_A]; %coeficientes de la base
i_n = [1:columnas_A-filas_A]; %coeficientes de las variables no basicas

costos = zeros(1, size(matriz_A,2));



%Cambiar el problema en valor de las V. artificiales

for x_art = i_b
    costos(:, x_art) = 1; %Ahora los costos dependen de las varibales artificiales
end


sol_optima = false;
fase1 = false;
fase2 = false;
while sol_optima ~= true 
   %Comienzan iteraciones
   if modo_silencioso ==false
       disp("Indices Variables básicas");
	   disp(i_b);
	   disp("Dirección de movimiento");
	   disp(gradient(costos))
   end
   
   B = [];
   %disp(matriz_A)
   for j_basicas = i_b
       B = [B matriz_A(:,j_basicas)]; 
   end
   
   X_b = inv(B)*b;
   X = zeros(size(matriz_A,2),1);
   for i = i_b
       X(i,1) = X_b(find(i_b == i),1);  
   end
   
   if modo_silencioso ==false
       disp(X);
   end
   
   %Calcular costos reducidos
   cj = [];
   N = [];
   for c_n = i_n
       cj =  [cj costos(:,c_n)];  %recopilar los costos de las variables no basicas
       N = [N matriz_A(:,c_n)]; %Generar la matriz N con las variables no básicas
   end
   cb = [];
   for c_basico = i_b
       cb =  [cb costos(:,c_basico)];  %recopilar los costos de las variables basicas
   end
   
   C_j = cj - cb*inv(B)*N;
   %disp(C_j);
   
   %consultar si la solución es optima
   cj_negativos = find(C_j<0,1);
   
   if isempty(cj_negativos) == 1 
       if fase1 == false
           x_artificiales_base = [];
           for i_an = i_a
                x_artificiales_base = [x_artificiales_base find(i_b == i_an)]; 
           end
           if isempty(x_artificiales_base) == 0 %Hay variables artificiales en la base  
               for x_art = x_artificiales_base
                   if X_b(x_art,1) ~= 0 %Xa es diferente de 0
                       msg = 'No hay solucion factible.';
                       error(msg);
                   else
                   reemplazo = setdiff(i_n, i_a);
                   i_b(1, x_art) = reemplazo(1,1);
                   reeemplazo(1,1) = []; 
                   fase1 = true;
                   i_n = setdiff(i_n,i_a); %Eliminar artificiales en las no básicas para fase 2
                   matriz_A = matriz_A_fase2;
				   costos = c_completo;
                   continue;
                   end    
               end
          else %No hay variables artificiales en la base
              i_n = setdiff(i_n,i_a); %Eliminar artificiales de las no basicas para fase 2 con el ultimo I_b 
              fase1 = true;
              matriz_A = matriz_A_fase2;
			  costos = c_completo;
              continue;
          end
       end
   end
   
   if isempty(cj_negativos) == 1
       if fase1 == true
           fase2 = true;
           sol_optima = true;
           continue;
       end
   end
   
   cj_min = min(C_j);
   for cji = 1:size(C_j, 2)
       if cj_min == C_j(1,cji)
           cj_minpos = cji;
       end  
   end
   
   %Comenzar cambio de base
   x_in = i_n(1, cj_minpos);
   
   y_k = inv(B)*matriz_A(:, x_in);
   
   if max(y_k)<0
       msg = 'No hay óptimo finito.';
       error(msg);
   end
   br_ykr = [];
   br_ykr_completo = [];
   for r = 1:size(X_b)
       if y_k(r,:) > 0 
       br_ykr = [br_ykr X_b(r,:)/y_k(r,:)]; 
       else
       end
       if y_k(r,:) == 0 
           br_ykr_completo = [br_ykr_completo -1];
       else
           br_ykr_completo = [br_ykr_completo X_b(r,:)/y_k(r,:)];
       end    
   end
   
   valor_x_out = min(br_ykr);
   
   
   for pos = 1:size(br_ykr_completo,2)
       if valor_x_out == br_ykr_completo(1,pos)
           x_out = i_b(1,pos);
       end    
   end
   
   i_b(1, find(i_b==x_out)) = x_in; 
   i_n(1, find(i_n==x_in)) = x_out;  % Buscar Ordenar vector
   
   i_b = sort(i_b);
   i_n = sort(i_n);
   
   
end

disp(X([1:no_variables]));






