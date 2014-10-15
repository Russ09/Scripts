

CTImage = load_untouch_nii('m000-20140725_C21-No_precontrast_2_v1dws1.nii');
% MRImage = load_untouch_nii('image001_MRI_AFI.nii');


CTLandmarks = load_untouch_nii('C21No_Landmarks-for-ct.nii');
MRLandmarks = load_untouch_nii('C21No_Landmarks-for-DCE-afi.nii');

CTLandmarks.img = single(CTLandmarks.img);
MRLandmarks.img = single(MRLandmarks.img);

CTLandmarks.hdr.dime.pixdim(1:4) = CTImage.hdr.dime.pixdim(1:4)*4;


MRLandmarks = TransformNewMRI(MRLandmarks,CTLandmarks);
[CTLandmarks InitLandmarks] = TransformNewCT(CTLandmarks);

pointsMR = bwconncomp(MRLandmarks.img>0);
pointsCT = bwconncomp(CTLandmarks.img>0);
pointsInit = bwconncomp(InitLandmarks.img>0);

MeanPointMR = zeros(pointsMR.NumObjects,3);
MeanPointCT = zeros(pointsMR.NumObjects,3);
MeanPointInit = zeros(pointsMR.NumObjects,3);

for iP = 1:pointsMR.NumObjects
   
    TmpPoints1 = pointsMR.PixelIdxList{iP};
    TmpPoints2 = pointsCT.PixelIdxList{iP};
    TmpPoints3 = pointsInit.PixelIdxList{iP};
    
    [SubsX,SubsY,SubsZ] = ind2sub(size(MRLandmarks.img),TmpPoints1);
    Mid = mean([SubsX,SubsY,SubsZ],1);
    MeanPointMR(iP,:) = Mid;
    
    [SubsX,SubsY,SubsZ] = ind2sub(size(CTLandmarks.img),TmpPoints2);
    Mid = mean([SubsX,SubsY,SubsZ],1);
    MeanPointCT(iP,:) = Mid;
    
    [SubsX,SubsY,SubsZ] = ind2sub(size(CTLandmarks.img),TmpPoints3);
    Mid = mean([SubsX,SubsY,SubsZ],1);
    MeanPointInit(iP,:) = Mid;
    
end

k = dsearchn(MeanPointMR,MeanPointCT);

MeanPointCT = MeanPointCT(k',:);

PDim = CTLandmarks.hdr.dime.pixdim(2:4);
PDim = repmat(PDim,[pointsMR.NumObjects,1]);

dist = sum(norm((MeanPointMR - MeanPointCT).*PDim));
initDist = sum(norm((MeanPointMR - MeanPointInit).*PDim));

Landmarks.MRPoints = MeanPointMR;
Landmarks.CTPoints = MeanPointCT;
Landmarks.InitPoints = MeanPointInit;
Landmarks.SSDFinal = dist;
Landmarks.SSDInit = initDist;

save('Landmarks.mat','Landmarks');

close
scatter3(MeanPointMR(:,1),MeanPointMR(:,2),MeanPointMR(:,3),'rx');
hold on
scatter3(MeanPointCT(:,1),MeanPointCT(:,2),MeanPointCT(:,3),'bx');
hold on
scatter3(MeanPointInit(:,1),MeanPointInit(:,2),MeanPointInit(:,3),'go');
hold off
axis equal