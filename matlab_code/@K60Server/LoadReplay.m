function LoadReplay(obj,name)
%LOADREPLAY 
load([name,'.mat']);
eval(['obj.SetFeed(',name,')']);
end

