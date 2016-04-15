function pro1(x,y)

A=[sum(x.*x) sum(y.*x) sum(x); 
    sum(x.*y) sum(y.*y) sum(y);
    sum(x) sum(y) sum(x./x)];
B=[-sum(x.^3+y.^2.*x); -sum(y.^3+x.^2.*y); -sum(y.^2+x.^2)];
C=A\B;
x0=-C(1)/2
y0=-C(2)/2
r=sqrt(-C(3)+x0^2+y0^2)
fprintf(sprintf('(x-%f)^2+£¨y-%f)^2=(%f)^2\r',x0,y0,r));
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
