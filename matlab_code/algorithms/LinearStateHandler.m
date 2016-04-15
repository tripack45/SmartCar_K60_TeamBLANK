function [currdir currspd]=LinearStateHandler(currentState)
%constants
TCARPOSX       = 80;
TCARPOSY       = 101;
DANGERZONE     = 20;
FASTSPEED      = 30;
LOWSPEED       = 13;
DIRSENSITIVITY = 10;

currdir=int16(0);
currspd=int16(0);

if ( abs(int16(currentState.lineAlpha * TCARPOSY + currentState.lineBeta) - TCARPOSX)...
    < DANGERZONE)
    currdir = - (int16(currentState.lineBeta) - TCARPOSX) * DIRSENSITIVITY;
    currspd = FASTSPEED;
else
    currdir = - (int16(currentState.lineAlpha * TCARPOSY + currentState.lineBeta)...
        - TCARPOSX) * DIRSENSITIVITY;
    currspd = LOWSPEED;
end

end