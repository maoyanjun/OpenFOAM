%���ߣ�ë�޾�
%ʱ�䣺2016��7��15��
%��λ����������ѧ��о�����
function sum=area(x,y)
sum=0;
for i=2:1:length(x)
    sum=sum+(x(i)-x(i-1))*((y(i)+y(i-1))/2);
end

end