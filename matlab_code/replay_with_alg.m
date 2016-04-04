%% inputs
imgrow=67;
imgcol=77;
algrow=150;
algcol=150;
source=frame;
fps=50;
start=1800;

%% Set up the figures
InitializeFigures;

%% Applying Algorithms and Drawing them
tic;
last_draw_toc=0;
last_frame_toc=0;
for i=start:size(source,3)
    
    %Load A Frame
    img=source(:,:,i);
    
    %Preprocess A Frame
    for ii=2:imgrow
        if any(img(ii,end-20:end)'<10)
            img(ii,:)=img(ii-1,:);
        end
    end
    
    %Apply Algorithms.

        [out algdir algspd]=alg(img);

    %Recall Logging Data
    dir=dirlog(i);
    spd=spdlog(i);
    tacho=tacholog(i);
    
    %Frame Number
    frameNum=i;
    
    if (toc-last_draw_toc)>(1/20) 
        UpdateFigures;
        last_draw_toc=toc;
    end
    while (toc-last_frame_toc)<(1/fps)
    end
    last_frame_toc=toc;
    %drawnow nocallbacks;
end