function pro2(x,y)
ac=0.0000000000001;
delta=0.001;
A=[sum(x.*x) sum(y.*x) sum(x); sum(x.*y) sum(y.*y) sum(y);sum(x) sum(y) sum(x./x)];
B=[-sum(x.^3+y.^2.*x); -sum(y.^3+x.^2.*y); -sum(y.^2+x.^2)];
C=A\B;
a=-C(1)/2;
b=-C(2)/2;
r=mean(sqrt((x-a).^2+(y-b).^2));
d=sum((sqrt((x-a).^2+(y-b).^2)-r).^2);
step=0;
tic
while 1
    step=step+1;
    a1=a+delta*sum((sqrt((x-a).^2+(y-b).^2)-r).*(x-a)./sqrt((x-a).^2+(y-b).^2));
    b1=b+delta*sum((sqrt((x-a).^2+(y-b).^2)-r).*(y-b)./sqrt((x-a).^2+(y-b).^2));
    r1=mean(sqrt((x-a1).^2+(y-b1).^2));
    d1=sum((sqrt((x-a1).^2+(y-b1).^2)-r1).^2);
    if d-d1>ac
        a=a1;
        b=b1;
        r=r1;
        d=d1;
    else
        break
    end 
    
end
toc
x0=a
y0=b
r
step
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
        