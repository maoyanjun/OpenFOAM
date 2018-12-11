%作者：毛艳军
%时间：2016年7月15日
%单位：大连理工大学深海研究中心
%这段例子还调用了我自己写的专门画频谱图的函数，也给出，不然得不出我的结果
clear;
D = dir('E:\MATLAB-FFT\SC20_FL20_C1\*.mat');

for i = 1 : length(D)

load(['E:\MATLAB-FFT\SC20_FL20_C1\' D(i).name]);
filename=D(i).name;
filename
filename(end-3:end)=[];
x=Data;
fs=20000;
t=0:0.00005:DataCount/20000;t=t';t(DataCount+1)=[];
figure;
subplot(211);plot(t,x);
ylabel('幅值');xlabel('时间');title('sway历时线');
subplot(212);[a,b,e,g]=hua_fft(x,fs);
saveas(gcf,['E:\MATLAB-FFT\SC20_FL20_C1\',num2str(filename),'original.fig']);
f1=input('Please look at the picture,make sure and input the f1= （reference data 2.5） ');
f3=input('f3= （reference data 3.0） ');
rp=input('rp= （reference data 0.1）');
rs=input('rs= （reference data 2.0）');
j=1;
 while(b(j)<f1)
     c(j)=a(j);
     d(j)=b(j);
     j=j+1;
 end
%areasss=area(b,2*abs(a(1:g/2))/length(e))
%AreaOriginalData=trapz(b,2*abs(a(1:g/2))/length(e))
%AreaOriginal=trapz(d,2*abs(c(1:j-1))/length(e))
c=[];
d=[];
%低通测试
% y=filter(bz1,az1,x);
y=lowp(x,f1,f3,rp,rs,fs);%f1=2.5,f3=3.0,rp=0.1,rs=2.0
%y=hamingFirlowp(x,f1,f3,fs);
figure;
subplot(211);plot(t,y);
ylabel('幅值');xlabel('时间');title('sway历时线（afterFilter）');
subplot(212);[a,b,e,g]=hua_fft(y,fs);
saveas(gcf,['E:\MATLAB-FFT\SC20_FL20_C1\',num2str(filename),'Filter.fig']);
j=1;
 while(b(j)<f1)
     c(j)=a(j);
     d(j)=b(j);
     j=j+1;
 end
 %AreaFilterData=trapz(b,2*abs(a(1:g/2))/length(e))
 %AreaFilter=trapz(d,2*abs(c(1:j-1))/length(e))
 c=[];%清空数组
 d=[];%清空数组
error(i)=abs(AreaOriginal-AreaFilter)/AreaOriginal
[SNR,RMSE]=snr(x,y);
SNR
RMSE
disp('按任意键继续下一组数据处理')
pause
end