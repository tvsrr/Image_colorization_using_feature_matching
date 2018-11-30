function an=FastHessian_getLaplacian(a,row, column,b)

if(nargin<4)
    scale=1;
else
    scale=fix(a.width/b.width);
end

an=a.laplacian(fix(scale*row) * a.width + fix(scale*column)+1);


