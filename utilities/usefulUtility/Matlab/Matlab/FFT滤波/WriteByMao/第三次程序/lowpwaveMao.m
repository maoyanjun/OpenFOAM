 %���ߣ�ë�޾�
%ʱ�䣺2016��7��15��
%��λ����������ѧ��о�����
%*********************************************************************%
clear;
key=input('please chose the way that you want to deal with the datas ,0 means single Data,1 means several Datas key=');%������ʾ����0,1��ѡ�����������ǵ����ļ�����
%********��������*********************************************%
if key==1
D = dir('E:\MATLAB-FFT\SC20_FL20_C1\*.mat');%��ȡ�ļ��е�ַ���ڲ��ļ���׺��ʹ��ʱ���ֶ��޸�
for i = 1 : length(D)%���ļ������ļ�����ѭ����ȡ

load(['E:\MATLAB-FFT\SC20_FL20_C1\' D(i).name]);%����i��˳�������ļ�
filename=D(i).name;%��������Ϊ�ַ���������ȡ�ļ���
filename%��ʾ�ļ���
filename(end-3:end)=[];%�����ļ����еĺ�׺.mat
x=Data;%����������
fs=20000;
t=0:0.00005:length(Data)/20000;t=t';t(length(Data)+1)=[];%���ݲ���Ƶ����Ƽ������ɢʱ�����飬ʱ�����ߺ�����
[pksOriginal,locs]=findpeaks(x,'minpeakdistance',24000,'MINPEAKHEIGHT',0.0);%�������˵��
figure;
subplot(211);plot(t,x);
ylabel('��ֵ');xlabel('ʱ��');title('sway��ʱ��');
hold on;
plot(locs/fs,pksOriginal,'rp');%Ӧ�÷���ֵ��ʱ�������ϱ�Ƿ�ֵ����ɫ�����
subplot(212);
[area,h,y_f]=hua_fft(x,fs);%�����׵Ļ��ƣ����ӳ����ڲ���ͼ����ֵ�׵�ƽ����ʾ������
h;
%[pksFFTOriginal,locsFFT]=findpeaks(h);��Ѱ�������׷�ֵ����ʱδ�����
saveas(gcf,['E:\MATLAB-FFT\SC20_FL20_C1\',num2str(filename),'original.fig']);%Ӧ���ļ�����original.fig���������ͼ�Σ�����λ���ֶ�����
f1=input('Please look at the picture,make sure and input the f1= ��reference data 2.5�� ');%�������뺬�������˵��
f3=input('f3= ��reference data 3.0�� ');
rp=input('rp= ��reference data 0.1��');%Ӧ��hann��ʱ��ע�͵�����
rs=input('rs= ��reference data 2.0��');%Ӧ��hann��ʱ��ע�͵�����
AreaOriginal=area;%��ʾ�˲�ǰ���������
%*********Ϊ�Խ���Ƶ��֮ǰ���ֽ��л���***********%
%j=1;
 %while(b(j)<f1)
  %   c(j)=a(j);
   %  d(j)=b(j);
    % j=j+1;
 %end
%areasss=area(b,2*abs(a(1:g/2))/length(e))%Ϊ�Ա�������ֳ���
%AreaOriginalData=trapz(b,2*abs(a(1:g/2))/length(e))
%AreaOriginal=trapz(d,2*abs(c(1:j-1))/length(e))
%c=[];%ʹ��ʱע�����ĳ�ʼ�����ͷ�����
%d=[];
%***********************��ͨ����**********************%
% y=filter(bz1,az1,x);
y=lowp(x,f1,f3,rp,rs,fs);%Ӧ���б�ѩ��I�����˲�f1=2.5,f3=3.0,rp=0.1,rs=2.0
%y=hamingFirlowp(x,f1,f3,fs);%Ӧ��hanning�������˲�
figure;
subplot(211);plot(t,y);%�˲���ʱ������
ylabel('��ֵ');xlabel('ʱ��');title('sway��ʱ�ߣ�afterFilter��');
%yy=y(70000:length(t));%������ָ��ʱ�俪ʼѰ�ҷ�ֵ
[pksFilter,locsFilter]=findpeaks(y,'minpeakdistance',24000,'MINPEAKHEIGHT',0.0);
hold on;
plot(locsFilter/fs,pksFilter,'rp');
[mi,MAX,c,C,d,D]=FindHalfPeak(pksFilter,t,locsFilter);%Ѱ��1/2��ֵ��1/5��ֵ
plot(locsFilter(c)/fs,pksFilter(c),'ys');%���1/2��ֵλ��
plot(locsFilter(d)/fs,pksFilter(d),'g>');%���1/5��ֵλ��
subplot(212);
[area,h]=hua_fft(y,fs);
%[pksFFTFilter,locsFFTFilter]=findpeaks(h);����
saveas(gcf,['E:\MATLAB-FFT\SC20_FL20_C1\',num2str(filename),'Filter.fig']);
AreaFilter=area;
%j=1;
 %while(b(j)<f1)
  %   c(j)=a(j);
   %  d(j)=b(j);
    % j=j+1;
%end
 %AreaFilterData=trapz(b,2*abs(a(1:g/2))/length(e))
 %AreaFilter=trapz(d,2*abs(c(1:j-1))/length(e))
% c=[];%�������
 %d=[];%�������
 for k=1:1:length(locs)
 errorPeak(k)=(y(locs(k))-pksOriginal(k))/pksOriginal(k);%���ڼ����˲�ǰ���˲����ֵ���
 end
%errorFFT=(pksFFTFilter-pksFFTOriginal)/pksFFTOriginal;
error(i)=abs(AreaOriginal-AreaFilter)/AreaOriginal%�����˲�ǰ���������
[SNR,RMSE]=snr(x,y);%�������Ⱥ;������
SNR
RMSE
%*******************************�������*********************%
s1(1).x1='MaxPeak';s1(1).x2=mi;s1(1).x3=MAX;
s1(2).x1='1/2MaxPeak';s1(2).x2=c;s1(2).x3=C;
s1(3).x1='1/5MaxPeak';s1(3).x2=d;s1(3).x3=D;
s1(4).x1='AreaOriginal';s1(4).x2=AreaOriginal;
s1(5).x1='AreaFilter';s1(5).x2=AreaFilter;
s1(6).x1='error';s1(6).x2=error;
s1(7).x1='errorPeak';s1(7).x2=errorPeak;
s1(8).x1='SNR';s1(8).x2=SNR;
s1(9).x1='RMSE';s1(9).x2=RMSE;
save(['E:\MATLAB-FFT\SC20_FL20_C1\',num2str(filename),'ImportData.mat'], 's1');
disp('�������������һ�����ݴ���')
pause
end
%�������ļ�����Ҫ�����ļ���ַ���ļ����������ļ�����Ҫ�ӡ������ַ�����﷽ʽ
else key==0
 %  Addres = input('Please input the Dir Address with the address such as :E:\MATLAB-FFT\scaling��ʱ����������ã���Сë��\SC20_wave\SC20_L20_C5_wave1\:');
   cd E:\MATLAB-FFT\SC20_FL20_C1;
   D = input('Please input the file name such as 1_3-12.mat');
load(D);
%filename=D.name;
%filename
%D(end-3:end)=[];
x=Data;
fs=20000;
t=0:0.00005:length(Data)/20000;t=t';t(length(Data)+1)=[];
[pksOriginal,locs]=findpeaks(x,'minpeakdistance',24000,'MINPEAKHEIGHT',0.0);
figure;
subplot(211);plot(t,x);
ylabel('��ֵ');xlabel('ʱ��');title('sway��ʱ��');
hold on;
plot(locs/fs,pksOriginal,'rp');
subplot(212);
[area,h,y_f]=hua_fft(x,fs);
%[pksFFTOriginal,locsFFT]=findpeaks(h);����
saveas(gcf,['E:\MATLAB-FFT\SC20_FL20_C1\',num2str(D),'original.fig']);
f1=input('Please look at the picture,make sure and input the f1= ��reference data 2.5�� ');
f3=input('f3= ��reference data 3.0�� ');
rp=input('rp= ��reference data 0.1��');
rs=input('rs= ��reference data 2.0��');
AreaOriginal=area;
%j=1;
 %while(b(j)<f1)
  %   c(j)=a(j);
   %  d(j)=b(j);
    % j=j+1;
 %end
%areasss=area(b,2*abs(a(1:g/2))/length(e))
%AreaOriginalData=trapz(b,2*abs(a(1:g/2))/length(e))
%AreaOriginal=trapz(d,2*abs(c(1:j-1))/length(e))
%c=[];
%d=[];
%��ͨ����
% y=filter(bz1,az1,x);
y=lowp(x,f1,f3,rp,rs,fs);%f1=2.5,f3=3.0,rp=0.1,rs=2.0
%y=hamingFirlowp(x,f1,f3,fs);
figure;
subplot(211);plot(t,y);
ylabel('��ֵ');xlabel('ʱ��');title('sway��ʱ�ߣ�afterFilter��');
%yy=y(70000:length(t));
[pksFilter,locsFilter]=findpeaks(y,'minpeakdistance',24000,'MINPEAKHEIGHT',0.0);
hold on;
plot(locsFilter/fs,pksFilter,'rp');
subplot(212);
[area,h]=hua_fft(y,fs);
%[pksFFTFilter,locsFFTFilter]=findpeaks(h);����
FindHalfPeak(pksFilter,t,locsFilter);%****
saveas(gcf,['E:\MATLAB-FFT\SC20_FL20_C1\',num2str(D),'Filter.fig']);
AreaFilter=area;
%j=1;
 %while(b(j)<f1)
  %   c(j)=a(j);
   %  d(j)=b(j);
    % j=j+1;
%end
 %AreaFilterData=trapz(b,2*abs(a(1:g/2))/length(e))
 %AreaFilter=trapz(d,2*abs(c(1:j-1))/length(e))
% c=[];%�������
 %d=[];%�������
 for k=1:1:length(locs)
 erroPeak(k)=(y(locs(k))-pksOriginal(k))/pksOriginal(k);
 end
%errorFFT=(pksFFTFilter-pksFFTOriginal)/pksFFTOriginal;
error=abs(AreaOriginal-AreaFilter)/AreaOriginal
[SNR,RMSE]=snr(x,y);
SNR
RMSE
%*******************************�������*********************%
s1(1).x1='MaxPeak';s1(1).x2=mi;s1(1).x3=MAX;
s1(2).x1='1/2MaxPeak';s1(2).x2=c;s1(2).x3=C;
s1(3).x1='1/5MaxPeak';s1(3).x2=d;s1(3).x3=D;
s1(4).x1='AreaOriginal';s1(4).x2=AreaOriginal;
s1(5).x1='AreaFilter';s1(5).x2=AreaFilter;
s1(6).x1='error';s1(6).x2=error;
s1(7).x1='errorPeak';s1(7).x2=errorPeak;
s1(8).x1='SNR';s1(8).x2=SNR;
s1(9).x1='RMSE';s1(9).x2=RMSE;
save(['E:\MATLAB-FFT\SC20_FL20_C1\',num2str(filename),'ImportData.mat'], 's1'); 
end