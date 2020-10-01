clc;
clear;

X1 = load('X1.mat').X1;
X2 = load('X2.mat').X2;
X3 = load('X3.mat').X3;

[M1, B1] = estimation(X1);
[M2, B2] = estimation(X2);
[M3, B3] = estimation(X3);

disp(M1); %M1 = [0; 0];
disp(B1); %B1 = [0.1 0.2; 0.2 0.1];

disp(M2); %M2 = [-0.5; 0.5];
disp(B2); %B2 = [0.2 0; 0 0.2];

disp(M3); %M3 = [1; -1];
disp(B3); %B3 = [0.5 0.0; 0.0 0.1];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
 
 
 
     