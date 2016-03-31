%%
disp('YOU SHOULD RUN THIS WITH SCS!!');
disp('YOU SHOULD RUN THIS WITH SCS!!');
disp('YOU SHOULD RUN THIS WITH SCS!!');
        
clc;
disp('Closing com');
try
    fclose(com);
catch
end
imgrow=67;
imgcol=77;
extraInfoSize=2;
algrow=150;
algcol=150;
frameNum=0;
%COM4, BuadRate 115200, DataBits 8
%fclose(com);

com = tcpip('127.0.0.1', 51437, 'NetworkRole', 'server');
set(com,'InputBufferSize',imgrow*100*400);
disp('Waiting SCS Client Connection!');
fopen(com); %opens the Serial Port

disp('Preparing to buffer')

%% Graphic Initializations
InitializeFigures;
%%

disp('Recieving');
b_buffer=[];
dataout=uint8([0,0,0,0]);
while 1
    if length(b_buffer)>3*imgcol*imgrow
        b_buffer=[];
    end
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
        elseif(length(b_buffer)>imgrow*imgcol*3)
            b_buffer=[];
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
        elseif(length(b_buffer)>imgrow*imgcol*3)
            b_buffer=[];
        end
    end
    %disp('drawing');
    
    if length(indata)==imgcol*imgrow+extraInfoSize
        
        %Collecting Extra Data
        E=imgcol*imgrow;
        %spdu8=indata(E+1:E+2);
        %diru8=indata(E+3:E+4);
        tachou8=indata(E+1:E+2);
        %spd=typecast(uint8(spdu8),'int16');
        %dir=typecast(uint8(diru8),'int16');
        tacho=typecast(uint8(tachou8),'int16');
        dir=0;spd=0;
        %Collecting Image Data
        indata=indata(1:imgcol*imgrow);
        img=reshape(indata,[imgcol,imgrow]);
        img=img.';
        
        %Apply the algorithms
        [out algdir algspd]=alg(img);
        
        %Logging the results
        %imglog(:,:,end+1)=img;
        %dirlog(end+1)=dir;
        %spdlog(end+1)=spd;
        %tacholog(end+1)=tacho;
        
        %update FrameNumer
        frameNum=frameNum+1;
        
        %Sending Back Data;
        dataout=[typecast(int16(algspd),'uint8'), ...
                 typecast(int16(algdir),'uint8')];
        UpdateFigures;
    else
        disp('Invalid frame size!');
    end
    fwrite(com,dataout);
end

%%
fclose(com);
