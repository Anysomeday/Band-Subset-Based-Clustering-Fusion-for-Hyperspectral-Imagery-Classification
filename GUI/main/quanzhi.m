function o=quanzhi(X)

[dim,num_data]=size(X);
mean_X=mean(X')';       %�õ�һ��X���о�ֵ��һ��������
%X1=X-mean_X*ones(1,num_data);  %X�е�ÿһ��Ԫ�ؼ�ȥ�������еľ�ֵ 
L=mean_X*ones(1,num_data);
X1=X-L;
S=X1*X1';              %�õ�PCA�����Э������
[V,D]=eig(S);    %��ȡS������ֵ
eigval=diag(D);

%������ֵ����
eigval1=eigval;
for ii=i:-1:2
    for iii=1:(ii-1)
        if eigval1(iii)<eigval1(iii+1)
            t=eigval1(iii);
            eigval1(iii)=eigval1(iii+1);
            eigval1(iii+1)=t;
        end
    end
end 
eigval1=mat2gray(eigval1);

for ii=1:length(eigval1)
    y=eigval1(ii+1)-eigval1(ii);
    if y>0.01
        m=ii;
        break;
    end
end

sum1=0;
for ii=1:m
    sum1=sum1+eigval1(ii);
end
sum2=0;
for ii=m+1:length(eigval1)
    sum2=sum2+eigval1(ii);
end

o=sum2/(sum1+sum2);


