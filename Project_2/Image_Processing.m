clear; clc; close all; clear('camera');

minSize = 50;
binary_threshold = 0.030;
create_background = 0;
%% Initialize the webcam and take and store a background photo
%{
vid = videoinput('winvideo', 1, 'MJPG_640x480');
set(vid, 'TriggerRepeat', Inf);
vid.FrameGrabInterval = 1;
start(vid);
data = getdata(vid, 1);
img = data(:,:,:,1);
%}
camera = webcam('Brio 100');
if create_background == 1
    pic = snapshot(camera);
    imwrite(pic, "background.png", "png");
    waitforbuttonpress();
end
%%
background = imread("C:\Users\WilD8\OneDrive\Documents\MATLAB\Senior Year\background.png");
pic = snapshot(camera);
J = imsubtract(background, pic);

figure(Name="Raw New Image");
imshow(pic);
figure(Name="Background Image");
imshow(background);
figure(Name="Subtracted Image");
imshow(J);

subtracted_Image = J;
clear J;

%% At this point in the code, the background has been subtracted.
imshow(subtracted_Image);
I = im2gray(subtracted_Image);
BnW = imbinarize(I, binary_threshold);
figure(Name="Binary Subtracted Image");
imshow(BnW);
clear I;

% Perform morphological operations to remove small objects
BnW = bwareaopen(BnW, minSize);
figure(Name="Removed Small Objects");
imshow(BnW);
%Fill in the holes if there are any (if a ball is shiny)

BnW = imfill(BnW, "holes");
figure(Name="Filled in Shine");
imshow(BnW);

%% regionprops
STATS = regionprops(BnW, 'all');

figure(Name="Original Including Centroids");
imshow(pic);
hold on;

items = size(STATS);
for i = 1:items(1)
    plot(STATS(i).Centroid(1),STATS(i).Centroid(2),'kO','MarkerFaceColor','k');
end


%%
hold on
for i = 1 : length(STATS)
    W(i) = uint8(abs(STATS(i).BoundingBox(3)-STATS(i).BoundingBox(4)) > 1);
    W(i) = W(i) + 2 * uint8((STATS(i).Extent - 1) == 0 );
    diameters = mean([STATS(i).MajorAxisLength STATS(i).MinorAxisLength],2);
    radii = diameters/2;
    
    centroid = STATS(i).Centroid;
    if STATS(i).Area > 200 && STATS(i).Area < 100000
        radii;
        if radii > 29 && radii < 50
            plot(centroid(1),centroid(2),'wO');
            round(centroid(1));
            round(centroid(2));
            pic(round(centroid(2)),round(centroid(1)),1);
            pic(round(centroid(2)),round(centroid(1)),2);
            pic(round(centroid(2)),round(centroid(1)),3);
            if (pic(round(centroid(2)),round(centroid(1)),1) > pic(round(centroid(2)),round(centroid(1)),2)) && (pic(round(centroid(2)),round(centroid(1)),1) > pic(round(centroid(2)),round(centroid(1)),3)) && pic(round(centroid(2)),round(centroid(1)),2) < 150
                text(centroid(1)+20,centroid(2)+20,'RED');
            end
            if (pic(round(centroid(2)),round(centroid(1)),2) > pic(round(centroid(2)),round(centroid(1)),1)) && (pic(round(centroid(2)),round(centroid(1)),2) > pic(round(centroid(2)),round(centroid(1)),3)) && pic(round(centroid(2)),round(centroid(1)),2) < 150
                text(centroid(1)+20,centroid(2)+20,'GREEN');
            end
            if (pic(round(centroid(2)),round(centroid(1)),3) > pic(round(centroid(2)),round(centroid(1)),2)) && (pic(round(centroid(2)),round(centroid(1)),3) > pic(round(centroid(2)),round(centroid(1)),1))
                text(centroid(1)+20,centroid(2)+20,'BLUE');
            end
            if pic(round(centroid(2)),round(centroid(1)),1) > 150 && pic(round(centroid(2)),round(centroid(1)),2) > 150
                text(centroid(1)+20,centroid(2)+20,'YELLOW');
            end
            
        end
        if radii > 24 && radii < 29
            plot(centroid(1),centroid(2),'wS');
            round(centroid(1));
            round(centroid(2));
            pic(round(centroid(2)),round(centroid(1)),1);
            pic(round(centroid(2)),round(centroid(1)),2);
            pic(round(centroid(2)),round(centroid(1)),3);
            if (pic(round(centroid(2)),round(centroid(1)),1) > pic(round(centroid(2)),round(centroid(1)),2)) && (pic(round(centroid(2)),round(centroid(1)),1) > pic(round(centroid(2)),round(centroid(1)),3)) && pic(round(centroid(2)),round(centroid(1)),2) < 150
                text(centroid(1)+20,centroid(2)+20,'RED');
            end
            if (pic(round(centroid(2)),round(centroid(1)),2) > pic(round(centroid(2)),round(centroid(1)),1)) && (pic(round(centroid(2)),round(centroid(1)),2) > pic(round(centroid(2)),round(centroid(1)),3)) && pic(round(centroid(2)),round(centroid(1)),2) < 150
                text(centroid(1)+20,centroid(2)+20,'GREEN');
            end
            if (pic(round(centroid(2)),round(centroid(1)),3) > pic(round(centroid(2)),round(centroid(1)),2)) && (pic(round(centroid(2)),round(centroid(1)),3) > pic(round(centroid(2)),round(centroid(1)),1))
                text(centroid(1)+20,centroid(2)+20,'BLUE');
            end
            if pic(round(centroid(2)),round(centroid(1)),1) > 150 && pic(round(centroid(2)),round(centroid(1)),2) > 150
                text(centroid(1)+20,centroid(2)+20,'YELLOW');
            end
        end
        if radii < 24
            radii
            plot(centroid(1),centroid(2),'wX');
            round(centroid(1));
            round(centroid(2));
            pic(int16(round(centroid(2))),int16(round(centroid(1))),1);
            pic(round(centroid(2)),round(centroid(1)),2);
            pic(round(centroid(2)),round(centroid(1)),3);
            if (pic(round(centroid(2)),round(centroid(1)),1) > pic(round(centroid(2)),round(centroid(1)),2)) && (pic(round(centroid(2)),round(centroid(1)),1) > pic(round(centroid(2)),round(centroid(1)),3)) && pic(round(centroid(2)),round(centroid(1)),2) < 150
                text(centroid(1)+20,centroid(2)+20,'RED');
            end
            if (pic(round(centroid(2)),round(centroid(1)),2) > pic(round(centroid(2)),round(centroid(1)),1)) && (pic(round(centroid(2)),round(centroid(1)),2) > pic(round(centroid(2)),round(centroid(1)),3)) && pic(round(centroid(2)),round(centroid(1)),2) < 150
                text(centroid(1)+20,centroid(2)+20,'GREEN');
            end
            if (pic(round(centroid(2)),round(centroid(1)),3) > pic(round(centroid(2)),round(centroid(1)),2)) && (pic(round(centroid(2)),round(centroid(1)),3) > pic(round(centroid(2)),round(centroid(1)),1))
                text(centroid(1)+20,centroid(2)+20,'BLUE');
            end
            if pic(round(centroid(2)),round(centroid(1)),1) > 150 && pic(round(centroid(2)),round(centroid(1)),2) > 150
                text(centroid(1)+20,centroid(2)+20,'YELLOW');
            end
        end
       
    end
end
