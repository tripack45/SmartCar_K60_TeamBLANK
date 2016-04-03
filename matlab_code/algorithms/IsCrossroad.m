function [isCrossroad] = IsCrossroad(boundaryX,boundaryY,size)
MZ=1;
if (size<6)
    isCrossroad=0;
    return;
end
for (i=0:size-6)
    v0x=boundaryX(MZ+ i + 1) - boundaryX(MZ + i);
    v0y=boundaryY(MZ+ i + 1) - boundaryY(MZ + i);
    v1x=boundaryX(MZ+ i + 2) - boundaryX(MZ + i + 1);
    v1y=boundaryY(MZ+ i + 2) - boundaryY(MZ + i + 1);
    v3x=boundaryX(MZ+ i + 4) - boundaryX(MZ + i + 3);
    v3y=boundaryY(MZ+ i + 4) - boundaryY(MZ + i + 3);
    v4x=boundaryX(MZ+ i + 5) - boundaryX(MZ + i + 4);
    v4y=boundaryY(MZ+ i + 5) - boundaryY(MZ + i + 4);
    
    angle01=100*((v0x*v1x+v0y*v1y)^2)/((v0x^2+v0y^2)*(v1x^2+v1y^2));
    angle13=100*((v1x*v3x+v1y*v3y)^2)/((v1x^2+v1y^2)*(v3x^2+v3y^2));
    angle34=100*((v3x*v4x+v3y*v4y)^2)/((v3x^2+v3y^2)*(v4x^2+v4y^2));
    if(angle01>81 && angle13 <25 && angle34>81)
        isCrossroad = 1;
        return;
    end
    %fprintf('%f %f %f\n',angle01,angle13,angle34);
end
isCrossroad=0;
return;
end

