%%
%setup¡¢
clc;
disp('Closing com');
try 
    fclose(com);
catch
end
try
    fclose(com_ack);
catch
end
imgrow=67;
imgcol=77;
extraInfoSize=6;
%COM4, BuadRate 115200, DataBits 8
%fclose(com);
disp('Reopening Com');

%com_ack = serial('COM28','BaudRate',115200,'DataBits',8);
%fopen(com_ack);
global com;

com = serial('COM11','BaudRate',115200*500,'DataBits',8);
%com = serial('COM28','BaudRate',115200,'DataBits',8);
set(com,'InputBufferSize',imgrow*100*40);
fopen(com); %opens the Serial Port
fwrite(com,'abc');
disp('Preparing to buffer')


%% Graphic Initializations
try
    set(h,'Visible','on');
    figure(h);
catch
    h=figure;
end
set(h,'Renderer','OpenGL');
set(h,'Position',[58,126,1300,557]);
set(h,'KeyPressFcn',@keyboard_callback);
ax1=subplot(1,2,1);
imin=image(ones(imgrow,imgcol));
colormap(ax1,gray);
axis equal;
axis manual;
text(0,-10,'DIR:','Color','Black');
text(20,-10,'SPD:','Color','Black');
text(40,-10,'TCH:','Color','Black');

t3=text( 7,-10,'000','Color','Black');
t4=text( 27,-10,'000','Color','Black');
t5=text( 47,-10,'000','Color','Black');

ax2=subplot(1,2,2);
imalg=image(ones(150,150));
colormap(ax2,colorcube);
axis equal;
axis manual;
caxis manual;
caxis([0,255]);
text(0,-10,'DIR:','Color','Black');
text(20,-10,'SPD:','Color','Black');
t1=text( 7,-10,'000','Color','Black');
t2=text( 27,-10,'000','Color','Black');
%text(-30,-10,'Time:','Color','Black');
%t3=text(-23,-10,'000','Color','Black');

%%
frame=ones(imgrow,imgcol,1);
dirlog=[];
spdlog=[];
tacholog=[];

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
    
    if length(indata)==imgcol*imgrow+extraInfoSize
        spdu8=indata(end-5:end-4);
        diru8=indata(end-3:end-2);
        tachou8=indata(end-1:end);
        spd=typecast(uint8(spdu8),'int16');
        dir=typecast(uint8(diru8),'int16');
        tacho=typecast(uint8(tachou8),'int16');
        set(t3,'String',num2str(dir));
        set(t4,'String',num2str(double(spd)/100*27));
        set(t5,'String',num2str(tacho));
        
        indata=indata(1:end-extraInfoSize);
        img=reshape(indata,[imgcol,imgrow]);
        img=img.';
        set(imin,'CData',img);
        frame(:,:,end+1)=img;
        dirlog(end+1)=dir;
        spdlog(end+1)=spd;
        tacholog(end+1)=tacho;
        
        %[out dir spd]=alg(img,TrackWidth);
        %set(imalg,'CData',out);
        set(t1,'String',num2str(dir));
        set(t2,'String',num2str(spd));
        drawnow nocallbacks;
       
        %drawnow nocallbacks ;
        %toc;
    else
        disp('Invalid frame size!');
    end
end

%%
fclose(com);
