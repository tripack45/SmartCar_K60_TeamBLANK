function ReplayWithAlg(obj,start,fps)
%% inputs
if(~exist('fps','var'))
    fps=50;
end
if(exist('start','var'))
    obj.replayCount=start;
end

figure(obj.figureHandle);

%% Applying Algorithms and Drawing them
tic;
last_draw_toc=0;
last_frame_toc=0;

while (obj.replayCount <= length(obj.feed))
    %Get the state at an instance 
    instance=obj.feed{obj.replayCount};
    
    %Apply Algorithms.
    algResult=struct();
    [out, algdir, algspd]=alg(instance.frame);
    
    algResult.display=out;
    algResult.dir    =algdir;
    algResult.spd    =algspd;
        
    if (toc-last_draw_toc)>(1/20) 
        obj.UpdateFigures(instance,algResult);
        last_draw_toc=toc;
    end
    while (toc-last_frame_toc)<(1/fps)
    end
    last_frame_toc=toc;
    
    obj.replayCount = obj.replayCount + 1;
end
end