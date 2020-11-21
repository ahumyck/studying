function [] = svm14(Xtrain, Ytrain,limX,limY,C, color, sym)
     N = length(Xtrain);
     H = zeros(N,N);
    for i=1:N
        for j=i:N
            k = getKernel(Xtrain(i,:),Xtrain(j,:));
            H(i,j) = Ytrain(i,1)*Ytrain(j,1)*k;
            H(j,i) = H(i,j);
        end
    end
    f = -ones(N,1);
    Aeq = Ytrain';
    beq=0;
    Alg{1}='trust-region-reflective';
    Alg{2}='interior-point-convex';
    options=optimset('Algorithm',Alg{2},...
    'Display','off',...
    'MaxIter',20);

    alpha = quadprog(H,f,[],[],Aeq,beq,[],[],[],options)/1e7;

    S=find(alpha>0 & alpha < C);
    i = 2;
    while (isempty(S))
        S=find(alpha>0 & alpha < 2*i);
        i = i + 1;
    end

    w=0;
    for i=1:length(S)
        w=w+1e1*alpha(S(i,1))*Ytrain(S(i,1),1)*Xtrain(S(i,1),:);
    end

    b=mean(Ytrain(S',1)' - w*Xtrain(S',:)',2);
    f = @(x1,x2) w(1)*x1+w(2)*x2+b;
    line = ezplot(f,[limX,limY]);
    set(line,'Color',color,'LineWidth',2,'LineStyle',sym);
    scatter(line,2);
end

function [K] = getKernel(X1,X2)
    s = 0.1;
    K = exp(-s*(norm(X1-X2)^2));
end