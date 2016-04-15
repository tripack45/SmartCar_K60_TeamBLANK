function pro2_(x,y)
acnum=30;

A=[sum(x.*x) sum(y.*x) sum(x); sum(x.*y) sum(y.*y) sum(y);sum(x) sum(y) sum(x./x)];
B=[-sum(x.^3+y.^2.*x); -sum(y.^3+x.^2.*y); -sum(y.^2+x.^2)];
C=A\B;
a=-C(1)/2;
b=-C(2)/2;
r=mean(sqrt((x-a).^2+(y-b).^2));
d=sum((sqrt((x-a).^2+(y-b).^2)-r).^2);
n=0;
step=0;
tic
ac=(min(max(x)-min(x),max(y)-min(y)))/10;
for n=1:acnum
    ac=ac/2;
    while n~=4
        step=step+1;
        n=0;
        a1=a+ac;
        r1=mean(sqrt((x-a1).^2+(y-b).^2));
        d1=sum((sqrt((x-a1).^2+(y-b).^2)-r1).^2);
        if d1<d
            a=a1;
            r=r1;
            d=d1;
            n=0;
        else
            n=n+1;
        end 
        a1=a-ac;
        r1=mean(sqrt((x-a1).^2+(y-b).^2));
        d1=sum((sqrt((x-a1).^2+(y-b).^2)-r1).^2);
        if d1<d
            a=a1;
            r=r1;
            d=d1;
            n=0;
        else
            n=n+1;
        end
        b1=b-ac;
        r1=mean(sqrt((x-a).^2+(y-b1).^2));
        d1=sum((sqrt((x-a).^2+(y-b1).^2)-r1).^2);
        if d1<d
            b=b1;
            r=r1;
            d=d1;
            n=0;
        else
            n=n+1;
        end 
        b1=b+ac;
        r1=mean(sqrt((x-a).^2+(y-b1).^2));
        d1=sum((sqrt((x-a).^2+(y-b1).^2)-r1).^2);
        if d1<d
            b=b1;
            r=r1;
            d=d1;
            n=0;
        else
            n=n+1;
        end 
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