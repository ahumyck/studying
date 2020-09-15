%Линейный классификатор, основанный на процедуре Робинса-Монро

N=200;

fileData = load('data_equal_1');
X1 = fileData.X1;
fileData = load('data_equal_2');
X2 = fileData.X2;

%Итерационный процесс

Niter = 800;
for l=1:Niter
    for k=1:2
        if(mod(l,2) == 0)
            z(k,l) = X1(k, mod(l/2,200));
        else
            z(k,l) = X2(k, mod((l-1)/2,200));
        end
    end
    
    z(3, l) = 1;
    
    if(mod(l,2) == 0)
        r(l) = 1;
    else
        r(l) = -1;
    end
    
    alpha(l) = 1 / (1 + l);
end

W(1, 1) = 3;
W(2, 1) = 3;
W(3, 1) = 3;
for l=1:Niter
    sum = 0;
    for kk=1:3
        sum = sum + W(kk, l)*z(kk, l);
    end
    
    for k=1:3
        W(k, l + 1) = W(k, l) + alpha(l)*z(k, l)*(r(l) - sum);
    end
end

for t=200:800:200
    WW(:,t/200) = W(:, t);
end
save('w.mat', 'WW');

%Графики
fileData = load('w');
W = fileData.WW;
for s=1:N
    y0(s)= -1 + 3*s/N;
end

for s=1:N
    for tt=1:4
        yRM(tt, s)= (-W(3, tt) - W(1, tt)*y0(s)) / W(2, tt);
    end
    yBAYES1(s) = 1 - y0(s);
end

figure
scatter(X1(1, :),X1(2, :), 5, 'red', 'fill');
hold on
scatter(X2(1, :),X2(2, :), 5, 'green', 'fill');
hold on
scatter(y0, yRM(1, :), 1, 'black', 'fill');
xlim([-1 1])
ylim([-1 1])

