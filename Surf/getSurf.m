function [ipts] =  getSurf(Img)

thresh = 0.0002;
octaves = 5;
initsample = 2;

%Img = imread('C:\Bhavani\DIP\Project\OpenSURF_version1c\TestImages\test.png');
%Img = double(rgb2gray(Img));

Integralimage = Integral_Image(Img);

FastHessianData.img = Integralimage;
FastHessianData.octaves = octaves;
FastHessianData.init_sample = initsample;
FastHessianData.thresh = thresh;

ipts = FastHessian_getIpoints(FastHessianData);

if(~isempty(ipts))
    ipts = SurfDescriptor_DecribeInterestPoints(ipts,false, true, Integralimage, false);
end

end