function [ fisher ] = Fisher( M1, M2, R1, R2, X1, X2 )
    W = (0.5*(R1 + R2))^(-1)*(M2 - M1);
    D1 = W.'*R1*W;
    D2 = W.'*R2*W;
    wN = -((M2 - M1).' * (1/2 *(R2 + R1))^(-1) * (D2*M1+D1*M2)  ) / (D1+D2);
    syms x y;
    fisher = W.'*[x; y]+wN;
    for i=1:200
        d1fishera(i) = (W(1)*X1(1,i)+W(2)*X1(2,i)) + wN;
        d2fishera(i) = (W(1)*X2(1,i)+W(2)*X2(2,i)) + wN;
    end
    fprintf("p1_fishera = %f\n", size(d1fishera(d1fishera>0),2)/200);
    fprintf("p2_fishera = %f\n", size(d2fishera(d2fishera<0),2)/200);
end
