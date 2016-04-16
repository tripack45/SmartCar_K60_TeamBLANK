clear
M=5;
P=15;
N=15;
a=[0:P-1]./(P-1);

% R: Radius of turning for direction at 40;
% v: Real_world_speed.
% R: Realworld=95cm@dir=150
% V: Realworld=1.58m/s @tacho=20
R=95/45.5*70; v=245/2; dt=0.04;
dev=@(t) R*(1-cos(v*dt*t/R));


for i=1:N
    a(i)=dev(i);
end

a=a./150;

c=[1,zeros(1,M-1)];
for m=1:M
    A(:,m)=[zeros(m-1,1);(a(1:P-m+1))'];
end

q=ones(P,1)*178;
for i=1:P
    q(i)=q(i) + i *10;
end
Q=zeros(P);
for i=1:P
    Q(i,i)=q(i);
end
r=ones(M,1);
R=zeros(M);
for i=1:5
    R(i,i)=r(i);
end

td=c*inv(A'*Q*A+R)*A'*Q;

disp('');
fprintf('{');
for i=1:length(a)
    fprintf('%4f',a(i));
    fprintf(',');
end
fprintf('}');
fprintf('\n');

fprintf('{');
for i=1:length(td)
    fprintf('%4f',td(i));
    fprintf(',');
end
fprintf('}');
disp('');