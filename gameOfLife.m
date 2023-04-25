clc; close all; clear;


%% Perameters

p = .2; % initial population density
sy = 5;
sx = 80; % map size
t_max = 40; % number of ticks
prob = .1; % the density of new cars spawned

%% Seed Image


%% Main Loop

img = randmat(sx, sy, p);

for tick = 1:t_max
    figure(1)
   
    dispImg = resize(img,200/sy); % scales figure to constant size
    dispImg = imresize(dispImg, 5); % rounds corners of boxes
    imshow(dispImg)
    
    %render(img, s)
    pause(.05)
    drawnow
    
    img = rules(img, prob);
    
    
end





%% Functions


function img = randmat(sx, sy, p)
img = rand(sy,sx);



img = img/max(img, [], 'all');

for i = 1:length(img)
    for j = 1:height(img)
        if (img(j,i) < p)
            img(j,i) = 0;
        else
            img(j,i) = 1;
        end
    end
end



end

function newImg = rules(img, prob)
    newImg = img;
    for i = 1:length(img) - 1
        for j = 1:height(img)
            
            %map = img(j-1:j+1, i-1:i+1);
            %population_density = sum(map, 'all');
            
            %if (population_density > 5)
            %    newImg(j,i) = 0;
            %end
                
            if (img(j,i) == 0 && img(j,i+1) == 1) % move to the left
                newImg(j,i+1) = 0;
                newImg(j,i) = 1;
            end
            
            %if (img(j,i) == 0 && i + 1 == length(img)) % screen wrapping
            %    newImg(j,1) = 0;
            %    newImg(j,i+1) = 1;
            %end
            
            if (i == 1 && rand < prob) % adding cars
                newImg(j,i) = 0;
            end
            
            if (j > 2)
                if (img(j,i) == 0 && img(j,i+1) == 0 && img(j-1,i+1)) % swiching lanes
                    newImg(j-1,i+1) = 0;
                    newImg(j,i) = 1;
                elseif (img(j,i) == 0 && j ~= height(img) && img(j,i+1) == 0 && img(j+1,i+1))
                        newImg(j+1,i+1) = 0;
                        newImg(j,i) = 1;
                end
            end
            
            %if (img(j,i) == 1 && population_density < 4)
            %    newImg(j+randi([-1 1]),i+randi([-1 1])) = 1;
            %    newImg(j+randi([-1 1]),i+randi([-1 1])) = 1;
            %end
                
            % no squares to bottom
            %if (img(j,i) == 1 && img(j+1,i) ~= 1)
            %    newImg(j,i) = 1;
            %else
            %    newImg(j,i) = 0;
            %end
            
            
            
            
        end
    end


end


function inspect_frame(img, s) % renderer Need to add frame counter
    %    1. Create a scroll panel.
    hFig = figure('Toolbar','none',...
          'Menubar','none');
    img = imresize(img, 10/s); % figure size
    hIm = imshow(img);
    hSP = imscrollpanel(hFig,hIm);
    set(hSP,'Units','normalized','Position',[0 .1 1 .9])

    % 2. Add a Magnification Box and an Overview tool.
    hMagBox = immagbox(hFig,hIm);
    pos = get(hMagBox,'Position');
    set(hMagBox,'Position',[0 0 pos(3) pos(4)])
    imoverview(hIm)

    % 3. Get the scroll panel API to programmatically control the view.
    api = iptgetapi(hSP);

    % 4. Get the current magnification and position.
    mag = api.getMagnification();
    r = api.getVisibleImageRect();

    % 5. View the top left corner of the image.
    api.setVisibleLocation(0.5,0.5)

    % 6. Change the magnification to the value that just fits.
    api.setMagnification(api.findFitMag())
end

function bigerImg = resize(img, scale)
    scale = floor(scale);
    bigerImg = zeros(height(img)*scale); % blank larger matrix
    
    for i = 1:length(img) % iterates though columns
        for j = 1:height(img) % iterates though rows
            for k = 0:scale-1 % makes smaler box to fill in repeat values
                for l = 0:scale-1
                    bigerImg((j*scale-1)+k, (i*scale-1)+l) = img(j,i); % sets each valuse of bigerImg to corisponding img value
                end
            end
        end
    end
end





