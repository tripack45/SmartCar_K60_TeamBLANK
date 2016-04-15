fid=fopen('input.txt','wt'); 
[m,n]=size(input);  
for i=1:m     
    for j=1:n        
        fprintf(fid,'%g\t',input(i,j)); 
    end
    fprintf(fid,'\n');        
end
fclose(fid);