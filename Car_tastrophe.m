%% Car-tastrophe
clc; close all; clear;


t_max = 200;
trials = 250;
interval = t_max / 10;

ind = 0:0.005:1;

count_o1 = zeros(trials, length(ind));



for j = 1:length(ind)
    for i = 1:trials
        [count_oi1, ~, count_ti1] = TACS(0, 15, 45, [20,40;1,4], t_max, ind(j), .9, 0);
        count_ss = count_oi1(end) - count_oi1(end - interval);
        count_ss = count_ss / interval;
        count_ss = count_ss / count_ti1(end);
        count_o1(i,j) = count_ss;
    end
    done = floor(100*(j / length(ind)));
    show = ['The simularion is ', num2str(done), '% done'];
    disp(show)
end

points_o1 = mean(count_o1);



bars_o1 = std(count_o1);

%plot(ind, points_o1)



%
errorbar(ind, points_o1, bars_o1)


%}

xlabel('Car Density','FontSize',18);
ylabel('Traffic flow [cars / time step]','FontSize',18);
title('','FontSize',16)

%legend('lol', 'Location','northwest')

