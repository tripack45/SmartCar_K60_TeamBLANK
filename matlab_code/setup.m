clc;
imgrows=50;
imgcols=150;
%COM4, BuadRate 115200, DataBits 8
%fclose(com);
com = serial('COM5','BaudRate',115200,'DataBits',8);
set(com,'InputBufferSize',50*100*5);
fopen(com); %opens the Serial Port

currimg=ones(imgrows,imgcols);
hgraph=imshow(currimg);
colormap(gray);
drawnow;


global sbuffer;
sbuffer=[];

%% Loop:
while(1)
    t=get(com,'BytesAvailable');
    input=fread(com,t);
    
end