function Imgres = kmeans_reassign2(Img1,Imgres,I,L2)

%clear all;
%close all;

%I = imread('railmeanshift_segm.pgm');
%I = imread('leopard2_mask1.bmp');
[rows cols] = size(I);
uniqueseg = unique(I);


%Img1 = imread('res_mask.jpg');
Img1 = imresize(Img1,[rows,cols]);
Img1lab = rgb2lab(Img1);
Img2 = Img1lab(:,:,2);
Img3 = Img1lab(:,:,3);
resImg = Img1;
reslab = RGB2Lab(resImg);

%Imgres = imread('partgray_mask.jpg');
%Imgres = imread('pre_grand_final.jpg');
%Imgres = imresize(Imgres,[size(Img1,1),size(Img1,2)],'nearest');

%load('gray-superpix-labels.mat');
Lcolor = L2;

for i = 1:length(uniqueseg)
    i
    [ind] = find(I == uniqueseg(i));
    I2 = zeros(rows,cols);
    
    I2(ind) = 1;
    I2 = I2 .* Lcolor;
    vals = unique(I2);
    vals = vals(2:end);
    if(length(vals) < 3)
        continue;
    end
    
    abarray = zeros(length(vals),2);
    
    for j = 1:length(vals)
        ind1 = find(Lcolor == vals(j));
        aarray = Img2(ind1);
        barray = Img3(ind1);
        abarray(j,1) = mean(aarray);
        abarray(j,2) = mean(barray);
    end %j
    k = 2;
    [cidx,ctrs] = kmeans(abarray,k);
    maxidx = 0;
    
    uniquecidx = unique(cidx);
    
    for j = 1:length(uniquecidx)
        nvals = find(cidx == cidx(j));
        
        if(length(nvals) > maxidx)
            maxidx = uniquecidx(j);%length(nvals);
        end
    end %j
    
    idx = find(cidx == maxidx);
    minidx = find(cidx~=maxidx);
    
    maxpixvals = 0;
    superpixid = 0;
    for j = 1:length(idx)
        nvals = find(Lcolor == idx(j));
        
        if(length(nvals) > maxpixvals)
            maxpixvals = length(nvals);
            superpixid = idx(j);
        end
    end
    
    [rind, cind] = find(Lcolor == superpixid);
    rgb = zeros(3,1);
    rgb(1) = Imgres(rind(1),cind(1),1);
    rgb(2) = Imgres(rind(1),cind(1),2);
    rgb(3) = Imgres(rind(1),cind(1),3);
    
        
    for j = 1:length(uniquecidx)
        nvals = find(cidx == cidx(j));
        
        if(length(nvals) > (0.33 * k))
            continue;
        end
        
        for k = 1:length(nvals)
            tx = nvals(k);
            ty = vals(tx);
            [rx, cx] = find(Lcolor == ty);
            
            for m = 1:length(rx)
                %reslab(rx,cx,2) = ctrs(maxidx,1);
                %reslab(rx,cx,3) = ctrs(maxidx,2);
                Imgres(rx,cx,1) = rgb(1);
                Imgres(rx,cx,2) = rgb(2);
                Imgres(rx,cx,3) = rgb(3);
            end %m
        end %k
        
    end %j
end %i

%resImg = lab2rgb(reslab);
%imshow(resImg)

figure
imshow(uint8(Imgres))
end