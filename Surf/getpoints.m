%function ipts = getpoints(Img,thresh,octaves,initsample)
function ipts = getpoints(FastHessianData)

% FastHessianData.img = Img;
% FastHessianData.octaves = octaves;
% FastHessianData.init_sample = initsample;
% FastHessianData.thresh = thresh;
np=0; ipts=struct;
filter_map = [0,1,2,3;
    1,3,4,5;
    3,5,6,7;
    5,7,8,9;
    7,9,10,11]+1;

responseMap=FastHessian_buildResponseMap(FastHessianData);
responseMap{1}.responses

% responseMap = []; j = 0;
% 
% w = size(Img,2)/initsample;
% h = size(Img,1)/initsample;
% s = initsample;
% 
% if (octaves >= 1)
%     j=j+1; responseMap{j}=ResponseLayer(w,   h,   s,   9);
%     j=j+1; responseMap{j}=ResponseLayer(w, h, s, 15);
%     j=j+1; responseMap{j}=ResponseLayer(w, h, s, 21);
%     j=j+1; responseMap{j}=ResponseLayer(w, h, s, 27);
% end
% 
% if (octaves >= 2)
%     j=j+1; responseMap{j}=ResponseLayer(w / 2, h / 2, s * 2, 39);
%     j=j+1; responseMap{j}=ResponseLayer(w / 2, h / 2, s * 2, 51);
% end
% 
% if (octaves >= 3)
%     j=j+1; responseMap{j}=ResponseLayer(w / 4, h / 4, s * 4, 75);
%     j=j+1; responseMap{j}=ResponseLayer(w / 4, h / 4, s * 4, 99);
% end
% 
% if (octaves >= 4)
%     j=j+1; responseMap{j}=ResponseLayer(w / 8, h / 8, s * 8, 147);
%     j=j+1; responseMap{j}=ResponseLayer(w / 8, h / 8, s * 8, 195);
% end
% 
% if (octaves >= 5)
%     j=j+1; responseMap{j}=ResponseLayer(w / 16, h / 16, s * 16, 291);
%     j=j+1; responseMap{j}=ResponseLayer(w / 16, h / 16, s * 16, 387);
% end
% 
% for i=1:length(responseMap);
%     responseMap{i}=buildResponseLayer(responseMap{i},Img,thresh,octaves,initsample);
% end

% for o = 1:FastHessianData.octaves
%     for i = 1:2
%         b = responseMap{filter_map(o,i)};
%         m = responseMap{filter_map(o,i+1)};
%         t = responseMap{filter_map(o,i+2)};
%         
%         [c,r] = ndgrid(0,t.width - 1, t.height - 1);
%         r = r(:); c = c(:);
%         %FastHessianData.thresh = thresh;
%         p=find(FastHessian_isExtremum(r, c, t, m, b,FastHessianData));
%         %p = find(ExtremePts(r, c, t, m, b,Img,thresh,octaves,initsample));
%                
% %         for j=1:length(p);
% %             ind=p(j);
% %             [ipts,np]=Interpolate_Extemept(r(ind), c(ind), t, m, b, ipts,np);
% %         end
%     end %i
% end %o

end