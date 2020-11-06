function sko = SKO(u, g, X1, X2)
    W = (u*u.')^(-1)*u*g;
    syms x y
    sko = W(1:2)'*[x; y]+W(3);

    for i=1:200
        d1sko(i) = (W(1)*X1(1,i)+W(2)*X1(2,i)) + W(3);
        d2sko(i) = (W(1)*X2(1,i)+W(2)*X2(2,i)) + W(3);
    end
    fprintf("p1_SKO = %f\n", size(d1sko(d1sko<0),2)/200);
    fprintf("p2_SKO = %f\n", size(d2sko(d2sko>0),2)/200);
end