classdef K60Server < handle
    % K60SERVER Implements a singleton design
    % A set of tools for parsing/displaying/test live feed from the racing
    % car
    
    properties (Constant=true)
        imageHeight=61;
        imageWidth =77;
        displayHeight = 200;
        displayWidth  = 200;
        extraInfoByte = 10;
    end
    
    properties (Access=public)
        figureHandle;
        plotSource;
        plotDisplay;
        imageFeed;
        imageDisplay;
        
        feed={};
        replayCount=1;
        
        comData;
        
        UIText=struct();
    end
    
    methods (Access=public)
        function Show(obj)
            set(obj.figureHandle,'Visible','on');
            figure(obj.figureHandle);
        end
        
        function Hide(obj)
            set(obj.figureHandle,'Visible','off');
        end
        
        function SetFeed(obj,nFeed)
            obj.feed=nFeed;
        end
        
        function delete(obj)
            delete(obj.figureHandle);
            try
                fclose(obj.comData);
                
            catch
            end
            delete(obj.comData);
            clear classes;
        end
        
        ReplayWithAlg(obj,start,fps);
        TestOnFrame(obj,frameNum);
        LoadReplay(obj,name);
        SaveReplay(obj,name);
        LaunchServer(obj);
    end
    
    methods (Access=private)
        function obj = K60Server()
            InitializeFigures(obj);
            obj.comData = serial('COM11','BaudRate',115200*500,'DataBits',8);
            obj.comData.InputBufferSize=100*100*40;
        end

        InitializeFigures(obj);
        UpdateFigures(obj,instance,algResult)

    end
    
    methods (Static=true)
        function out = GetInstance()
            persistent objh;
            if(isempty(objh))
                objh = K60Server();
                out =objh;
                return;
            else
                out = objh;
                return;
            end   
        end
    end
    
    
end

