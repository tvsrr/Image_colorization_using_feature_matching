function ipts=FastHessian_getIpoints(FastHessianData)

filter_map = [0,1,2,3;
    1,3,4,5;
    3,5,6,7;
    5,7,8,9;
    7,9,10,11]+1;

np=0; ipts=struct;

responseMap=FastHessian_buildResponseMap(FastHessianData);

for o = 1:FastHessianData.octaves
    for i = 1:2
        b = responseMap{filter_map(o,i)};
        m = responseMap{filter_map(o,i+1)};
        t = responseMap{filter_map(o,i+2)};
        
        [c,r]=ndgrid(0:t.width-1,0:t.height-1);
        r=r(:); c=c(:);
        
        p=find(FastHessian_isExtremum(r, c, t, m, b,FastHessianData));
        for j=1:length(p);
            ind=p(j);
            [ipts,np]=FastHessian_interpolateExtremum(r(ind), c(ind), t, m, b, ipts,np);
        end
    end
end

