%% Car-tastrophe
clc; close all; clear;


t_max = 100;
trials = 50;

count_o = zeros(trials, t_max);
count_i = zeros(trials, t_max);
%count_t = zeros(trials, t_max);


for i = 1:trials
    [count_oi, count_ii, count_ti] = TACS(.2, 4, 45, [20,40;1,1], t_max, .5, .5, 0);
    count_o(i,1:end) = count_oi;
    %count_i(i,1:end) = count_ii;
    %count_t(i,1:end) = count_ti;
end


points_o = mean(count_o);
%points_i = mean(count_i);
%points_t = mean(count_t);

bars_o = std(count_o);
%bars_i = std(count_i);
%bars_t = std(count_t);

x = 1:t_max;
errorbar(points_o, bars_o)
hold on
%errorbar(points_i, bars_i)
%errorbar(points_t, bars_t)

legend('cars out','cars in','cars total', 'Location','northwest')




