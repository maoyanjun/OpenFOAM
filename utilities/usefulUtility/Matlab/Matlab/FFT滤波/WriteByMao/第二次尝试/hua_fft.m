%���źŵķ�Ƶ�׺͹�����
%Ƶ��ʹ��matlab���ӱ�ʾ
function [a,b,e,g]=hua_fft(y,fs)
%��style=1,����ֵ�ף���style=2,��������;��style=�����ģ���ô����ֵ�׺͹�����
%��style=1ʱ�������Զ�����2����ѡ����
%��ѡ�������������������Ҫ�鿴��Ƶ�ʶε�
%��һ������Ҫ�鿴��Ƶ�ʶ����
%�ڶ�������Ҫ�鿴��Ƶ�ʶε��յ�
%����style���߱���ѡ���������������뷢��λ�ô���
nfft= 2^nextpow2(length(y));%�ҳ�����y�ĸ���������2��ָ��ֵ���Զ��������FFT����nfft��
%nfft=1024;%��Ϊ����FFT�Ĳ���nfft
y=y-mean(y);%ȥ��ֱ������
y_ft=fft(y,nfft);%��y�źŽ���DFT���õ�Ƶ�ʵķ�ֵ�ֲ�
y_p=y_ft.*conj(y_ft)/nfft;%conj()��������y�����Ĺ������ʵ���Ĺ������������
y_f=fs*(0:nfft/2-1)/nfft;%T�任���Ӧ��Ƶ�ʵ�����
% y_p=y_ft.*conj(y_ft)/nfft;%conj()��������y�����Ĺ������ʵ���Ĺ������������
a=y_ft;
b=y_f;
e=y;
g=nfft;
h=2*abs(y_ft(1:nfft/2))/length(y);
h=h.^2;
%plot(y_f,2*abs(y_ft(1:nfft/2))/length(y));%matlab�İ����ﻭFFT�ķ���
%area1=trapz(y_f,2*abs(y_ft(1:nfft/2))/length(y))
plot(y_f,h);%matlab�İ����ﻭFFT�ķ���
area=trapz(y_f,h)
set(gca,'xlim',[0,20]);
ylabel('��ֵ');xlabel('Ƶ��');title('�źŷ�ֵ��');
%plot(y_f,abs(y_ft(1:nfft/2)));%��̳�ϻ�FFT�ķ���
   
end
