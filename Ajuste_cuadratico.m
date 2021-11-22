function [resultado] = Ajuste_cuadratico(f, x, e)
%f es la funcion a aproximar, x es el vector de 3 puntos de los rangos
%propios del metodo los cuales son 0, alpha1/2 y alpha1 (analogamente se hace lo mismo con alpha 2)
% y e es el error minimo al que queremos aproximarnos

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
    resultado = x(1,2);
    return
end
