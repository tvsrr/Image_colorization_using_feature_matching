%function average_surf = superpixel_surf(Img,L)

Img = imread('C:\Users\sushena\Downloads\gabor feature extraction\rail_gray.jpg');
%Img = double(rgb2gray(Img));

if(size(Img,3) == 3)
    Img = rgb2gray(Img);
end
Img = double(Img);
[rows cols] = size(Img);

load('C:\Users\sushena\Downloads\gabor feature extraction\gray-superpix-labels.mat');

ipts = getSurf(Img);

maxclusters = max(max(L2));

ptsImg = zeros(rows,cols);
indicesImg = zeros(rows,cols);

for i = 1:length(ipts)
    ptsImg(round(ipts(i).y),round(ipts(i).x)) = 1;
    indicesImg(round(ipts(i).y),round(ipts(i).x)) = i;
end %i

L2 = L2 .* ptsImg;

average_surf_gray = zeros(maxclusters,128);

for i = 1:maxclusters
    sum_surf = zeros(1,128);
   [r c] = find(L2 == i);
   
   for j = 1:length(r)
       ind = indicesImg(r(j),c(j));
       sum_surf = sum_surf + ipts(ind).descriptor';
   end
   
   if(length(r) ~= 0)
       average_surf_gray(i,:) = sum_surf./length(r);
   end
    
end %i

%end