function pt = ExtremePts(r,c,t,m,b,Img,thresh,octaves,initsample)

layerBorder = fix((t.filter + 1)/(2 * t.step));
bound_check_fail = (r <= layerBorder | r >= t.height - layerBorder | c <= layerBorder | c >= t.width - layerBorder);

candidate = getResponse(m,r,c,t);
threshold_fail = candidate < thresh;

pt = (~threshold_fail) & (~bound_check_fail);

for rr = -1:1
    for  cc = -1:1
          check1=getResponse(t,r + rr, c + cc, t) >= candidate;
          check2=getResponse(m,r + rr, c + cc, t) >= candidate;
          check3=getResponse(b,r + rr, c + cc, t) >= candidate;
          check4=(rr ~= 0 || cc ~= 0);
          pt3 = ~(check1 | (check4 & check2) | check3);
          pt=pt&pt3;
    end
end

end

function an = getResponse(a,row, column,b)
scale=fix(a.width/b.width);
index=fix(scale*row) * a.width + fix(scale*column)+1;
index(index<1)=1; index(index>length(a.responses))=length(a.responses);
an=a.responses(index);
end