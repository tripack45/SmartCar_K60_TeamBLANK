%DMC�����㷨
clc;
clear all;
G=input('���봫�ݺ���G=');%���봫�ݺ���
%�ж��Ƿ�Ϊ�ȶ�ϵͳ�����ǿ��Կ��ƣ������ǣ����޷���DMC�㷨���п���
den=G.den{1};      %ȡ�����ķ�ĸ
p=real(roots(den)) %�󴫺��ļ����ʵ��
for i=1:length(p)
       r=p(i);
   if r>0   %����ĳһ�������ʵ����ʵ�������㣬��Ϊ���ȶ�ϵͳ��DMC�޷�����
      p,G   %���������ʾ����ʹ���
Error=('��Ҫ���ƵĶ���Ϊ���ȶ�ϵͳ��DMC�㷨ֻ�������ȶ�ϵͳ!')
    return
  end
end
%����DMC����
Ts=input('�������� Ts= ');%����ʱ��
P=input('Ԥ��ʱ�� P= ');%Ԥ�ⲽ��
M=input('����ʱ�� M= ');%���Ʋ���
N=80;%�ضϲ���
%�趨�ο�ֵ
yr=10; %ϵͳ�������
%����ϵͳ��Ծ��Ӧģ��
[y0,t0]=step(G,0:5:500);
%��ʼ��DMC
A=zeros(P,M);%��̬����
a=zeros(N,1);
for i=1:N
    a(i)=y0(i);
end
for i=1:P
    for j=1:M
        if i-j+1>0
            A(i,j)=a(i-j+1); %�������A
        end
    end
end
%��ʼ������ys��y,u,e�;���A0
ys=ones(N,1);
y=zeros(N,1);
u=zeros(N,1);
e=zeros(N,1);
A0=zeros(P,N-1);
for i=1:P
    for j=N-2:-1:1
        if N-j+1+i-1<=N
            A0(i,j)=a(N-j+1+i-1)-a(N-j+i-1);%�������A0
        else
            A0(i,j)=0;
        end
    end
    A0(i,N-1)=a(i+1);
end
%DMC����
for k=2:N
    Uk_1=zeros(N-1,1);
    for i=1:N-1
        if k-N+i<=0
            Uk_1(i)=0;
        else
            Uk_1(i)=u(k-N+i);
        end
    end
    Y0=A0*Uk_1;
    e(k)=y(k-1)-Y0(1);
    Yr=zeros(P,1);
    for i=1:P
        Yr(i)=yr;
    end
    Ek=zeros(P,1);
    for i=1:P
        Ek(i)=e(k);
    end
    delta_u=inv(A'*A+eye(M))*A'*(Yr-Y0-Ek); %���������ļ���
    for i=1:M
        if k+i-1<=N
            u(k+i-1)=u(k+i-1-1)+delta_u(i);  %�����ɵļ���
        end
    end
    temp=0;%������k-j-1ʱ����ǰ�Ŀ�����
    for j=1:N-1
        if k-j<=0
            temp;
        else
            if k-j-1<=0
                temp=temp+a(j)*u(k-j);
            else
                temp=temp+a(j)*(u(k-j)-u(k-j-1));
            end
        end
    end
    if k-N<=0
        y(k)=temp+e(N);
    else
        y(k)=temp+a(N)*u(k-N)+e(N);
    end
end

%��ͼ��ʾ���
t=10*(1:N);
subplot(211);
plot(t,y);
title('DMC�����������');
xlabel('t')
ylabel('y')
grid on
subplot(212);
plot(t,u,'r');
title('��������');
xlabel('t')
ylabel('u')
grid on
