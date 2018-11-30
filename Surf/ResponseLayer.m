function ResponseLayerData=ResponseLayer(width, height, step, filter)

width=floor(width);
height=floor(height);
step=floor(step);
filter=floor(filter);

ResponseLayerData.width = width;
ResponseLayerData.height = height;
ResponseLayerData.step = step;
ResponseLayerData.filter = filter;

ResponseLayerData.responses = zeros(width * height,1);
ResponseLayerData.laplacian = zeros(width * height,1);
