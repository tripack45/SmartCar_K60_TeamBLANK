classdef CArray
    %CARRAY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Data;
    end
    
    methods
        function obj=CArray(initMatrix)
            obj.Data=initMatrix;
        end
        
        function val=subsref(obj,S)
            if strcmp(S.type,'()')
                for i=1:size(S.subs,2)
                    S.subs{i}=S.subs{i}+1;
                end
                val=subsref(obj.Data,S);
                return;
            else
                val=obj.Data;
            end
        end
        
        function obj=subsasgn(obj,S,val)
            if strcmp(S.type,'()')
                for i=1:size(S.subs,2)
                    S.subs{i}=S.subs{i}+1;
                end
                obj.Data=subsasgn(obj.Data,S,val);
                return;
            else
                obj=obj;
            end
        end
    end
    
end

