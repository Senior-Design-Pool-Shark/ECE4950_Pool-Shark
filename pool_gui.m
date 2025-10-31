function result = pool_gui(gameState, centroids)
% Ajbuley

%% Sanity checks
% make sure we have an image and at least 1 centroid
assert(isfield(gameState, 'current') && ~isempty(gameState.current), ...
    'gameState.current (RGB image) is required.');
if isempty(centroids)
    C = zeros(0,2);
else
    assert(size(centroids,2)==2, 'centroids must be an N-by-2 array [x y].');
    C = centroids;          % Nx2 [x y]
end
nBalls = size(C,1);

%% Create GUI base
% S is struct that holds all GUI state info
% CHANGED HERE <---------------------
S.fig = figure('Name','Pool Assistant (Minimal)','NumberTitle','off', ...
                   'MenuBar','none','ToolBar','none','Color','w', ...
                   'Units','normalized','Position',[0.15 0.1 0.7 0.8], ...
                   'CloseRequestFcn', @onCancel);
% TO HERE <-------
S.ax  = axes('Parent',S.fig,'Units','normalized','Position',[0.27 0.08 0.70 0.88]);
imshow(gameState.current,'Parent',S.ax); 
hold(S.ax,'on');

% Store centroid locations
S.C = C;

%% Plot balls and labels
% plot white circle element on top of each centroid
if nBalls > 0
    S.ballPlot = plot(S.ax, C(:,1), C(:,2), 'wo', 'MarkerFaceColor','w','MarkerSize',6, 'LineWidth',1.5);
    S.ballText = gobjects(nBalls,1);
    for i = 1:nBalls
        S.ballText(i) = text(S.ax, C(i,1)+10, C(i,2)+10, sprintf('%d',i), ...
            'Color','y','FontWeight','bold','FontSize',10, 'Clipping','on');
    end
    ballLabels = arrayfun(@(i) sprintf('%02d | (%d,%d)', ...
                       i, round(C(i,1)), round(C(i,2))), (1:nBalls)', 'UniformOutput', false);
    lbString = ballLabels; lbValue = 1; lbEnable = 'on';
else
    S.ballPlot = gobjects(1); S.ballText = gobjects(1);
    lbString = {'(no balls detected)'};
    lbValue  = 1;
    lbEnable = 'off';
end

% Left pane UI controls

uicontrol(S.fig,'Style','text','String','Detected Balls', ...
    'Units','normalized','Position',[0.02 0.92 0.23 0.04], ...
    'BackgroundColor','w','HorizontalAlignment','left','FontWeight','bold');

S.lbBalls = uicontrol(S.fig,'Style','listbox','Max',1,'Min',1, ...
    'String',lbString,'Value',lbValue,'Enable',lbEnable, ...
    'Units','normalized','Position',[0.02 0.56 0.23 0.35], ...
    'FontName','Consolas');

% Cue ball setup      FIX ME <---------------------------
uicontrol(S.fig,'Style','text','String','Cue Ball', ...
    'Units','normalized','Position',[0.02 0.50 0.23 0.04], ...
    'BackgroundColor','w','HorizontalAlignment','left','FontWeight','bold');

S.btnSetCue = uicontrol(S.fig,'Style','pushbutton','String','Set Cue (click on image)', ...
    'Units','normalized','Position',[0.02 0.46 0.23 0.04], 'Callback',@onSetCue);

S.txtCuePos = uicontrol(S.fig,'Style','text','String','Cue: (not set)', ...
    'Units','normalized','Position',[0.02 0.42 0.23 0.03], ...
    'BackgroundColor','w','HorizontalAlignment','left');

% NEW _-------------------
S.btnFinish = uicontrol(S.fig,'Style','pushbutton','String','Finish', ...
        'Units','normalized','Position',[0.02 0.05 0.11 0.05], ...
        'FontWeight','bold','Callback',@onFinish);     % <<< NEW

S.btnCancel = uicontrol(S.fig,'Style','pushbutton','String','Cancel', ...
    'Units','normalized','Position',[0.14 0.05 0.11 0.05], ...
    'Callback',@onCancel);                         % <<< NEW

% end here -----------------------

% State vars
S.cuePos     = [];    % [x y]
S.pocketPos  = [];    % [x y]
S.pocket6    = [];    % 6x2 if calibrated
S.pocketLbls = {'TL','TM','TP','BL','BM','BR'};
S.line1      = gobjects(1); % cue -> target
S.line2      = gobjects(1); % target -> pocket
S.pocketPlots= gobjects(6,1);

% ------------------- NEW
S.cancelled = true;   % <<< NEW: default value until Finish is clicked
% ---------------

guidata(S.fig,S);

% NEW-------------------------------
guidata(S.fig, S);
uiwait(S.fig);

result = struct('cuePos',[],'targetIdx',[],'testing_y',NaN,'cancelled',true);

    if isvalid(S.fig)
        S = guidata(S.fig);

        % Copy values into output struct
        result.cuePos = S.cuePos;

        if nBalls > 0 && strcmpi(get(S.lbBalls,'Enable'),'on')
            result.targetIdx = get(S.lbBalls,'Value');
        end

        % *** NEW: testing_y return ***
        % -----------------------------------------
        if ~isempty(S.cuePos)
            result.testing_y = S.cuePos(2);   % <<< NEW KEY OUTPUT
        end
        % -----------------------------------------

        result.cancelled = S.cancelled;

        delete(S.fig);
    end
% ---------------------

% ---------- Callbacks ----------
%% Place Cyan marker on clicked point
function onSetCue(~,~)
    S = guidata(gcbf);
    % Make sure our axes is current before ginput
    set(S.fig, 'CurrentAxes', S.ax);    % or: axes(S.ax);

    title(S.ax,'Click the CUE BALL location ...','Color',[1 1 0]);
    [x,y,btn] = ginput(1);

    title(S.ax,'','Color','w');

    % Validate the click
    if isempty(x) || isempty(y) || isempty(btn) || ~isfinite(x) || ~isfinite(y)
        warndlg('No valid click captured. Try again on the image area.');
        return;
    end

    % Save and draw
    S.cuePos = [x y];
    if isgraphics(S.line1), delete(S.line1); end
    if isgraphics(S.line2), delete(S.line2); end
    guidata(gcbf,S);          % store BEFORE helper reads it
    plotCueMarker();          % draws cyan marker + label

    % Update UI text
    S = guidata(gcbf);        % re-fetch (helper might have updated S)
    S.txtCuePos.String = sprintf('Cue: (%.1f, %.1f)', x, y);
    guidata(gcbf,S);
end
%% NEW CALLBACK
function onFinish(~,~)
        S = guidata(gcbf);

        % *** NEW: signal that user completed GUI ***
        S.cancelled = false;        % <<< NEW

        guidata(gcbf,S);
        uiresume(S.fig);            % <<< NEW (unblocks uiwait)
end
% ------------------------
%% NEW CALLBACK
function onCancel(h,~)
        if ishghandle(h) && strcmp(get(h,'Type'),'uicontrol')
            f = ancestor(h,'figure');
        else
            f = h;
        end
        try
            S = guidata(f);
            S.cancelled = true;     % <<< NEW
            guidata(f,S);
        catch
        end

        if strcmp(get(f,'WaitStatus'),'waiting')
            uiresume(f);            % <<< NEW
        else
            delete(f);
        end
end
% ------------------------


% ---------- Helpers ----------
%% Make Cyan ball
function plotCueMarker()
    S = guidata(gcbf);
    if ~isfield(S,'cuePos') || numel(S.cuePos) < 2 || any(~isfinite(S.cuePos))
        return;  % nothing to plot yet
    end
    plot(S.ax, S.cuePos(1), S.cuePos(2), 'co', 'MarkerSize',10, 'LineWidth',2);
    % Know cue ball X axis location
    text(S.ax, S.cuePos(1)+8, S.cuePos(2)-8, 'CUE', 'Color','c', ...
         'FontWeight','bold','Clipping','on');
end

end
