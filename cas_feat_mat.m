tic
im=(imread('C:\Users\sushena\Downloads\gabor feature extraction\rail_gray.jpg'));
B=imread('C:\Users\sushena\Downloads\gabor feature extraction\rail_rgb.jpg');
im2=rgb2gray(B);
im_r=B(:,:,1);
im_g=B(:,:,2);
im_b=B(:,:,3);

load('C:\Users\sushena\Downloads\gabor feature extraction\rgb-superpix-labels.mat');
load('C:\Users\sushena\Downloads\gabor feature extraction\gray-superpix-labels.mat');

load('E:\course\DIP\project\gray_gabour.mat');
load('E:\course\DIP\project\rgb_gabour.mat');
load('E:\course\DIP\project\rgb_surf.mat');
load('E:\course\DIP\project\gray_surf.mat');

N=max(max(L2));
avg_int_gray=zeros(N,1);
avg_std_gray=zeros(N,1);
avg_int_neigh=zeros(N,1);
avg_std_neigh=zeros(N,1);

N2=max(max(L));
avg_int_rgb=zeros(N2,1);
avg_std_rgb=zeros(N2,1);
avg_int_neigh_rgb=zeros(N2,1);
avg_std_neigh_rgb=zeros(N2,1);
avg_int_r=zeros(N2,1);
avg_int_g=zeros(N2,1);
avg_int_b=zeros(N2,1);
L_pad=padarray(L,[5,5]);
L2_pad=padarray(L2,[5,5]);

for i=1:N
    [r,c]=find(L2==i);
    avg_int_gray(i)=uint8(mean2(im(r(1:end),c(1:end))));    
    r_mid=median(r);
    c_mid=median(c);
    window=L2_pad(r_mid:r_mid+10,c_mid:c_mid+10);
    neigh=unique(window(window>0));
    avg_int_neigh(i)=round(mean(avg_int_gray(neigh)));
    avg_std_gray(i)=(std2(im(r(1:end),c(1:end))));
    avg_std_neigh(i)=(mean(avg_std_gray(neigh)));
end

av_in_gr=zeros(N,2);
av_std_gr=zeros(N,2);
av_in_gr(1:N,1)=avg_int_gray;
av_in_gr(1:N,2)=avg_int_neigh;
av_std_gr(1:N,1)=avg_std_gray;
av_std_gr(1:N,2)=avg_std_neigh;

for i=1:N2
    [r2,c2]=find(L==i);
    avg_int_rgb(i)=uint8(mean2(im2(r2(1:end),c2(1:end))));
    r_mid=median(r2);
    c_mid=median(c2);
    window=L_pad(r_mid:r_mid+10,c_mid:c_mid+10);
    neigh=unique(window(window>0));
    avg_int_neigh_rgb(i)=round(mean(avg_int_rgb(neigh)));
    avg_int_r(i)=uint8(mean2(im_r(r2(1:end),c2(1:end))));
    avg_int_g(i)=uint8(mean2(im_g(r2(1:end),c2(1:end))));
    avg_int_b(i)=uint8(mean2(im_b(r2(1:end),c2(1:end))));
    avg_std_rgb(i)=(std2(im2(r2(1:end),c2(1:end))));
    avg_std_neigh_rgb(i)=(mean(avg_std_rgb(neigh)));
end

av_in_rgb=zeros(N2,2);
av_st_rgb=zeros(N2,2);
av_in_rgb(1:N2,1)=avg_int_rgb;
av_in_rgb(1:N2,2)=avg_int_neigh_rgb;
av_st_rgb(1:N2,1)=avg_std_rgb;
av_st_rgb(1:N2,2)=avg_std_neigh_rgb;

gray_pix=size(gabfeat_super_gray,1);
rgb_pix=size(gabfeat_super,1);
gray_surf_pix=size(gabfeat_super_gray,1);
rgb_surf_pix=size(gabfeat_super,1);

gab_dist=zeros(gray_pix,rgb_pix);
surf_dist=zeros(gray_surf_pix,rgb_surf_pix);

for i=1:gray_pix
    for j=1:rgb_pix
        gab_dist(i,j)=sum((gabfeat_super_gray(i)-gabfeat_super(j)).^2).^0.5;
    end
end

 mean_gab_dist=zeros(gray_pix,1);
 ref_mat=cell(gray_pix,1);
 for i=1:gray_pix
     mean_gab_dist(i)=mean(gab_dist(i,:));
     ref_mat{i}=find(gab_dist(i,:)<mean_gab_dist(i));
 end
 
 for i=1:gray_surf_pix
    for j=1:rgb_surf_pix
         surf_dist(i,j)=sum((average_surf_gray(i)-average_surf(j)).^2).^0.5;
    end
 end
 
 mean_surf_dist=zeros(gray_pix,1);
 corr_surf=cell(gray_surf_pix,1);
 mat_ind=cell(gray_surf_pix,1);
 ref_surf_mat=cell(gray_surf_pix,1);
 
 for i=1:gray_surf_pix
     corr_surf{i}=surf_dist(ref_mat{i}(1:end));
     mean_surf_dist(i)=mean(corr_surf{i});
     mat_ind{i}=find(corr_surf{i}<mean_surf_dist(i));
     ref_surf_mat{i}=ref_mat{i}(mat_ind{i}(1:end));
 end
 
 int_dist=zeros(N,N2);
 std_dist=zeros(N,N2);
 
 for i=1:N
     for j=1:N2
        int_dist(i,j)=sum((av_in_gr(i)-av_in_rgb (j)).^2).^0.5;
        std_dist(i,j)=sum((av_std_gr(i)-av_st_rgb (j)).^2).^0.5;
    end
 end
     
 mean_int_dist=zeros(N,1);      
 corr_int=cell(N,1);
 mat_ind_int=cell(N,1);
 ref_int_mat=cell(N,1);   
 
 for i=1:N
     corr_int{i}=int_dist(ref_surf_mat{i}(1:end));
     mean_int_dist(i)=mean(corr_int{i});
     mat_ind_int{i}=find(corr_int{i}<mean_int_dist(i));
     ref_int_mat{i}=ref_surf_mat{i}(mat_ind_int{i}(1:end));
 end
 
 mean_std_dist=zeros(N,1);
 corr_std=cell(N,1);
 mat_ind_std=cell(N,1);
 ref_std_mat=cell(N,1);
 
 for i=1:N
     corr_std{i}=std_dist(ref_int_mat{i}(1:end));
     mean_std_dist(i)=mean(corr_std{i});
     mat_ind_std{i}=find(corr_std{i}<mean_std_dist(i));
     ref_std_mat{i}=ref_int_mat{i}(mat_ind_std{i}(1:end));
 end
 
 fin_match=zeros(N,1);
 F=cell(N,1);
 min_F=zeros(N,1);
 
 for i=1:N
     F{i}=((0.2.*(gab_dist(i,ref_std_mat{i}(1:end))))+(0.5.*(surf_dist(i,ref_std_mat{i}(1:end))))+(0.2.*(int_dist(i,ref_std_mat{i}(1:end))))+(0.1.*(std_dist(i,ref_std_mat{i}(1:end)))));
     min_F(i)=min(F{i});
     fin_match(i)=ref_std_mat{i}(F{i}==min_F(i));
 end
 
 fin_sp_int=cell(N,1);
 for i=1:N
     fin_sp_int{i}(1)=avg_int_r(fin_match(i));
     fin_sp_int{i}(2)=avg_int_g(fin_match(i));
     fin_sp_int{i}(3)=avg_int_b(fin_match(i));
 end
 
 for i=1:N
    [row,col]=find(L2==i);
    im(row,col,1)=fin_sp_int{i}(1);
    im(row,col,2)=fin_sp_int{i}(2);
    im(row,col,3)=fin_sp_int{i}(3);
 end     
  
 imshow(uint8(im));
 g_name=imread('E:\course\DIP\project\rail_rgb_gray.jpg');
 fin_img=colorizeFun(g_name,im,2);
 figure,imshow(fin_img);
 toc;