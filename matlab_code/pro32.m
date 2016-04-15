function pro32(x,y)
acnum=30;
x0=mean(x);
y0=mean(y);
a=mean(sqrt((x-x0).^2+(y-y0).^2));
b=mean(sqrt((x-x0).^2+(y-y0).^2));
t=0;
d=mind(x,y,t,a,b,x0,y0);
d0=sum(d.^2);
n=0;
t=0;
tic
ac=(min(max(x)-min(x),max(y)-min(y)))/10;
step=0;
for n=1:acnum
    ac=ac/2;
    while n~=10
        step=step+1;
        n=0;
        x1=x0+ac;
        dd=mind(x,y,t,a,b,x1,y0);
        d1=sum(dd.^2);
        if d1<d0;
            x0=x1;
            d=dd;
            d0=d1;
            n=0;
        else
            n=n+1;
        end 
        x1=x0-ac;
        dd=mind(x,y,t,a,b,x1,y0);
        d1=sum(dd.^2);
        if d1<d0;
            x0=x1;
            d=dd;
            d0=d1;
           n=0;
        else
            n=n+1;
       end 
        y1=y0+ac;
        dd=mind(x,y,t,a,b,x0,y1);
        d1=sum(dd.^2);
        if d1<d0;
           y0=y1;
           d=dd;
           d0=d1;
        n=0;
        else
            n=n+1;
        end 
        y1=y0-ac;
        dd=mind(x,y,t,a,b,x0,y1);
        d1=sum(dd.^2);
        if d1<d0;
            y0=y1;
            d=dd;
            d0=d1;
            n=0;
        else
            n=n+1;
        end  
        a1=a+ac;
        dd=mind(x,y,t,a1,b,x0,y0);
        d1=sum(dd.^2);
        if d1<d0;
            a=a1;
            d=dd;
            d0=d1;
            n=0;
        else
            n=n+1;
        end  
        a1=a-ac;
        dd=mind(x,y,t,a1,b,x0,y0);
        d1=sum(dd.^2);
        if d1<d0;
            a=a1;
           d=dd;
            d0=d1;
            n=0;
        else
            n=n+1;
        end  
        b1=b+ac;
        dd=mind(x,y,t,a,b1,x0,y0);
        d1=sum(dd.^2);
        if d1<d0;
            b=b1;
            d=dd;
            d0=d1;
            n=0;
        else
            n=n+1;
        end  
        b1=b-ac;
        dd=mind(x,y,t,a,b1,x0,y0);
        d1=sum(dd.^2);
        if d1<d0;
            b=b1;
            d=dd;
            d0=d1;
            n=0;
        else
            n=n+1;
        end  
        t1=t+ac;
        dd=mind(x,y,t1,a,b,x0,y0);
        d1=sum(dd.^2);
        if d1<d0;
            t=t1;
            d=dd;
            d0=d1;
            n=0;
        else
            n=n+1;
        end  
        t1=t-ac;
        dd=mind(x,y,t1,a,b,x0,y0);
        d1=sum(dd.^2);
        if d1<d0;
            t=t1;
            d=dd;
            d0=d1;
            n=0;
        else
            n=n+1;
        end 
    end
end
toc
x0
y0
a
b
t
step
p=[0:2*pi/100:2*pi];
xx=a.*cos(p+t)+x0;
yy=b.*sin(p+t)+y0;
fprintf(sprintf('x=%fcos(theta+%f)+%f\ry=%fsin(theta+%f)+%f\r',a,t,x0,b,t,y0))
hold on
plot(xx,yy);
scatter(x,y);
axis equal
hold off
grid
end

function d=mind(x,y,t,a,b,x0,y0)
num=1000;
for n=1:length(x)
    d(n)=inf;
    for p=0:2*pi/num:2*pi;
        d11=sqrt((x(n)-a*cos(p+t)-x0)^2+(y(n)-b*sin(p+t)-y0)^2);
        if d11<d(n)
            d(n)=d11;
        end
    end
end
end