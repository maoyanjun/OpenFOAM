%作者：毛艳军
%时间：2016年7月15日
%单位：大连理工大学深海研究中心
%加窗函数的FIR滤波器长度的确定
%用窗函数方法设计FIR滤波器，它的长度是由滤波器的过渡带的宽度和选择的窗函数所决定的，因为不同的窗函数有不同的过渡带宽（见下表）。
%这里举一个选用海明窗函数设计低通滤波器的例子。
%低通滤波器的设计要求是：采样频率为100Hz，通带截至频率为3 Hz，阻带截止频率为5 Hz，通带内最大衰减不高于0.5 dB，阻带最小衰减不小于50 dB。使用海明窗函数。确定N的步骤有：
%1，从上表可查得海明窗的精确过渡带宽为6.6pi/N;（在有些书中用近似过渡带来计算，这当然没有错，但阶数增大了，相应也增加计算量。）
%    2，本低通滤波器的过渡带是：
function y=hamingFirlowp(x,f1,f3,Fs)
%DeltaW=Ws-Wp=2*pi*(f3-f1)/Fs;
%N=6.6*pi/DeltaW=6.6pi/.04pi=165
%所以滤波器的阶数至少是165。在该帖子中是用理想低通滤波器的方法来计算的，这里用fir1函数来计算，相应的程序有
%fs=100;             % 采样频率
wp=2*f1*pi/Fs; 
ws=2*f3*pi/Fs;  
deltaw= ws - wp;                % 过渡带宽Δω的计算
N = ceil(6.6*pi/deltaw) + 1;   % 按海明窗计算所需的滤波器阶数N0,ceil()取整函数，hannWindows近似带宽6.2*pi/N
wdham = (hann(N+1))';        % 汉宁窗计算或者海明窗计算hamming(N+1)
Wn=(f1+f3)/Fs;                  % 计算截止频率
b=fir1(N,Wn,wdham);
% 画频响曲线
[H,w]=freqz(b,1);
db=20*log10(abs(H));
figure;
plot(w*Fs/(2*pi),db);title('幅度响应（单位： dB）');grid
axis([0 1000 -500 10]); xlabel('频率（单位：Hz）'); ylabel('分贝')
set(gca,'XTickMode','manual','XTick',[0,3,5,50])
set(gca,'YTickMode','manual','YTick',[-50,0])
%
y=filter(b,1,x);%对序列x滤波后得到的序列y
end