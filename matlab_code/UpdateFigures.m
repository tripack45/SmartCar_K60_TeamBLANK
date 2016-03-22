%Draw ExtraInfo
set(tDir,'String',num2str(dir));
set(tSpd,'String',num2str(spd));
set(tTch,'String',num2str(tacho));

%Draw the Algorithm results
set(imalg,'CData',out);
set(tADir,'String',num2str(algdir));
set(tASpd,'String',num2str(algspd));



%Draw the image
set(imsource,'CData',img);


%Frame number
set(tFrame,'String',num2str(frameNum));

%Update Figures
try
    drawnow nocallbacks;
catch
    drawnow;
end
