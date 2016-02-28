%%
%setup¡¢
if(exist('com'))
    fclose(com);
end
clc;
imgrow=67;
imgcol=77;
%COM4, BuadRate 115200, DataBits 8
%fclose(com);
com = serial('COM11','BaudRate',460800*100,'DataBits',8);
set(com,'InputBufferSize',imgrow*100*4);
fopen(com); %opens the Serial Port
fwrite(com,'abc');

currimg=ones(imgrow,imgcol);
colormap(gray);
im=image(currimg);
axis equal;

%
% hgraph=imshow(currimg);
% colormap(gray);
% drawnow;
%
%
% global sbuffer;
% sbuffer=[];

%%
b_buffer=[];
while 1
    head_found=false;
    while ~head_found
        if com.BytesAvailable>0
            b_buffer=[b_buffer; fread(com,com.BytesAvailable)];
        end
        head_pos=strfind(b_buffer', [255,0,255]);
        if ~isempty(head_pos)
            if length(head_pos)>1
                %disp('more then one recieved!');
            end
            %tic;
            %disp('head found');
            head_pos=head_pos(1);
            head_found=true;
            b_buffer(1:head_pos+2)=[];
        end
    end
    tail_found=false;
    while ~tail_found
        if com.BytesAvailable>0
            b_buffer=[b_buffer; fread(com,com.BytesAvailable)];
        end
        tail_pos=strfind(b_buffer', [160,0,160]);
        if ~isempty(tail_pos)
            %disp('tail found');
            tail_pos=tail_pos(1);
            tail_found=true;
            indata=b_buffer(1:tail_pos-1);
            b_buffer(1:tail_pos+2)=[];
        end
    end
    %disp('drawing');
    if length(indata)==imgcol*imgrow
        img=reshape(indata,[imgcol,imgrow]);
        img=img.';
        im.CData=img;
        drawnow nocallbacks ;
        %toc;
    else
        disp('Invalid frame size!');
    end
end

%%
fclose(com);
