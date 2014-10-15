%%%%    Non-enhanced MRI preprocessing


dce = load_untouch_nii('dce.nii');
ct = load_untouch_nii('crop1.nii');

dce1 = dce;
dce2 = dce;
dce2 = dce;

dce1.img = squeeze(dce.img(:,:,:,1));
dce2.img = squeeze(dce.img(:,:,:,2));
dce3.img = squeeze(dce.img(:,:,:,3));

dce1.hdr.dime.dim([1,5]) = [3,1];
dce2.hdr.dime.dim([1,5]) = [3,1];
dce3.hdr.dime.dim([1,5]) = [3,1];

dce1.hdr.dime.pixdim([1,5]) = 0;
dce2.hdr.dime.pixdim([1,5]) = 0;
dce3.hdr.dime.pixdim([1,5]) = 0;

dce1.img = (dce1.img + dce2.img + dce3.img)/3

imshow3D(dce1.img)


CTin = SubSampleImage(ct,[8,8,8]);
DCEin = SubSampleImage(dce1,[1,1,1]);
% 
RigidReg3D(miniCTin,dce1)
% 





Transform = [-1.8950    2.2792    0.4927  -19.4368    7.9205   13.3058];

SMin = min(CTin{1}.img(:));
TMin = min(DCEin{1}.img(:));

SMax = max(CTin{1}.img(:));
TMax = max(DCEin{1}.img(:));

CTin{1}.img = (CTin{1}.img - SMin+1)*(100/(SMax-SMin));
DCEin{1}.img = (DCEin{1}.img - TMin+1)*(100/(TMax-TMin));

% Try to remove cradle
tmp = zeros(size(CTin{1}.img));
tmp(20:end-20,20:end-20,5:end-5) = CTin{1}.img(20:end-20,20:end-20,5:end-5);
CTin{1}.img = tmp;

CTin{1}.img = CTin{1}.img.*(CTin{1}.img > 50);

[PixAdjCT, PixAdjDCE] = PixelAdjust(CTin{1},DCEin{1})



SubCT = SubSampleImage(PixAdjCT,[2,2,2]);
SubDCE = SubSampleImage(PixAdjDCE,[2,2,2]);

MakeFitMovie(SubCT{1},SubDCE{1},Transform,'FitMovie5');