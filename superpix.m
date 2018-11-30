%superpixalising
function [gabfeat_super]=gabor_super(Img)
%Img = imread('E:\course\DIP\project\rail_gray.jpg');
Img = double(rgb2gray(Img));
[L,~]=superpixels(Img,10740);
[rows,cols,channels]=size(Img);
gaborArray=gaborFilterBank(5,8,39,39);
featurevect=gaborFeatures(Img,gaborArray,1,1);
gaborFeature=reshape(featurevect,rows*cols,40);
maxclusters = max(max(L));
gabfeat_super=zeros(maxclusters,40);
for i=1:maxclusters
    [r,c]=find(L==i);
    meangabor=zeros(1,40);
    for j=1:length(r)
        %gaborFeature = GaborImage(Img,scales,orientation,m,n);
        meangabor=meangabor+gaborFeature(r(j)*c(j),:);
    end %j
    meangabor=meangabor./length(r);
    gabfeat_super(i,:)=meangabor;
end %i

end