%superpixalising
Img = imread('E:\course\DIP\project\rail_gray.jpg');
Img = double(rgb2gray(Img));
load('C:\Users\sushena\Downloads\gabor feature extraction\gray-superpix-labels.mat');
[rows,cols,channels]=size(Img);
gaborArray=gaborFilterBank(5,8,39,39);
featurevect=gaborFeatures(Img,gaborArray,1,1);
gaborFeature=reshape(featurevect,rows*cols,40);
maxclusters = max(max(L2));
gabfeat_super_gray=zeros(maxclusters,40);
for i=1:maxclusters
    [r,c]=find(L2==i);
    meangabor=zeros(1,40);
    for j=1:length(r)
        %gaborFeature = GaborImage(Img,scales,orientation,m,n);
        meangabor=meangabor+gaborFeature(r(j)*c(j),:);
    end %j
    meangabor=meangabor./length(r);
    gabfeat_super_gray(i,:)=meangabor;
end %i