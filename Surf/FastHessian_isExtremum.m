function an=FastHessian_isExtremum(r, c,  t,  m,  b,FastHessianData)

layerBorder = fix((t.filter + 1) / (2 * t.step));
bound_check_fail=(r <= layerBorder | r >= t.height - layerBorder | c <= layerBorder | c >= t.width - layerBorder);

candidate = FastHessian_getResponse(m,r,c,t);
treshold_fail=candidate < FastHessianData.thresh;

an=(~bound_check_fail)&(~treshold_fail);
for rr = -1:1
    for  cc = -1:1
          %  if any response in 3x3x3 is greater then the candidate is not a maximum
          check1=FastHessian_getResponse(t,r + rr, c + cc, t) >= candidate;
          check2=FastHessian_getResponse(m,r + rr, c + cc, t) >= candidate;
          check3=FastHessian_getResponse(b,r + rr, c + cc, t) >= candidate;
          check4=(rr ~= 0 || cc ~= 0);
          an3 = ~(check1 | (check4 & check2) | check3);
          an=an&an3;
    end
end

function an=FastHessian_getResponse(a,row, column,b)
scale=fix(a.width/b.width);

index=fix(scale*row) * a.width + fix(scale*column)+1;
index(index<1)=1; index(index>length(a.responses))=length(a.responses);
an=a.responses(index);
