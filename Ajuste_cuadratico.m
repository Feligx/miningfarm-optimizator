f = @(x) 0.1*x^2 -2*sin(x);

x = [0 1 4];
e = 0.001;
k =1;

b_23 = x(1,2)^2-x(1,3)^2;
b_31 = x(1,3)^2-x(1,1)^2;
b_12 = x(1,1)^2-x(1,2)^2;

a_23 = x(1,2)-x(1,3);
a_31 = x(1,3)-x(1,1);
a_12 = x(1,1)-x(1,2);

x_gorro = (b_23*f(x(1,1))+b_31*f(x(1,2))+b_12*f(x(1,3)))/(2*(a_23*f(x(1,1))+a_31*f(x(1,2))+a_12*f(x(1,3))));


while x(1,3) - x(1,1) > e
	if x_gorro > x(1,2)
		if f(x_gorro) > f(x(1,2))
			x = [x(1,1) x(1,2) x_gorro];
		else
			x = [x(1,2) x_gorro x(1,3)];
		end
	elseif x_gorro < x(1,2)
		if f(x_gorro) <= f(x(1,2))
			x = [x(1,1) x_gorro x(1,2)];
		else
			x = [x_gorro x(1,2) x(1,3)];
		end
	else
		if x(1,2) - x(1,1) < x(1,3) - x(1,2)
			x_gorro = x(1,2)+(e/2);
			continue
		else
			x_gorro = x(1,2)-(e/2);
			continue
		end
	end
	b_23 = x(1,2)^2-x(1,3)^2;
	b_31 = x(1,3)^2-x(1,1)^2;
	b_12 = x(1,1)^2-x(1,2)^2;

	a_23 = x(1,2)-x(1,3);
	a_31 = x(1,3)-x(1,1);
	a_12 = x(1,1)-x(1,2);

	x_gorro = (b_23*f(x(1,1))+b_31*f(x(1,2))+b_12*f(x(1,3)))/(2*(a_23*f(x(1,1))+a_31*f(x(1,2))+a_12*f(x(1,3))));
end

resultado = "El óptimo es ";
resultado = strcat(resultado, num2str(x(1,2)));
disp(resultado);

%El resultado es 1.4276