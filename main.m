% main 
clearvars
clc

sim_times = 20;

for t = 1 : sim_times
t
U_i = 5;
U_j = 6;
%SINR = zeros(U_i, U_j);
SINR_ij = randi(30, U_i, U_j);
SINR_ji = randi(30, U_j, U_i);
SINR_agg = SINR_ij + SINR_ji';
SINR_threshold = 10;
% build the adjacent matrix
adj = zeros(U_i, U_j);
for i = 1 : U_i
    for j = 1 : U_j
        if SINR_ij(i, j) >= SINR_threshold && SINR_ji(j, i) >= SINR_threshold
            adj(i, j) = 1;
        end
    end
end
% build the weight matrix
max_val = max(SINR_agg, [], 'all');
weight = zeros(max(U_i, U_j));
for i = 1 : U_i
    for j = 1 : U_j
        weight(i, j) = max_val - SINR_agg(i, j);
    end
end


%% bipartite
[p_x, p_y, pair] = user_pairing_bipartite(adj);
% plot 
topo_i = zeros(U_i, 2) + 1;
for n = 1 : U_i
    topo_i(n, 1) = n;
end
topo_j = zeros(U_j, 2) + 3;
for n = 1 : U_j
    topo_j(n, 1) = n;
end

figure(1);
clf;
title('bipartite user-pairing', 'FontSize', 14);
hold on;
plot(topo_i(:, 1), topo_i(:, 2), 'bo');
plot(topo_j(:, 1), topo_j(:, 2), 'ro');
for n = 1 : U_i 
    txt = sprintf('u%d', n);
    text(n, 0.8, txt);
end
for n = 1 : U_j
    txt = sprintf('v%d', n);
    text(n, 3.2, txt);
end
for n = 1 :U_i
    if ~p_x(n)
       continue; 
    end
    plot([topo_i(n, 1),topo_j(p_x(n), 1)],[topo_i(n, 2), topo_j(p_x(n), 2)], 'g');
end
hold off;
x_len = max(U_i, U_j) + 1;
axis([0 x_len 0 4]);
% print the sumrate
sumrate_i_bi = 0;
sumrate_j_bi = 0;

for n = 1 : U_i
   if ~p_x(n)
       continue;
   end
   sumrate_i_bi = sumrate_i_bi + SINR_ij(n, p_x(n));
end
for n = 1 : U_j
   if ~p_y(n)
       continue;
   end
   sumrate_j_bi = sumrate_j_bi + SINR_ji(n, p_y(n));
end

sumrate_i_bi
sumrate_j_bi
sumrate_bi = sumrate_i_bi + sumrate_j_bi

%% hungarian
[Z, cost] = user_pairing_hungarian(weight);
% plot 
topo_i = zeros(U_i, 2) + 1;
for n = 1 : U_i
    topo_i(n, 1) = n;
end
topo_j = zeros(U_j, 2) + 3;
for n = 1 : U_j
    topo_j(n, 1) = n;
end

figure(2);
clf;
title('hungarian user-pairing', 'FontSize', 14);
hold on;
plot(topo_i(:, 1), topo_i(:, 2), 'bo');
plot(topo_j(:, 1), topo_j(:, 2), 'ro');
for n = 1 : U_i 
    txt = sprintf('u%d', n);
    text(n, 0.8, txt);
end
for n = 1 : U_j
    txt = sprintf('v%d', n);
    text(n, 3.2, txt);
end
for i = 1 : U_i
    for j = 1 : U_j
        if Z(i,j)
            plot([topo_i(i, 1),topo_j(j, 1)],[topo_i(i, 2), topo_j(j, 2)], 'g');
        end
    end
end
hold off;
x_len = max(U_i, U_j) + 1;
axis([0 x_len 0 4]);
% print the sumrate
sumrate_i = 0;
sumrate_j = 0;
sumrate = 0;

for i = 1 : U_i
    for j = 1 : U_j
        if Z(i,j)
            sumrate_i = sumrate_i + SINR_ij(i, j);
            sumrate_j = sumrate_j + SINR_ji(j, i);
            sumrate = sumrate + SINR_agg(i, j);
        end
    end
end

sumrate_i
sumrate_j
sumrate 

figure(3);
clf;
title('comparison', 'FontSize', 14);
hold on;

Y = [sumrate sumrate_bi;sumrate_i sumrate_i_bi;sumrate_j sumrate_j_bi];
%Y = [sumrate_i sumrate_j sumrate];
X = categorical({'aggregation','i','j'});
X = reordercats(X,{'aggregation','i','j'});
%X = [1 2 3];
b = bar(X, Y);
l = cell(1, 2);
l{1} = 'hungarian'; l{2} = 'bipartite';
legend(b, l);
hold off;
pause(5);
end
