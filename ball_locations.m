function [gameState] = ball_locations(camera, backgroundref, cfg)
% Ajbuley


%% Toggle Features
% Take new background ref img
if cfg.create_background == 1
    gameState.background = snapshot(camera);
    imwrite(gameState.background, "background.png", "png"); % CHECK FILE NAME HERE <----------
    waitforbuttonpress();
end

% Display live camera feed
if cfg.view_cam == 1
    preview(camera);
    waitforbuttonpress();
end

%% Obtain photo of current pool table
% Image path must be set to current absolute path!!
gameState.background = backgroundref; %% FIX PATH <---------
gameState.current = snapshot(camera);
subtracted_image = imsubtract(gameState.background, gameState.current);

% Display ref, current board, and spotted differences
figure(Name="Raw New Image");
imshow(gameState.current);
figure(Name="Background Image");
imshow(gameState.background);
figure(Name="Subtracted Image");
imshow(subtracted_image);

%% Process current board state
greyscale_img = im2gray(subtracted_image);
gameState.BnW = imbinarize(greyscale_img, cfg.binary_thresh); % make black and white
figure(Name="Binary Subtracted Image");
imshow(gameState.BnW);

% remove small differences from processed image
gameState.noSpecks = bwareafilt(gameState.BnW, [cfg.min_ball_size, cfg.max_ball_size]);
figure(Name="Removed Small Objects");
imshow(gameState.noSpecks);


% fill in holes in found balls
gameState.filledHoles = imfill(gameState.noSpecks, "holes");
figure(Name="Filled in Balls");
imshow(gameState.filledHoles);

% stats contains shape info (area, centroid, bounding box)
STATS = regionprops(gameState.filledHoles, {'Centroid','Area','MajorAxisLength','MinorAxisLength'});

figure(Name="Current Pool Table");
imshow(gameState.current);
hold on;

items = size(STATS);
for i = 1:items(1)
    plot(STATS(i).Centroid(1), STATS(i).Centroid(2) , 'kO', 'MarkerFaceColor', 'k');
end

% Extract arrays
C = vertcat(STATS.Centroid);  % Nx2 matrix of centroid locations x y
maj = [STATS.MajorAxisLength]'; 
minr = [STATS.MinorAxisLength]';
radii = 0.5*(maj + minr);                    % approximate radius in pixels
A = [STATS.Area]'; % number of pixels in blob

%{ 
(Optional) keep blobs that look like balls (tune thresholds for your setup)
isBall = A > 200 & A < 100000 & radii > 20 & radii < 60;  % example gates
C = C(isBall,:);
radii = radii(isBall);
A = A(isBall);
%}

% Store a simple, GUI-friendly output
gameState.balls.centroids = C;               % Nx2
gameState.balls.radii     = radii;           % Nx1
gameState.balls.area      = A;               % Nx1

%% check if needed (sticker lab)
%{
hold on
for i = 1 : length(STATS)
    W(i) = uint8(abs(STATS(i).BoundingBox(3)-STATS(i).BoundingBox(4)) > 1);
    W(i) = W(i) + 2 * uint8((STATS(i).Extent - 1) == 0 );
    diameters = mean([STATS(i).MajorAxisLength STATS(i).MinorAxisLength],2);
    radii = diameters/2;
    
    centroid = STATS(i).Centroid;
    gameState.shape(i).centroid = centroid;
    gameState.shape(i).shapeNum = i;
    if STATS(i).Area > 200 && STATS(i).Area < 100000
        radii;
        if radii > 32.2 && radii < 50
            plot(centroid(1),centroid(2),'wO');
            round(centroid(1));
            round(centroid(2));
            gameState.current(round(centroid(2)),round(centroid(1)),1);
            gameState.current(round(centroid(2)),round(centroid(1)),2);
            gameState.current(round(centroid(2)),round(centroid(1)),3);
            if (gameState.current(round(centroid(2)),round(centroid(1)),1) > gameState.current(round(centroid(2)),round(centroid(1)),2)) && (gameState.current(round(centroid(2)),round(centroid(1)),1) > gameState.current(round(centroid(2)),round(centroid(1)),3)) && gameState.current(round(centroid(2)),round(centroid(1)),2) < 150
                text(centroid(1)+20,centroid(2)+20,'RED');
                gameState.shape(i).color = 'RED';

            end
            if (gameState.current(round(centroid(2)),round(centroid(1)),2) > gameState.current(round(centroid(2)),round(centroid(1)),1)) && (gameState.current(round(centroid(2)),round(centroid(1)),2) > gameState.current(round(centroid(2)),round(centroid(1)),3)) && gameState.current(round(centroid(2)),round(centroid(1)),2) < 150
                text(centroid(1)+20,centroid(2)+20,'GREEN');
                gameState.shape(i).color = 'GREEN';

            end
            if (gameState.current(round(centroid(2)),round(centroid(1)),3) > gameState.current(round(centroid(2)),round(centroid(1)),2)) && (gameState.current(round(centroid(2)),round(centroid(1)),3) > gameState.current(round(centroid(2)),round(centroid(1)),1))
                text(centroid(1)+20,centroid(2)+20,'BLUE');
                gameState.shape(i).color = 'BLUE';

            end
            if gameState.current(round(centroid(2)),round(centroid(1)),1) > 150 && gameState.current(round(centroid(2)),round(centroid(1)),2) > 150
                text(centroid(1)+20,centroid(2)+20,'YELLOW');
                gameState.shape(i).color = 'YELLOW';
            end
            
        end
        if radii > 26 && radii < 32.2
            plot(centroid(1),centroid(2),'wS');
            round(centroid(1));
            round(centroid(2));
            gameState.current(round(centroid(2)),round(centroid(1)),1);
            gameState.current(round(centroid(2)),round(centroid(1)),2);
            gameState.current(round(centroid(2)),round(centroid(1)),3);
            if (gameState.current(round(centroid(2)),round(centroid(1)),1) > gameState.current(round(centroid(2)),round(centroid(1)),2)) && (gameState.current(round(centroid(2)),round(centroid(1)),1) > gameState.current(round(centroid(2)),round(centroid(1)),3)) && gameState.current(round(centroid(2)),round(centroid(1)),2) < 150
                text(centroid(1)+20,centroid(2)+20,'RED');
                gameState.shape(i).color = 'RED';
            end
            if (gameState.current(round(centroid(2)),round(centroid(1)),2) > gameState.current(round(centroid(2)),round(centroid(1)),1)) && (gameState.current(round(centroid(2)),round(centroid(1)),2) > gameState.current(round(centroid(2)),round(centroid(1)),3)) && gameState.current(round(centroid(2)),round(centroid(1)),2) < 150
                text(centroid(1)+20,centroid(2)+20,'GREEN');
                gameState.shape(i).color = 'GREEN';
            end
            if (gameState.current(round(centroid(2)),round(centroid(1)),3) > gameState.current(round(centroid(2)),round(centroid(1)),2)) && (gameState.current(round(centroid(2)),round(centroid(1)),3) > gameState.current(round(centroid(2)),round(centroid(1)),1))
                text(centroid(1)+20,centroid(2)+20,'BLUE');
                gameState.shape(i).color = 'BLUE';
            end
            if gameState.current(round(centroid(2)),round(centroid(1)),1) > 150 && gameState.current(round(centroid(2)),round(centroid(1)),2) > 150
                text(centroid(1)+20,centroid(2)+20,'YELLOW');
                gameState.shape(i).color = 'YELLOW';
            end
        end
        if radii < 26
            plot(centroid(1),centroid(2),'wX');
            round(centroid(1));
            round(centroid(2));
            gameState.current(int16(round(centroid(2))),int16(round(centroid(1))),1);
            gameState.current(round(centroid(2)),round(centroid(1)),2);
            gameState.current(round(centroid(2)),round(centroid(1)),3);
            if (gameState.current(round(centroid(2)),round(centroid(1)),1) > gameState.current(round(centroid(2)),round(centroid(1)),2)) && (gameState.current(round(centroid(2)),round(centroid(1)),1) > gameState.current(round(centroid(2)),round(centroid(1)),3)) && gameState.current(round(centroid(2)),round(centroid(1)),2) < 150
                text(centroid(1)+20,centroid(2)+20,'RED');
                gameState.shape(i).color = 'RED';
            end
            if (gameState.current(round(centroid(2)),round(centroid(1)),2) > gameState.current(round(centroid(2)),round(centroid(1)),1)) && (gameState.current(round(centroid(2)),round(centroid(1)),2) > gameState.current(round(centroid(2)),round(centroid(1)),3)) && gameState.current(round(centroid(2)),round(centroid(1)),2) < 150
                text(centroid(1)+20,centroid(2)+20,'GREEN');
                gameState.shape(i).color = 'GREEN';
            end
            if (gameState.current(round(centroid(2)),round(centroid(1)),3) > gameState.current(round(centroid(2)),round(centroid(1)),2)) && (gameState.current(round(centroid(2)),round(centroid(1)),3) > gameState.current(round(centroid(2)),round(centroid(1)),1))
                text(centroid(1)+20,centroid(2)+20,'BLUE');
                gameState.shape(i).color = 'BLUE';
            end
            if gameState.current(round(centroid(2)),round(centroid(1)),1) > 150 && gameState.current(round(centroid(2)),round(centroid(1)),2) > 150
                text(centroid(1)+20,centroid(2)+20,'YELLOW');
                gameState.shape(i).color = 'YELLOW';
            end
        end
    end
end
gameState.shape(end).shapeNum %count how many shapes were detected
disp(gameState.shape.centroid)
disp(gameState.shape.color)
%}

