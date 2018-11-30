function ipts = SurfDescriptor_DecribeInterestPoints(ipts, upright, extended, img, verbose)

if (isempty(fields(ipts))), return; end

if(verbose), h_ang=figure; drawnow, set(h_ang,'name','Angles'); else h_ang=[]; end
if(verbose), h_des=figure; drawnow, set(h_des,'name','Aligned Descriptor XY'); end
   
for i=1:length(ipts)

   if(i>40), verbose=false; end
   
   ip=ipts(i);

   if (extended), ip.descriptorLength = 128; else ip.descriptorLength = 64; end

   if(verbose), figure(h_ang), subplot(5,8,i), end
   ip.orientation=SurfDescriptor_GetOrientation(ip,img,verbose);

   if(verbose), figure(h_des), subplot(10,4,i), end
   ip.descriptor=SurfDescriptor_GetDescriptor(ip, upright, extended, img,verbose);
   
   ipts(i).orientation=ip.orientation;
   ipts(i).descriptor=ip.descriptor;
end

if(~isempty(h_ang)), figure(h_ang), colormap(jet); end