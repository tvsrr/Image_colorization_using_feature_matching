function orientation=SurfDescriptor_GetOrientation(ip,img,verbose)

gauss25 = [0.02350693969273 0.01849121369071 0.01239503121241 0.00708015417522 0.00344628101733 0.00142945847484 0.00050524879060;
           0.02169964028389 0.01706954162243 0.01144205592615 0.00653580605408 0.00318131834134 0.00131955648461 0.00046640341759;
           0.01706954162243 0.01342737701584 0.00900063997939 0.00514124713667 0.00250251364222 0.00103799989504 0.00036688592278;
           0.01144205592615 0.00900063997939 0.00603330940534 0.00344628101733 0.00167748505986 0.00069579213743 0.00024593098864;
           0.00653580605408 0.00514124713667 0.00344628101733 0.00196854695367 0.00095819467066 0.00039744277546 0.00014047800980;
           0.00318131834134 0.00250251364222 0.00167748505986 0.00095819467066 0.00046640341759 0.00019345616757 0.00006837798818;
           0.00131955648461 0.00103799989504 0.00069579213743 0.00039744277546 0.00019345616757 0.00008024231247 0.00002836202103];
gauss25=gauss25(:);


X = round(ip.x);
Y = round(ip.y);
S = round(ip.scale);

[j,i]=ndgrid(-6:6,-6:6);
j=j(:); i=i(:); check=(i.^2 + j.^2 < 36); j=j(check); i=i(check);

id = [ 6, 5, 4, 3, 2, 1, 0, 1, 2, 3, 4, 5, 6 ];
gauss = gauss25(id(i + 6 + 1) + id(j + 6 + 1) *7+1);

resX = gauss .* IntegralImage_HaarX(Y + j * S, X + i * S, 4 * S, img);
resY = gauss .* IntegralImage_HaarY(Y + j * S, X + i * S, 4 * S, img);
Ang =  mod(atan2(resY, resX),2*pi);

ang1 = 0:0.15:(2 * pi);
ang2 = mod(ang1+pi/3,2*pi);

cx=length(Ang); cy=length(ang1);
ang1=repmat(ang1,[cx 1]);
ang2=repmat(ang2,[cx 1]);
Ang =repmat(Ang,[1 cy]);
resX =repmat(resX,[1 cy]);
resY =repmat(resY,[1 cy]);

check1= (ang1 < ang2) & (ang1 < Ang) & (Ang < ang2);
check2= (ang2 < ang1) & ( ((Ang > 0) & (Ang < ang2)) | ((Ang > ang1) & (Ang < pi)) );
check=check1|check2;

sumX =  sum(resX.*check,1);
sumY =  sum(resY.*check,1);

R=sumX.^2+ sumY.^2;
[t,ind]=max(R);
orientation =  mod(atan2(sumY(ind), sumX(ind)),2*pi);

if(verbose)
    pica=zeros(13,13); 
    pica(i+7+(j+6)*13)=Ang(:,1);
    imshow(pica,[0 2*pi]); 
end


