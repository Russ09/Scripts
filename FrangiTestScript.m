


options.BlackWhite=false;
options.FrangiScaleRange=[1 6];
options.FrangiScaleRatio=1;
options.FrangiBeta=0.7;
Current=FrangiFilter3D(subImage,options);


options.FrangiScaleRange=[1,10];
options.FrangiScaleRatio = 0.2;
HighDetail=FrangiFilter3D(subImage,options);


options.FrangiScaleRange=[1 6];
options.FrangiScaleRatio=1;
options.FrangiAlpha = 50;
AlphaMod = FrangiFilter3D(subImage,options);


figure(1)
imshow3D(Current)
figure(2)
imshow3D(HighDetail)
figure(3)
imshow3D(AlphaMod)