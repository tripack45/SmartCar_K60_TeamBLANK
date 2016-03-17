function pro31_(x,y)
acnum=30;
B=1;
C=mean(x)*2;
D=mean(y)*2;
E=0;
F=(max(x)-min(x))^2+(max(y)-min(y))^2-(max(x)-min(x))*(max(y)-min(y))
d=sum((x.^2+B*y.^2+C*x+D*y+E*x.*y+F).^2)
step=0;

tic
ac=(min(max(x)-min(x),max(y)-min(y)))/10;
for n=1:acnum
    ac=ac/2;
    while n~=10
        step=step+1;
        n=0;
        B1=B+ac;
        d1=sum((x.^2+B1*y.^2+C*x+D*y+E*x.*y+F).^2);
        if d1<d
            B=B1;
            d=d1;
            n=0;
        else
            n=n+1;
        end 
        B1=B-ac;
        d1=sum((x.^2+B1*y.^2+C*x+D*y+E*x.*y+F).^2);
        if B1>0
            if d1<d
                B=B1;
                d=d1;
                n=0;
            else
                n=n+1;
            end
        end
        C1=C+ac;
        d1=sum((x.^2+B*y.^2+C1*x+D*y+E*x.*y+F).^2);
        if d1<d
            C=C1;
            d=d1;
            n=0;
        else
            n=n+1;
        end 
        C1=C-ac;
        d1=sum((x.^2+B*y.^2+C1*x+D*y+E*x.*y+F).^2);
        if d1<d
            C=C1;
            d=d1;
            n=0;
        else
            n=n+1;
        end 
        D1=D+ac;
        d1=sum((x.^2+B*y.^2+C*x+D1*y+E*x.*y+F).^2);
        if d1<d
            D=D1;
            d=d1;
            n=0;
        else
            n=n+1;
        end 
        D1=D-ac;
        d1=sum((x.^2+B*y.^2+C*x+D1*y+E*x.*y+F).^2);
        if d1<d
            D=D1;
            d=d1;
            n=0;
        else
            n=n+1;
        end 
        E1=E+ac;
        d1=sum((x.^2+B*y.^2+C*x+D*y+E1*x.*y+F).^2);
        if d1<d
            E=E1;
            d=d1;
            n=0;
        else
            n=n+1;
        end 
        E1=E-ac;
        d1=sum((x.^2+B*y.^2+C*x+D*y+E1*x.*y+F).^2);
        if d1<d
            E=E1;
            d=d1;
            n=0;
        else
            n=n+1;
        end 
        F1=F+ac;
        d1=sum((x.^2+B*y.^2+C*x+D*y+E*x.*y+F1).^2);
        if d1<d
            F=F1;
            d=d1;
            n=0;
        else
            n=n+1;
        end 
        F1=F-ac;
        d1=sum((x.^2+B*y.^2+C*x+D*y+E*x.*y+F1).^2);
        if d1<d
            F=F1;
            d=d1;
            n=0;
        else
            n=n+1;
        end
    end
end
toc
step
fprintf(sprintf('x^2+%fy^2+%fx+%fy+%fxy+%f\r',B,C,D,E,F))
hold on
scatter(x,y);
ezplot(sprintf('x.^2+%f*y.^2+%f*x+%f*y+%f*x.*y+%f',B,C,D,E,F),[2*max(x)-mean(x),2*min(x)-mean(x),2*max(y)-mean(y),2*min(y)-mean(y)]);
axis equal
hold off
grid on 
end