function Y=PCA1(X,T)
%�˺���ΪPCA������ȡ�㷨
%XΪP��N�и߹���ͼ�����PΪά����NΪ����ͼ��������,TΪ����ֵ��T<1��

%Y=[];
[dim,num_data]=size(X);
mean_X=mean(X')';       %�õ�һ��X���о�ֵ��һ��������
%X1=X-mean_X*ones(1,num_data);  %X�е�ÿһ��Ԫ�ؼ�ȥ�������еľ�ֵ 
L=mean_X*ones(1,num_data);
X1=X-L;
S=X1*X1';              %�õ�PCA�����Э������
[V,D]=eig(S);    %��ȡS������ֵ
eigval=diag(D);   %����ֵ


%����T��ֵ���������貨����m
[i,j]=size(eigval);
tzhe=0;
tzhe1=0;
for ii=1:i
    tzhe=tzhe+eigval(ii);
end

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

for ii=1:i
    tzhe1=tzhe1+eigval1(ii);
    if (tzhe1/tzhe)>=T
        m=ii;
        break;
    end
end

% ��ת����Y��������ѡ�����m��
% V=V';
% Y1=V*X;       %Y1Ϊת�����ȫ����
V1=[];
for ii=1:m
    for iii=1:i
        if eigval1(ii)==eigval(iii)
            V1=[V1 V(:,iii)];
        end
        %break;
    end
end  
V1=V1';
Y=V1*X;



