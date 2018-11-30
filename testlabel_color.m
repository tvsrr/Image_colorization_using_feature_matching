clear all;
close all;

Img1 = imread('leopard1.jpg');
Img2 = imread('leopard2.jpg');
Img1orig = Img1;
Img1 = rgb2gray(Img1);

if(size(Img2,3))
    Img2 = rgb2gray(Img2);
end

[rowscolor colscolor] = size(Img1);
ObjLabelcolor = zeros(rowscolor,colscolor);

[rowsgray colsgray] = size(Img2);
ObjLabelgray = zeros(rowsgray,colsgray);

Imgres = zeros(rowsgray,colsgray,3);

load('rgb-superpix-labels.mat');
load('gray-superpix-labels.mat');
load('gray_gabour.mat');
load('rgb_gabour.mat');
load('rgb_surf.mat');
load('gray_surf.mat');

load('obj_color.mat');
load('obj_gray.mat');

ObjLabelcolor = imread('leopard1_mask1.bmp');
ObjLabelcolor = double(ObjLabelcolor)./255;

ObjLabelgray = imread('leopard2_mask1.bmp');
ObjLabelgray = double(ObjLabelgray)./255;

% ObjLabelcolor(obj_color(2):obj_color(4),obj_color(1):obj_color(3)) = 1;
% 
% ObjLabelgray(obj_gray(2):obj_gray(4),obj_gray(1):obj_gray(3)) = 1;

Lcolor1 = L .* ObjLabelcolor;
Lgray1 = L2 .* ObjLabelgray;

uniqueLcolor = unique(Lcolor1);
uniqueLgray = unique(Lgray1);
uniqueLcolor = uniqueLcolor(2:end);
uniqueLgray = uniqueLgray(2:end);

N=max(max(Lgray1));
avg_int_gray=zeros(N,1);
avg_std_gray=zeros(N,1);

N2=max(max(Lcolor1));
avg_int_rgb=zeros(N2,1);
avg_std_rgb=zeros(N2,1);

for i=1:length(uniqueLgray)
    [r,c]=find(Lgray1==uniqueLgray(i));
    
    grayarray = size(length(r),1);
    
    for j = 1:length(r)
       grayarray(j) = Img2(r(j),c(j)); 
    end %j
    
    avg_int_gray(i) = mean(grayarray);
    avg_std_gray(i) = std(grayarray);
end

for i=1:length(uniqueLcolor)
    [r,c]=find(Lcolor1==uniqueLcolor(i));
    
    grayarray = size(length(r),1);
    
    for j = 1:length(r)
       grayarray(j) = Img1(r(j),c(j)); 
       
    end %j
    
    avg_int_rgb(i) = mean(grayarray);
    avg_std_rgb(i) = std(grayarray);
            
end

dist_gabor_object = zeros(length(uniqueLgray),length(uniqueLcolor));
dist_surf_object = zeros(length(uniqueLgray),length(uniqueLcolor));
dist_int_object = zeros(length(uniqueLgray),length(uniqueLcolor));
dist_std_object = zeros(length(uniqueLgray),length(uniqueLcolor));

for i = 1:length(uniqueLgray)
    t1gabor = gabfeat_super(uniqueLgray(i));
    t1surf = average_surf(uniqueLgray(i));
    
    for j = 1:length(uniqueLcolor)
        t2gabor = gabfeat_super_gray(uniqueLcolor(j));
        t2surf = average_surf_gray(uniqueLcolor(j));
        dist_gabor_object(i,j) = sum((t1gabor - t2gabor).^2).^0.5;
        dist_surf_object(i,j) = sum((t1surf - t2surf).^2).^0.5;
        dist_int_object(i,j) = sqrt((avg_int_gray(i) - avg_int_rgb(j)) * (avg_int_gray(i) - avg_int_rgb(j)));
        dist_std_object(i,j) = sqrt((avg_std_gray(i) - avg_std_rgb(j)) * (avg_std_gray(i) - avg_std_rgb(j)));
    end %j
end %i

finmatchobj = zeros(length(uniqueLgray),1);

for i = 1:length(uniqueLgray)
    mindist = 10 ^ 4;
    indval = 0;
    for j = 1:length(uniqueLcolor)
        distval = 0.2 * dist_gabor_object(i,j) + 0.5 * dist_surf_object(i,j) + 0.2 * dist_int_object(i,j) + 0.1 * dist_std_object(i,j);
        
        if(distval < mindist)
            mindist = distval;
            indval = uniqueLcolor(j);
        end
    end %j
    finmatchobj(i) = indval;
end %i

for i = 1:length(uniqueLgray)
    [r c] = find(Lcolor1 == finmatchobj(i));
    
    rgbarray = zeros(length(r),3);
    
    for j = 1:length(r)
        rgbarray(j,1) = Img1orig(r(j),c(j),1);
        rgbarray(j,2) = Img1orig(r(j),c(j),2);
        rgbarray(j,3) = Img1orig(r(j),c(j),3);
    end %j
    
    meanrgb = mean(rgbarray,1);
    
    [r c] = find(Lgray1 == uniqueLgray(i));
    
    for j = 1:length(r)
        Imgres(r(j),c(j),1) = meanrgb(1);
        Imgres(r(j),c(j),2) = meanrgb(2);
        Imgres(r(j),c(j),3) = meanrgb(3);
    end %j
end %i

ObjLabelcolor = 1 - ObjLabelcolor;
ObjLabelgray = 1 - ObjLabelgray;

Lcolor1 = L .* ObjLabelcolor;
Lgray1 = L2 .* ObjLabelgray;

uniqueLcolor = unique(Lcolor1);
uniqueLgray = unique(Lgray1);
uniqueLcolor = uniqueLcolor(2:end);
uniqueLgray = uniqueLgray(2:end);

N=max(max(Lgray1));
avg_int_gray=zeros(N,1);
avg_std_gray=zeros(N,1);

N2=max(max(Lcolor1));
avg_int_rgb=zeros(N2,1);
avg_std_rgb=zeros(N2,1);

for i=1:length(uniqueLgray)
    [r,c]=find(Lgray1==uniqueLgray(i));
    
    grayarray = size(length(r),1);
    
    for j = 1:length(r)
       grayarray(j) = Img2(r(j),c(j)); 
    end %j
    
    avg_int_gray(i) = mean(grayarray);
    avg_std_gray(i) = std(grayarray);
end

for i=1:length(uniqueLcolor)
    [r,c]=find(Lcolor1==uniqueLcolor(i));
    
    grayarray = size(length(r),1);
    
    for j = 1:length(r)
       grayarray(j) = Img1(r(j),c(j)); 
       
    end %j
    
    avg_int_rgb(i) = mean(grayarray);
    avg_std_rgb(i) = std(grayarray);
            
end

dist_gabor_object = zeros(length(uniqueLgray),length(uniqueLcolor));
dist_surf_object = zeros(length(uniqueLgray),length(uniqueLcolor));
dist_int_object = zeros(length(uniqueLgray),length(uniqueLcolor));
dist_std_object = zeros(length(uniqueLgray),length(uniqueLcolor));

for i = 1:length(uniqueLgray)
    t1gabor = gabfeat_super(uniqueLgray(i));
    t1surf = average_surf(uniqueLgray(i));
    
    for j = 1:length(uniqueLcolor)
        t2gabor = gabfeat_super_gray(uniqueLcolor(j));
        t2surf = average_surf_gray(uniqueLcolor(j));
        dist_gabor_object(i,j) = sum((t1gabor - t2gabor).^2).^0.5;
        dist_surf_object(i,j) = sum((t1surf - t2surf).^2).^0.5;
        dist_int_object(i,j) = sqrt((avg_int_gray(i) - avg_int_rgb(j)) * (avg_int_gray(i) - avg_int_rgb(j)));
        dist_std_object(i,j) = sqrt((avg_std_gray(i) - avg_std_rgb(j)) * (avg_std_gray(i) - avg_std_rgb(j)));
    end %j
end %i

finmatchobj = zeros(length(uniqueLgray),1);

for i = 1:length(uniqueLgray)
    mindist = 10 ^ 4;
    indval = 0;
    for j = 1:length(uniqueLcolor)
        distval = 0.2 * dist_gabor_object(i,j) + 0.5 * dist_surf_object(i,j) + 0.2 * dist_int_object(i,j) + 0.1 * dist_std_object(i,j);
        
        if(distval < mindist)
            mindist = distval;
            indval = uniqueLcolor(j);
        end
    end %j
    finmatchobj(i) = indval;
end %i

for i = 1:length(uniqueLgray)
    [r c] = find(Lcolor1 == finmatchobj(i));
    
    rgbarray = zeros(length(r),3);
    
    for j = 1:length(r)
        rgbarray(j,1) = Img1orig(r(j),c(j),1);
        rgbarray(j,2) = Img1orig(r(j),c(j),2);
        rgbarray(j,3) = Img1orig(r(j),c(j),3);
    end %j
    
    meanrgb = mean(rgbarray,1);
    
    [r c] = find(Lgray1 == uniqueLgray(i));
    
    for j = 1:length(r)
        Imgres(r(j),c(j),1) = meanrgb(1);
        Imgres(r(j),c(j),2) = meanrgb(2);
        Imgres(r(j),c(j),3) = meanrgb(3);
    end %j
end %i

imwrite(uint8(Imgres),'partgray.jpg');
