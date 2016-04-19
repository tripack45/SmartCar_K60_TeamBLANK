clear
clc
M=4;
P=80;
N=80;
a=[0:P-1]./(P-1);

% R: Radius of turning for direction at 40;
% v: Real_world_speed.
% R: Realworld=95pcm@dir=150
% V: Realworld=1.58m/s @tacho=20
R=95/45.5*70; v=245/2; dt=0.04;
dev=@(t) R*(1-cos(v*dt*t/R));


a(1)=dev(1);
for i=2:N
    a(i)=dev(i-1)+dev(1);
end

a=a./150;

c=[1,zeros(1,M-1)];
for m=1:M
    A(:,m)=[zeros(m-1,1);(a(1:P-m+1))'];
end

q=ones(P,1)*178*1.5;
for i=3:P
    q(i)=q(i)+i;
end
Q=zeros(P);
for i=1:P
    Q(i,i)=q(i);
end
r=ones(M,1)*1.5;
R=zeros(M);
for i=1:M
    R(i,i)=r(i);
end

td=c*inv(A'*Q*A+R)*A'*Q;

disp('');
fprintf('{');
for i=1:length(a)
    fprintf('%4f',a(i));
    if i~=length(a)
        fprintf(',');
    end
end
fprintf('};');
fprintf('\n');

fprintf('{');
for i=1:length(td)
    fprintf('%4f',td(i));
    if i~=length(td)
        fprintf(',');
    end
end
fprintf('};');
fprintf('\n');

MPC_P=P;
MPC_N=N;
MPCModel=a;
MPCControlVec=td
MPCCorrectionVec=ones(P,1)*0.1;
y=0;
MPCPrediction=ones(P,1)*25;
setPoint=0;
MPCLastOut=0;
out=[];
dout=[];
state=[];
% MPC

for T=1:200
   
  state(end+1)=MPCPrediction(1);
  %error = y - MPCPrediction(1);
  error=rand*2+1;
  for p=1:MPC_P
    MPCPrediction(p) = MPCPrediction(p) + MPCCorrectionVec(p) * error; 
  end
  
  for p=1:MPC_P-1
    MPCPrediction(p) = MPCPrediction(p+1);
  end
  
  deltaControl =0;
  for p=1:MPC_P
    e= setPoint - MPCPrediction(p);
    k= MPCControlVec(p);
    deltaControl = deltaControl + e * k;
  end
  
  dout(end+1)=deltaControl;
  
  MPCLastOut = MPCLastOut + deltaControl;
  
  for p=1:MPC_P
    if(p>=MPC_N)
      MPCPrediction(p)=MPCPrediction(p)+MPCModel(MPC_N-1) * deltaControl;
    else
      MPCPrediction(p)=MPCPrediction(p)+MPCModel(p) * deltaControl;
    end
  end
  
  
  out(end+1)=MPCLastOut;
  
end
  