function [ipts,np] = Interpolate_Extremept(r, c,  t,  m,  b,  ipts, np)

D = BuildResponse(r,c,t,m,b);
H = BuildHessian(r,c,t,m,b);

Of = -H/D;
O = [Of(1,1),Of(2,1),Of(3,1)];

filterStep = fix((m.filter - b.filter));

if (abs(O(1)) < 0.5 && abs(O(2)) < 0.5 && abs(O(3)) < 0.5)
    np=np+1;
    ipts(np).x = double(((c + O(1))) * t.step);
    ipts(np).y = double(((r + O(2))) * t.step);
    ipts(np).scale = double(((2/15) * (m.filter + O(3) * filterStep)));
    ipts(np).laplacian = fix(FastHessian_getLaplacian(m,r,c,t));
end

end

function D = BuildDerivative(r,c,t,m,b)

dx = (getResponse(m,r, c + 1, t) - getResponse(m,r, c - 1, t)) / 2;
dy = (getResponse(m,r + 1, c, t) - getResponse(m,r - 1, c, t)) / 2;
ds = (getResponse(t,r, c) - getResponse(b,r, c, t)) / 2;
D = [dx;dy;ds];

end

function H = BuildHessian(r,c,t,m,b)

v = getResponse(m, r, c, t);
dxx = getResponse(m,r, c + 1, t) + getResponse(m,r, c - 1, t) - 2 * v;
dyy = getResponse(m,r + 1, c, t) + getResponse(m,r - 1, c, t) - 2 * v;
dss = getResponse(t,r, c) + getResponse(b,r, c, t) - 2 * v;
dxy = (getResponse(m,r + 1, c + 1, t) - getResponse(m,r + 1, c - 1, t) - getResponse(m,r - 1, c + 1, t) + getResponse(m,r - 1, c - 1, t)) / 4;
dxs = (getResponse(t,r, c + 1) - getResponse(t,r, c - 1) - getResponse(b,r, c + 1, t) + getResponse(b,r, c - 1, t)) / 4;
dys = (getResponse(t,r + 1, c) - getResponse(t,r - 1, c) - getResponse(b,r + 1, c, t) + getResponse(b,r - 1, c, t)) / 4;

H = zeros(3,3);
H(1, 1) = dxx;
H(1, 2) = dxy;
H(1, 3) = dxs;
H(2, 1) = dxy;
H(2, 2) = dyy;
H(2, 3) = dys;
H(3, 1) = dxs;
H(3, 2) = dys;
H(3, 3) = dss;

end