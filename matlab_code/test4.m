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
com = serial('COM10','BaudRate',460800,'DataBits',8);
set(com,'InputBufferSize',imgrow*100*4);
fopen(com); %opens the Serial Port

% currimg=ones(imgrows,imgcols);
% hgraph=imshow(currimg);
% colormap(gray);
% drawnow;
%
%
% global sbuffer;
% sbuffer=[];

%%
b_buffer=0;
while 1
    %read the number
    clear('input');
    while get(com,'BytesAvailable')>imgcol*imgrow
        input=fread(com,get(com,'BytesAvailable'));
        b_buffer=[b_buffer; input];
        while length(b_buffer)>=imgcol*imgrow*2
            %plot(input);
            %%
            flag_lcc=0;
            head=find(b_buffer==255,1);
            if b_buffer(head+1)==0&&b_buffer(head+2)==255&&head<length(b_buffer)-4906
                input2(1:imgcol*imgrow+3)=b_buffer(head+3:head+imgcol*imgrow+5);
                b_buffer(1:head+4905)=[];
                fprintf(sprintf('the head is ok\r'));
            else
                fprintf(sprintf('the head is lost\r'));
                break
            end
            tail=find(input2==160,1);
            if length(tail)>0&&input2(tail+1)==0&&input2(tail+2)==160
                fprintf(sprintf('the tail is ok\r'));
                if tail==imgcol*imgrow+1;
                    fprintf(sprintf('no information lost\r'));
                else
                    fprintf(sprintf('some information is lost\r'));
                end
            else
                fprintf(sprintf('the tail is lost\r'));
            end
            input2=input2.';
            
            %%
            
            indata=input2(1:imgcol*imgrow);
            img=reshape(indata,[imgcol,imgrow]);
            img=img.';
            colormap(gray);
            image(img);
            axis equal;
            drawnow;
        end
    end
end

%%
fclose(com);
