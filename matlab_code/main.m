%%
%setup¡¢
clc;
disp('Closing com');
if(exist('com'))
    fclose(com);
end
if(exist('com_ack'))
    fclose(com_ack);
end
imgrow=67;
imgcol=77;
%COM4, BuadRate 115200, DataBits 8
%fclose(com);
disp('Reopening Com');

%com_ack = serial('COM28','BaudRate',115200,'DataBits',8);
%fopen(com_ack);
global com;
com = serial('COM18','BaudRate',115200*500,'DataBits',8);
%com = serial('COM28','BaudRate',115200,'DataBits',8);
set(com,'InputBufferSize',imgrow*100*4);
fopen(com); %opens the Serial Port
fwrite(com,'abc');
disp('Preparing to buffer')


%% Graphic Initializations
h1=figure;
colormap(h1,gray);
im=image(ones(imgrow,imgcol));
axis equal;
set(gcf,'KeyPressFcn',@keyboard_callback);

h2=figure;
imalg=image(ones(imgrow,imgcol));
colormap(h2,colorcube);
axis equal;
caxis manual;
caxis([0,255]);
text(0,-1,'DIR:','Color','Black');
text(20,-1,'SPD:','Color','Black');
t1=text( 7,-1,'000','Color','Black');
t2=text( 27,-1,'000','Color','Black');
TrackWidth=z;
%
% hgraph=imshow(currimg);
% colormap(gray);
% drawnow;
%
%
% global sbuffer;
% sbuffer=[];

%%
frame=ones(imgrow,imgcol,1);
disp('Recieving');
b_buffer=[];
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
    
    %fwrite(com,[172,160,0,0,76]);
    
    if length(indata)==imgcol*imgrow
        img=reshape(indata,[imgcol,imgrow]);
        img=img.';
        set(im,'CData',img);
        frame(:,:,end+1)=img;
        drawnow;
        
        [out dir spd]=alg(img);
        set(imalg,'CData',out);
        set(t1,'String',num2str(dir));
        set(t2,'String',num2str(spd));
        drawnow;
       
        %drawnow nocallbacks ;
        %toc;
    else
        disp('Invalid frame size!');
    end
end

%%
fclose(com);
