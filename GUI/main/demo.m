function [xiangguanxing,fenzujieguo,jieguo,zu,total]=demo(pathname,filename1,filename2)


first=filename1;%��ʼͼ��λ��
buchang=1;%����
total=205;%��ȡͼ������
jietu=[1,1,100,100];%��ȡͼ���С
T=0.02;%������ֵ

[XX,dim,Xr,Xc]=imageread(pathname,filename2,first,total,buchang,jietu);%��ȡ����ͼ��
save va,XX;
clear XX;
[zu,xiangguanxing]=Grouping(T); %������ͼ����з���
%zu=[36 70 46 8 7 54];

%%%%%%%�ֱ�Ը���ͼ����д���
qz=[];
Gailv=[];
fenzujieguo=zeros(Xr,Xc,length(zu));
for i=1:length(zu)
    num=zu(i);
    [X,dim,r,c]=imageread(pathname,filename2,first,num,buchang,jietu);%��ȡÿ��ͼ
    
    oo=quanzhi(X);%��ȡ����ͼ��Ľ����Ȩֵ
    qz=[qz,oo];
    
    [gailv,fenzujieguoi]=Segmentdemo(X,r,c);%��ȡ����ͼ��ĸ����ض�Ӧ�ڸ���ĸ���
    fenzujieguo(:,:,i)=fenzujieguoi;
    if size(gailv,1)<size(Gailv,1)&i>1%ͳһ�����Ŀ
        gailv=[gailv;zeros(size(Gailv,1)-size(gailv,1),size(gailv,2))];
    elseif size(gailv,1)>size(Gailv,1)&i>1
        Gailv=[Gailv;zeros(size(gailv,1)-size(Gailv,1),size(Gailv,2),size(Gailv,3))];
    end
    Gailv(:,:,i)=gailv;
    
    first=first+num*buchang;
end
qz=qz/sum(qz)

%%%%%%�ںϷ�����
result=zeros(size(Gailv,1),size(Gailv,2));
for i=1:size(Gailv,2)
    for j=1:size(Gailv,1)
        xiangsu=Gailv(j,i,:);%��ȡ�������صĸ���ֵ
        xiangsu=xiangsu(:)';
        jifen1=[];
        for ii=1:length(xiangsu)
            xs=xiangsu(ii);ys=qz(ii);
            for jj=1:length(xiangsu)
                if xiangsu(jj)>xiangsu(ii)&jj~=ii
                    ys=ys+qz(jj);
                end               
            end
            jifen1=[jifen1,min(xs,ys)];
        end
        jifen=max(jifen1);
        result(j,i)=jifen(1,1);
    end
end


%%%%%%%%��ʾ�ָ���
[a,b]=max(result);
b=reshape(b,Xr,Xc);
%ba=quzao(b);
jieguo=mat2gray(b);
%figure,imshow(jieguo),  colormap('default')


