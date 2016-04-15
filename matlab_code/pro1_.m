function pro1(x,y)
n=size(x,2);
x2=0;
y2=0;
sx2=0;
sxy=0;
sy2=0;
sx=0;
sy=0;
sb1=0;
sb2=0;
sb3=0;
det=0;
for i=1:n
    sx=sx+x(i);
    sy=sy+y(i);
    x2=x(i)*x(i);
    sx2=sx2+x2;
    y2=y(i)*y(i);
    sy2=sy2+y2;
    sxy=sxy+x(i)*y(i);
    sb1=sb1+(x2+y2)*x(i);
    sb2=sb2+(x2+y2)*y(i);
end
sb3=sx2+sy2;
det=n*sx2*sy2+2*sx*sy*sxy-n*sxy*sxy-sx*sx*sy2-sy*sy*sx2;
sa1=n*sy2-sy*sy;
sa2=sx*sy-n*sxy;
sa3=sxy*sy-sx*sy2;
sa4=sa2;
sa5=n*sx2-sx*sx;
sa6=sxy*sx-sy*sx2;
sa7=sa3;
sa8=sa6;
sa9=sx2*sy2-sxy*sxy;
A=[sa1,sa2,sa3; sa4,sa5,sa6; sa7,sa8,sa9];
B=[-sb1; -sb2; -sb3];
C=A*B./det;
x0=-C(1)/2
y0=-C(2)/2
r=sqrt(-C(3)+x0^2+y0^2)
fprintf(sprintf('(x-%f)^2+(y-%f)^2=(%f)^2\r',x0,y0,r));
p=[0:2*pi/100:2*pi];
xx=r.*cos(p)+x0;
yy=r.*sin(p)+y0;
hold on
plot(xx,yy);
scatter(x,y);
axis equal
hold off
grid
end
