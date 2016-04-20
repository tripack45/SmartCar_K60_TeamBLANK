function SaveRep(obj, name )
%SAVEREP Summary of this function goes here
%   Detailed explanation goes here
eval([name,'=obj.feed']);
save([name,'.mat'],name);

end

