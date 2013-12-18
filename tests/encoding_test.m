%%
N = 3;
m = 5;
%k = 12;
x = zeros(N,N);
seeds = zeros(1,N);
for i = 1:N
    %seeds(i) = randi([0,2^k-1]);
    rng(i+123456789);
    x(i,1:N) = randi([0,2^m-1],1,N);
end
y = randi([0,2^m-1],N,1);
x_gf = gf(x,m); y_gf = gf(y,m);
z_gf = x_gf*y_gf;
r_gf = x_gf\z_gf;
fprintf('%d%% of bit decoded correctly.\n',sum(r_gf==y_gf)/N*100)