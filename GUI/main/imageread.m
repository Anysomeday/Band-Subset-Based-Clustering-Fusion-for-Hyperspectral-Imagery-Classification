function [B,dim,r,c]=imageread(pathname,filename2,i,N,n,jietu)
%�˺�������һ���ļ����е����ɷ�ͼ�񣬸���ͼ�����е���ʽ�������B��
%iΪ��һ��ͼ���ļ�����NΪͼ��������nΪ�ļ���������Ŀ

B=[];
for j=1:N
    Path=[ pathname,int2str(i),filename2];
    Aa=imread(Path);
    A=imcrop(Aa,jietu);
    B=[B;A(:)'];
    i=i+n;
end 
dim=N;
[r,c]=size(A);
B=double(B);
    