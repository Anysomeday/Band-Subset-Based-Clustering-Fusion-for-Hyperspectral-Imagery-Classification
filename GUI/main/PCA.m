function Y=PCA(X,T)
%�˺���ΪPCA����ѡ���㷨
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

%������ֵ��������ѡ�������m�����ε�ͼ��
V=V';
tzxlhe=ones(dim,1);
i=1;
for ii=1:dim:dim*dim
    tzxlhe(i)=0;
    for iii=ii:(ii+dim-1)
        tzxlhe(i)=tzxlhe(i)+V(iii);
    end
    i=i+1;
end

tzxlhe1=tzxlhe;
for ii=dim:-1:2
    for iii=1:(ii-1)
        if tzxlhe1(iii)<tzxlhe1(iii+1)
            t=tzxlhe1(iii);
            tzxlhe1(iii)=tzxlhe1(iii+1);
            tzxlhe1(iii+1)=t;
        end
    end
end  

Y=[];    
for i=1:m
    for ii=1:dim
        if tzxlhe1(i)==tzxlhe(ii)
            Y=[Y;X(ii,:)];
        end
        %break;
    end
end    
