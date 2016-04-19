function TestOnFrame(obj,frameNumber)
obj.Show();
try
    instance = obj.feed{frameNumber};
catch
    disp('Frame Index Invalid!');
    return;
end

[out ,algdir ,algspd]=alg(instance.frame);
algResult.display=out;
algResult.dir    =algdir;
algResult.spd    =algspd;

obj.UpdateFigures(instance,algResult);

end