clc;
file = dir('E:\openfoam\0\*.txt');  %�ļ�����·��

for n = 1:length(file)
    temp = dlmread(['E:\openfoam\0\',file(n).name],' ',0, 0);  %�ļ�����·��
    writefile(n,1) = temp(501);  %��ȡ�����Ԫ�ص�writefile�б���
end
% plot(1:1:10,writefile')



    