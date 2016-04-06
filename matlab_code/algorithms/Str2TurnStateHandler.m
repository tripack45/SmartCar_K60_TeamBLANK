function [currdir currspd]=Str2TurnStateHandler(currentState)
%constants
DANGERZONE     = 20;
LOWSPEED       = 13;
DIRSENSITIVITY = 10;
CHANGE_ZONE    = 10;

currdir=int16(0);
currspd=int16(0);

if ( abs(int16(currentState.lineAlpha * TCARPOSY + currentState.lineBeta) - TCARPOSX)...
    < DANGERZONE)
    currdir = - (int16(currentState.lineBeta) - TCARPOSX-currentState.isleft*CHANGE_ZONE) * DIRSENSITIVITY;
    currspd = LOWSPEED;
else
    currdir = - (int16(currentState.lineAlpha * TCARPOSY + currentState.lineBeta)...
        - TCARPOSX) * DIRSENSITIVITY;
    currspd = LOWSPEED;
end

end