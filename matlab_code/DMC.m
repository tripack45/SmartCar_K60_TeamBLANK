%DMC控制算法
clc;
clear all;
G=input('输入传递函数G=');%输入传递函数
%判断是否为稳定系统，若是可以控制，若不是，则无法用DMC算法进行控制
den=G.den{1};      %取传函的分母
p=real(roots(den)) %求传函的极点的实部
for i=1:length(p)
       r=p(i);
   if r>0   %若有某一个极点的实部的实部大于零，则为不稳定系统，DMC无法控制
      p,G   %在命令窗口显示极点和传函
Error=('您要控制的对象为不稳定系统，DMC算法只适用于稳定系统!')
    return
  end
end
%设置DMC参数
Ts=input('采样周期 Ts= ');%采样时间
P=input('预测时域 P= ');%预测步长
M=input('控制时域 M= ');%控制步长
N=80;%截断步长
%设定参考值
yr=10; %系统期望输出
%建立系统阶跃响应模型
[y0,t0]=step(G,0:5:500);
%初始化DMC
A=zeros(P,M);%动态矩阵
a=zeros(N,1);
for i=1:N
    a(i)=y0(i);
end
for i=1:P
    for j=1:M
        if i-j+1>0
            A(i,j)=a(i-j+1); %构造矩阵A
        end
    end
end
%初始化向量ys，y,u,e和矩阵A0
ys=ones(N,1);
y=zeros(N,1);
u=zeros(N,1);
e=zeros(N,1);
A0=zeros(P,N-1);
for i=1:P
    for j=N-2:-1:1
        if N-j+1+i-1<=N
            A0(i,j)=a(N-j+1+i-1)-a(N-j+i-1);%构造矩阵A0
        else
            A0(i,j)=0;
        end
    end
    A0(i,N-1)=a(i+1);
end
%DMC程序
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
    delta_u=inv(A'*A+eye(M))*A'*(Yr-Y0-Ek); %控制增量的计算
    for i=1:M
        if k+i-1<=N
            u(k+i-1)=u(k+i-1-1)+delta_u(i);  %控制律的计算
        end
    end
    temp=0;%设置在k-j-1时刻以前的控制律
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

%画图显示结果
t=10*(1:N);
subplot(211);
plot(t,y);
title('DMC控制输出曲线');
xlabel('t')
ylabel('y')
grid on
subplot(212);
plot(t,u,'r');
title('控制作用');
xlabel('t')
ylabel('u')
grid on
