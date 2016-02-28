while(1)
t=get(com,'BytesAvailable');
if(t>0)
fread(com,t);
end
end