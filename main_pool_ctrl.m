%% Main Control File for 4950 Pool Project

%{
 Supporting Files:
 - pool_gui.m  (user selection of ball and pocket)
 - ball_locations     (ball location recognition)
%}

clear; clc; close all; clear('camera');


%% TODO:
% Improve ball recognition when near edges or other balls (one blob)


camera = webcam('Brio 100');
reference_background = 0; 

cfg.min_ball_size = 80; % add units here
cfg.max_ball_size = 5000; % add units here
cfg.binary_thresh = 0.045; % sensitivty to color
% was 0.030

cfg.create_background = 0; % toggle for save new background
cfg.view_cam = 0; % toggle to see live feed of cam

backgroundimg = imread("C:\Users\drewb\MATLAB\Projects\4950_proj_3\background.png");

%% Obtain ball locations
[gameState] = ball_locations(camera, backgroundimg, cfg);
% gamestate.balls.centroids
% gameState.balls.radii
% gameState.balls.area

% Safety: empty detection
C = [];
if isfield(gameState,'balls') && isfield(gameState.balls,'centroids')
    C = gameState.balls.centroids;
end

if isempty(C)
    warning('No balls detected. Opening GUI anyway.');
end

res = pool_gui(gameState, C);
if ~res.cancelled && ~isnan(res.testing_y)
    % convert between camera axes and motor axis
    converted_angle = (2200/280) * (res.testing_y - 55);
    fprintf('set motor angle to: %.2f\n', converted_angle);
else
    fprintf('Cue Y not set (cancelled or no click).\n');
end



