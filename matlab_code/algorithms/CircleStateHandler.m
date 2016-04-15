function [currdir, currspd]=CircleStateHandler(currentState)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
MSE_RATIO          = 2;
OFFSET_THRES       = 10;
OFFSET_DIR_RATIO   = 10;
SPD_MAX            = 30;
SPD_MIN            = 10;
RADIUS_MIN         = 70;
RADIUS_MAX         = 300;
DIR_HALF           = 300;
DIR_MAX            = 600;
CURVE_DIR_RATIO    = (RADIUS_MIN * DIR_HALF);
CURVE_SPD_RATIO    = 0.05;
OFFSET_SPD_RATIO   = 0.5;
BASIC_SPD          = 10;
direction          = 1;
if (currentState.lineMSE < MSE_RATIO * currentState.circleMSE)
    [currdir, currspd] = LinearStateHandler(currentState);
    return;
else
    if (currentState.circleX > currentState.carPosX) 
        direction = -1;
    end
    offset=sqrt((currentState.carPosX-currentState.circleX)^2+(currentState.carPosY-currentState.circleY)^2)-currentState.circleRadius;
    if (offset < OFFSET_THRES && offset > -OFFSET_THRES)
      theta = direction * CURVE_DIR_RATIO / currentState.circleRadius + OFFSET_DIR_RATIO * offset;
      if (theta > DIR_MAX || theta < -DIR_MAX)
        currdir = direction * DIR_MAX;
        currspd = BASIC_SPD;
        return;
      end
      speed = floor(CURVE_SPD_RATIO * currentState.circleRadius - OFFSET_SPD_RATIO * offset + BASIC_SPD);
      if (speed > SPD_MAX) 
          speed = SPD_MAX;
      end
      if (speed < SPD_MIN) 
          speed = SPD_MIN;
      end
      currdir = theta;
      currspd = speed;
      return;
     end
    if (offset < 0)
      currdir = 0;
      currspd = SPD_MAX;
      return;
    else
      currdir = direction * DIR_MAX;
      currspd = SPD_MIN;
      return;
    end
end
end

