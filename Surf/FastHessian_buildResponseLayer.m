function rl=FastHessian_buildResponseLayer(rl,FastHessianData)

step = fix( rl.step);                      
b = fix((rl.filter - 1) / 2 + 1);         
l = fix(rl.filter / 3);                   
w = fix(rl.filter);                       

inverse_area = 1 / double(w * w);          
img=FastHessianData.img;

[ac,ar]=ndgrid(0:rl.width-1,0:rl.height-1);
ar=ar(:); ac=ac(:);

r = int32(ar * step);
c = int32(ac * step);

Dxx =   IntegralImage_BoxIntegral(r - l + 1, c - b, 2 * l - 1, w,img) - IntegralImage_BoxIntegral(r - l + 1, c - fix(l / 2), 2 * l - 1, l, img) * 3;
Dyy =   IntegralImage_BoxIntegral(r - b, c - l + 1, w, 2 * l - 1,img) - IntegralImage_BoxIntegral(r - fix(l / 2), c - l + 1, l, 2 * l - 1,img) * 3;
Dxy = + IntegralImage_BoxIntegral(r - l, c + 1, l, l,img) + IntegralImage_BoxIntegral(r + 1, c - l, l, l,img) ...
      - IntegralImage_BoxIntegral(r - l, c - l, l, l,img) - IntegralImage_BoxIntegral(r + 1, c + 1, l, l,img);

Dxx = Dxx*inverse_area;
Dyy = Dyy*inverse_area;
Dxy = Dxy*inverse_area;

rl.responses = (Dxx .* Dyy - 0.81 * Dxy .* Dxy);
rl.laplacian = (Dxx + Dyy) >= 0;
