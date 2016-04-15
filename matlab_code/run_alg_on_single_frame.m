%% inputs
imgrow=67;
imgcol=77;
algrow=150;
algcol=150;
%source=frame;
i=2079;
%1069,1075,1111,1081,1089
%1213,1280,1293,1311,1324
%1425,1429,1691,1790,2046
%2121,2079,2136,2232,2244

%% Set up the figures
InitializeFigures;

%% Applying Algorithms and Drawing them
tic;
last_draw_toc=0;
last_frame_toc=0;

%Load A Frame
%img=source(:,:,i);
img=sample;
%Apply Algorithms.
[out algdir algspd]=alg(img);

%Recall Logging Data
dir=dirlog(i);
spd=spdlog(i);
tacho=tacholog(i);

%Frame Number
frameNum=i;
UpdateFigures;

last_frame_toc=toc;
%drawnow nocallbacks;
