%������ӻ����������Լ�д��ר�Ż�Ƶ��ͼ�ĺ�����Ҳ��������Ȼ�ò����ҵĽ��
fs=2000;
t=(1:fs)/fs;
ff1=100;
ff2=400;
x=sin(2*pi*ff1*t)+sin(2*pi*ff2*t);
figure;
subplot(211);plot(t,x);
subplot(212);hua_fft(x,fs,1);
%��ͨ����
% y=filter(bz1,az1,x);
y=lowp(x,300,350,0.1,20,fs);
figure;
subplot(211);plot(t,y);
subplot(212);hua_fft(y,fs,1);