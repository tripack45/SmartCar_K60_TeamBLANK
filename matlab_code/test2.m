%%
fclose(com);
set(com,'BaudRate',115200);
set(com,'InputBufferSize',50*100*2);
fopen(com);

%%
clear('input');
input=fread(com,get(com,'BytesAvailable'));
b_buffer=input;
%plot(input);

%%
while(i<=50*300*3)
    if(~ (input(i)==mod(input(i-1)+1,256)) )
        disp([i,input(i-1),input(i)]);
        i=i+1;
        return;
    end
    i=i+1;
end
disp('over');
%%
num=find(b_buffer==255,1);
for n=1:10000
    input2(n)=b_buffer(mod(n+num-1,10000)+1);
end
input2=input2.';