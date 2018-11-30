clear all;
close all;

Img = imread('C:\Bhavani\DIP\Project\surf\rail_rgb.jpg');
Img = double(rgb2gray(Img));
[rows cols] = size(Img);

load('C:\Bhavani\DIP\Project\rgb-superpix-labels.mat');

ipts = getSurf(Img);

maxclusters = max(max(L));

ptsImg = zeros(rows,cols);
indicesImg = zeros(rows,cols);

for i = 1:length(ipts)
    ptsImg(round(ipts(i).y),round(ipts(i).x)) = 1;
    indicesImg(round(ipts(i).y),round(ipts(i).x)) = i;
end %i

L = L .* ptsImg;

average_surf = zeros(maxclusters,128);

for i = 1:maxclusters
    sum_surf = zeros(1,128);
   [r c] = find(L == i);
   
   for j = 1:length(r)
       ind = indicesImg(r(j),c(j));
       sum_surf = sum_surf + ipts(ind).descriptor';
   end
   
   if(length(r) ~= 0)
       average_surf(i,:) = sum_surf./length(r);
   end
    
end %i