clc;
file = dir('E:\openfoam\1\*.txt');  %�ļ�����·��
filenames = char(file.name);
newfilename = strjust(filenames); %�ո��׼
[tempfile,order] = sortrows(newfilename);
sortfile = file(order,:);  %�ļ�������
for n = 1:length(sortfile)
    temp = dlmread(['E:\openfoam\1\',sortfile(n).name],' ',0, 0);  %�ļ�����·��
    writefile(n,1) = temp(501);  %��ȡ�����Ԫ�ص�writefile�б���
end
% plot(1:1:10,writefile')



    