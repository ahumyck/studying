M1 = [0;0];
M2 = [1;-1];
M3 = [1;1];

B1 = [0.0100    0.0200;0.0200    0.1300];
B2 = [0.0400    0.0600;0.0600    0.1000];
B3 = [0.0900    0.0300;0.0300    0.0500];

X1 = gennormvec(M1, B1, n, N);
X2 = gennormvec(M2, B2, n, N);
X3 = gennormvec(M3, B3, n, N);

Y1 = gennormvec(M1, B2, n, N);
Y2 = gennormvec(M3, B2, n, N);