%�˺���Ϊ�߹���ͼ��ָ�
function [U_new, Modes,New_image] = ...
   Color_segment_svd_Msp (Input_image, Wind, Min_group_size)
% Now first tries to find "the most valuable components" of the image by
% using svd decomposition, which gives 3 matrices - U, having the same number
% of rows as the original vector, and 2 matrices - diagonal which indicates
% weights of the columns, and V which is disregarded at the moment.  Then the
% original meanshift algorithm is applied to either first or two first columns
% of U, both done sufficiently quickly and more or less reliably

% Min_group_size : need at least that many pixels to qualify for a color
Rows = size(Input_image, 1);
Cols = size(Input_image, 2);
Height = size(Input_image,3);
Min_image_size = 0.005*Rows*Cols;		                            % to stop when image is small��ֹ����

Temp_Input_image = shiftdim(Input_image, 2);               %��ͼ�����������ת��   %�����е�i���е�Ԫ�ظ�ֵ����i�����棬����ʵ��ת��%
Input_vect = reshape(Temp_Input_image, [Height, Rows*Cols]); %��ͼ����������ֱ     %����Temp�������䣬�Ѹ���������е�i�кϲ���һ��%
%��������ʵ�������ù���ֻ�ǽ�YY�����ֱ�ص�Y����ʽ����input_vectΪdim*N����height*(rows*cols)�ľ��� 


[U, S, V] = svd(double(Input_vect'), 0);                           
%��ת�����ͼ���ת�ý�������ֵ�ֽ�,u(N*N),s(P*P),v(P*P)


% now segmenting based on the first and second columns of U only 
%�������ڵ�һ���ڶ�������������������
U_col = U(:, 1:2);
%�Եڶ�������������������
U_col(:, 2) = U_col(:, 2)*S(2, 2)/S(1, 1);		% scaling it
Max = max(max(U_col));
Min = min(min(U_col));
Max_axis = 255;
%�Ե�һ���ڶ�����������
U_new = round((U_col-Min*ones(size(U_col)))/(Max-Min)*Max_axis)';%��U_new(2*N)��ֵ�任Ϊ0-255��
%%%%%��ʾ�����ֽ�ͼ
% U=U_new(1,:);
% U=reshape(U,512,614);
% U=mat2gray(U);
% figure,imshow(U)

% creating a new matrix - color based
%����һ��Max_axis+1��Max_axis+1�е�ϡ���¾���Cumulative
Cumulative = sparse(Max_axis+1, Max_axis+1);
for i=1:size(U_new, 2)
	Cumulative(U_new(1, i)+1, U_new(2, i)+1) = Cumulative(U_new(1, i)+1, U_new(2, i)+1) + 1;  
%ͳ�ƻҶ�ֵ����Ŀ cumulative(i,j)��ʾU_new�ĵ�1���еĻҶ�ֵΪi-1�͵ڶ����еĻҶ�ֵΪj-1�ĸ�����
%���cumulative(i,j)��ֵ���ܺ�ΪN
end

% for background detection only
%���б������
Cumulative(1, 1) = 0;

%wk%��ʾ�Ҷȶ�Ӧ�ĸ����ܶ�
 Cumulative1=zeros(256,256);
 size(Cumulative1);
for o=1:256
    for oo=1:256
        if Cumulative(o,oo)==0
           Cumulative1(o,oo)=0;
        else   
           Cumulative1(o,oo)=round(log2(Cumulative(o,oo)));
        end
    end
end
%  figure
%  mesh(Cumulative1)

%ģ̬ѡ��
k = 0; 
L = Max_axis+1;  
Max_iterats = 1000;

while sum(sum(Cumulative)) > Min_image_size
   Non_zero_pos = find(Cumulative > 0);
   %Non_zero_posΪ����������ֵΪCumulative(:)>0��λ�ú�
   if length(Non_zero_pos) == 0
      break;
   end
   
   [Init(1), Init(2)] = ind2sub(size(Cumulative), Non_zero_pos(1));
   %�˾仹ԭcumulative�����е�һ����0Ԫ�ص�λ�õ�����
   
   [Mode, Number_values] = M_shift2(Cumulative, Wind, Init, Min_group_size/5);
   Mode = full(round(Mode));
   if Number_values > Min_group_size	% good group
		k = k+1;
      Modes(:, k) = Mode';
		Cumulative( max(1, Mode(1)-Wind):min(L, Mode(1)+Wind), max(1, Mode(2)-Wind):min(L, Mode(2)+Wind)) = ...
         zeros(size(Cumulative(max(1, Mode(1)-Wind):min(L, Mode(1)+Wind),max(1, Mode(2)-Wind):min(L, Mode(2)+Wind))));
   else
		Cumulative(...
         max(1, Mode(1)-Wind):min(L, Mode(1)+Wind), ...
         max(1, Mode(2)-Wind):min(L, Mode(2)+Wind)) = ...
         zeros(size(Cumulative(...
         max(1, Mode(1)-Wind):min(L, Mode(1)+Wind), ...
         max(1, Mode(2)-Wind):min(L, Mode(2)+Wind))));
   end
	Max_iterats = Max_iterats-1;
	if Max_iterats < 0
		break;
	end
end

%�ع��ָ���ͼ(��������һģ̬��ֵ1���ڶ�ģ̬��ֵ2��...��    [ԭͼ�е�һ����Ϊ0����Ȼ��ֵ0])
Ones = ones(1, size(Input_vect, 2));
New_image = zeros(1, size(Input_vect, 2));
for i=1:size(Modes, 2)
   Center = Modes(:, i) * Ones;
   Norms = max(abs(Center - U_new));%��
   To_take = find(Norms <= Wind);
   New_image(To_take) = i;
end
% detecting background
To_zero = find(Input_vect(1, :) == 0);
New_image(To_zero) = 0;
New_image = reshape(New_image, [size(Input_image, 1), size(Input_image, 2)]);
