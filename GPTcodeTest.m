clc; 
close all; 
clear;

%% Parameters

p = .2; % initial population density
sy = 6;
sx = 45; % map size
closure = [20,40;1,3]; % size of road closure
t_max = 60; % number of ticks
prob = .2; % the density of new cars spawned

speed = .5;
count_o = zeros(1,t_max); % counter for cars that hit the right wall
count_i = zeros(1,t_max);
count_t = zeros(1,t_max);
carsCount_o = 0;
  %Red (maximum value)


%% Main Loop

img = randmat(sx, sy, p);

img(1:end, closure(1,1):end) = 1;
carsCount_i = width(img) * height(img) - sum(sum(img));


for tick = 1:t_max
    figure(1)
    dispImg = img;
    %dispImg(closure(2,1):closure(2,2),closure(1,1):closure(1,2)) = 0;
    dispImg = resize(dispImg,floor(200/sy)); % scales figure to constant size
    dispImg = imresize(dispImg, 5); % rounds corners of boxes
    imshow(dispImg)
    drawnow
    
    carsCount_t = 0;
    
    [img, carsCount_o, carsCount_i, carsCount_t] = rules(img, prob, carsCount_o, carsCount_i, carsCount_t, closure, speed);
    count_o(1,tick) = carsCount_o;
    count_i(1,tick) = carsCount_i;
    count_t(1,tick) = carsCount_t;
    
    
    
end

x = 1:t_max;
plot(x, count_o)
hold on
plot(x, count_i)
plot(x, count_t)

legend('cars out','cars in','cars total', 'Location','northwest')
%disp(['Number of cars that hit the right wall: ', num2str(carsCount_o)]);

%% Functions

function img = randmat(sx, sy, p)
    img = rand(sy, sx) > p;
end

function [newImg, carsCount_o, carsCount_i, carsCount_t] = rules(img, prob, carsCount_o, carsCount_i, carsCount_t, closure, speed)
    [sy, sx] = size(img);
    newImg = img;
    
    
    for i = 1:sx
        for j = 1:sy
            if img(j,i) == 0 && img(j,i+1) == 1 && laneClosed(j,i,sx,sy, closure) == 0 % move to the right
                if i > closure(1,1) && i < closure(1,2)  % in construction zone
                    if rand(1) < speed && img(j,i+1) == 1
                        newImg(j,i+1) = 0;
                        newImg(j,i) = 1;
                    end
                else
                    newImg(j,i+1) = 0; % out of construcion zone
                    newImg(j,i) = 1;
                end
            elseif i == 1 && rand < prob % adding cars
                newImg(j,i) = 0;
                carsCount_i = carsCount_i + 1;
                
            elseif j > 1 && img(j,i) == 0 && img(j,i+1) == 0
                if img(j-1,i+1) == 1 && img(j-1,i) == 1 && j > closure(2,2) + 1 % switching lanes
                    newImg(j-1,i+1) = 0;
                    newImg(j,i) = 1;
                elseif j < sy && img(j+1,i+1) == 1 && img(j+1,i) == 1
                    newImg(j+1,i+1) = 0;
                    newImg(j,i) = 1;
                end
            end
            
            if newImg(j,i) == 0
                carsCount_t = carsCount_t + 1;
            end
            
            if img(j,i) == 0 && laneClosed(j,i,sx,sy, closure) == 1 % stops car if construction is in front
                newImg(j,i) = 0;
            end
            if i == sx - 1 && img(j,i) == 0 % car left construction
                carsCount_o = carsCount_o + 1;
                newImg(j,i) = 1;
            end
        end
        if img(1,i) == 0 && img(1,i+1) == 0 && img(2,i+1) == 1 % switching lanes for top row
            newImg(2,i+1) = 0;
            newImg(1,i) = 1;
        end
        
    end
   
    newImg(:,sx) = 1; % remove all cars that hit the right wall
    
end


function state = laneClosed(j, i, sx, sy, closure)
    state = 0;
    if( i+1 >= closure(1,1) && i+1 <= closure(1,2) && j >= closure(2,1) && j <= closure(2,2))
        state = 1;
    end
end


function bigerImg = resize(img, scale)
    [sy, sx] = size(img);
    bigerImg = repelem(img, scale, scale);
    bigerImg = bigerImg(1:sy*scale, 1:sx*scale);
end
