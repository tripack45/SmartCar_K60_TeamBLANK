n=length(imglog);
rep={};
ins=struct();
for i=1:n
    ins.frame=imglog(:,:,i);
    ins.frameNumber=i;
    ins.dir  =dirlog(i);
    ins.tacho=tacholog(i);
    ins.spd  =spdlog(i);
    rep{end+1}=ins;
end
