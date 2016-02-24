t=ones(300,400);
h=imshow(t);
while(true)
    t=rand(300,400);
    set(h,'CData',t);
    drawnow
end

%%
indata=input(1:98*50);
img=reshape(indata,[98,50]);
img=img.';
colormap(gray);
image(img);

%%
state=0; %currently outside a frame:
t=get(com,'BytesAvailable');
input=fread(com,t);

%%
input=b_buffer;
tbuffer=[];
state=0;
    
%%
indata=input2(1:98*50);
img=reshape(indata,[98,50]);
img=img.';
colormap(gray);
image(img);    

    
