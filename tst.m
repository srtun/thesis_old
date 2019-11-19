clearvars
c = [2,15,15,4; 10,-4,14,15; 9,14,16,13; 7,8,11,9];
%c = [12 7; 1 1];
%c = reshape(c, 4, 4)';
%row = [1,0,0,1,0];

[number, text, rawdata] = xlsread('CQI_index.xlsx');
number
text
rawdata

U_i = 5;
U_j = 6;
SINR_ij = randi(30, U_i, U_j);
SINR_ji = randi(30, U_j, U_i);
SINR_agg = SINR_ij + SINR_ji'


[p_x, p_y, pair] = user_pairing_heuristic(c);
%a = max(c(2,:))
%find(c(2,:) == a)
%[Z, cost] = user_pairing_hungarian(c);
%Z
%cost