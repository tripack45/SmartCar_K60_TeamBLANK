function UpdateFigures(obj,instance,algResult)
%Draw ExtraInfo
set(obj.UIText.tDir,'String',num2str(instance.dir));
set(obj.UIText.tSpd,'String',num2str(instance.spd));
set(obj.UIText.tTch,'String',num2str(instance.tacho));

%Draw the Algorithm results
set(obj.imageFeed,'CData',instance.frame);
set(obj.UIText.tADir,'String',num2str(algResult.dir));
set(obj.UIText.tASpd,'String',num2str(algResult.spd));

%Draw the image
set(obj.imageDisplay,'CData',algResult.display);


%Frame number
set(obj.UIText.tFrame,'String',num2str(instance.frameNumber));

%Update Figures
try
    drawnow nocallbacks;
catch
    drawnow;
end
end