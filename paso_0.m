function[W,Aw] = paso_0(X0,b,A)
Aw = [];
W = [];
%disp(X0);
%Primero hayar W
for i=1 :size(A,1) %Pues es una rest por columna
    rest =  A(i,:);
    if rest*X0 == b(i,1)%Falta decirle la pose de X0
        disp(i);
        disp(rest*X0);
        Aw = [Aw;rest];
        W = [W i];
    end
end
disp(W);
return
