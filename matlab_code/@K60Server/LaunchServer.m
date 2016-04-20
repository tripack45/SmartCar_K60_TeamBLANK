function LaunchServer(obj)
clc;
disp('Closing com');
try
    fclose(obj.comData);
catch
end
disp('Reopening Com');
fopen(obj.comData);
fwrite(obj.comData,'abc');
disp('Preparing to buffer');
disp('Recieving...');
obj.Show();


b_buffer=[];
while 1
    if length(b_buffer)>3 * obj.imageHeight * obj.imageWidth;
        b_buffer=[];
    end
    head_found=false;
    while ~head_found
        if obj.comData.BytesAvailable>0
            b_buffer=[b_buffer; ...
                fread(obj.comData,obj.comData.BytesAvailable)];
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
        elseif(length(b_buffer)>3 * obj.imageHeight * obj.imageWidth)
            b_buffer=[];
        end
    end
    tail_found=false;
    while ~tail_found
        if obj.comData.BytesAvailable>0
            b_buffer=[b_buffer; ...
                fread(obj.comData,obj.comData.BytesAvailable)];
        end
        tail_pos=strfind(b_buffer', [160,0,160]);
        if ~isempty(tail_pos)
            %disp('tail found');
            tail_pos=tail_pos(1);
            tail_found=true;
            indata=b_buffer(1:tail_pos-1);
            b_buffer(1:tail_pos+2)=[];
        elseif(length(b_buffer)>3 * obj.imageHeight * obj.imageWidth)
            b_buffer=[];
        end
    end
    %disp('drawing');
    
    packageSize = obj.imageHeight * obj.imageWidth + obj.extraInfoByte;
    if length(indata)==packageSize
        instance = ParsePackage(indata);
        obj.feed{end+1}=instance;
        
        [out,algdir,algspd]=alg(instance.frame);
        algResult.display=out;
        algResult.dir    =algdir;
        algResult.spd    =algspd;
        
        obj.UpdateFigures(instance,algResult);
    else
        disp('Invalid frame size!');
    end
end
end

function instance=ParsePackage(indata)
h=K60Server.imageHeight;
w=K60Server.imageWidth;

instance=struct();
E=h * w;
spdu8=indata(E+1:E+2);
diru8=indata(E+3:E+4);
tachou8=indata(E+5:E+6);
frameCounter32=indata(E+7:E+10);

instance.spd=typecast(uint8(spdu8),'int16');
instance.dir=typecast(uint8(diru8),'int16');
instance.tacho=typecast(uint8(tachou8),'int16');
instance.frameNumber=typecast(uint8(frameCounter32),'int32');

img=indata(1:h * w);
img=reshape(img,[w,h]);
img=img.';
instance.frame=img;
end