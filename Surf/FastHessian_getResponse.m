function an=FastHessian_getResponse(a,row, column,b)

if(nargin<4)
    scale=1;
else
    scale=fix(a.width/b.width);
end

an=a.responses(fix(scale*row) * a.width + fix(scale*column)+1);
