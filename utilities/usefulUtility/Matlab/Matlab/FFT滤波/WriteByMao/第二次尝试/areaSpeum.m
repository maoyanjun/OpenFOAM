fs=20000;
nfft= 2^nextpow2(length(y));%�ҳ�����y�ĸ���������2��ָ��ֵ���Զ��������FFT����nfft��
%nfft=1024;%��Ϊ����FFT�Ĳ���nfft
y=y-mean(y);%ȥ��ֱ������
y_ft=fft(y,nfft);%��y�źŽ���DFT���õ�Ƶ�ʵķ�ֵ�ֲ�
y_p=y_ft.*conj(y_ft)/nfft;%conj()��������y�����Ĺ������ʵ���Ĺ������������
y_f=fs*(0:nfft/2-1)/nfft;%T�任���Ӧ��Ƶ�ʵ�����
% y_p=y_ft.*conj(y_ft)/nfft;%conj()��������y�����Ĺ������ʵ���Ĺ������������
        plot(y_f,2*abs(y_ft(1:nfft/2))/length(y));%matlab�İ����ﻭFFT�ķ���
        i=1;
 while(y_f(i)<3.0)
     a(i)=y_ft(i);
     b(i)=y_f(i);
     i=i+1;
 end
        %a=2*abs(y_ft(1:nfft/2))/length(y);
        Aera=trapz(b,2*abs(a(1:i-1))/length(y));
        set(gca,'xlim',[0,20]);
        %ylabel('��ֵ');xlabel('Ƶ��');title('�źŷ�ֵ��');
        %plot(y_f,abs(y_ft(1:nfft/2)));%��̳�ϻ�FFT�ķ���