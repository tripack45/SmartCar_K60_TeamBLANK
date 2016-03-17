function pro31(x,y)

A=[sum(y.^2.*x) sum(x.*x) sum(y.*x) sum(x.^2.*y) sum(x);
    sum(y.^3) sum(x.*y) sum(y.*y) sum(y.^2.*x) sum(y);
    sum(y.^2) sum(x) sum(y) sum(y.*x) sum(x./x); 
    sum(y.^4) sum(x.*y.^2) sum(y.^3) sum(y.^3.*x) sum(y.^2);
    sum(x.*y.^3) sum(x.^2.*y) sum(y.^2.*x) sum(y.^2.*x.^2) sum(x.*y);];
B=[-sum(x.^3); -sum(x.^2.*y); -sum(x.^2); -sum(x.^2.*y.^2); sum(x.^3.*y) ];
C=A\B;
fprintf(sprintf('x^2+%fy^2+%fx+%fy+%fxy+%f\r',C(1),C(2),C(3),C(4),C(5)))
hold on
scatter(x,y);
ezplot(sprintf('x.^2+%f*y.^2+%f*x+%f*y+%f*x.*y+%f',C(1),C(2),C(3),C(4),C(5)));
axis equal
hold off
grid on 
end

