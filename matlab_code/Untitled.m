if(state==0)
        sig=255;
    elseif(state==1)
        sig=160;
    end
    ind=find(input==sig);
    
    if(isempty(ind))
        if(state==0)
            input=[];
        else
            tbuffer=[tbuffer; input];
        end
        t=get(com,'BytesAvailable');
        input=fread(com,t);
    else
        ind=ind(1); %get the first index
        if(input(ind+1)==0 & input(ind+2)==sig)
            if(state==0)
                input=input(ind+3:end); %cut out first frames
            else
                tbuffer=[tbuffer;input(1:ind-1)]; %forming a frame;
                input=tbuffer(ind+3:end);
                if(length(tbuffer)<98*50-50)
                    
                else
                    img=reshape(tbuffer,[98,50]);
                    img=img.';
                    set(hgraph,'CData',img);
                    drawnow
                end
            end
            state=1-state; %switch state
        end
    end