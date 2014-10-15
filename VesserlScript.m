folder = 'C:/FinishedData/GoodData/M03/'
sf = '/';
directory = dir(folder);
nFiles = 0;

for iD = 3:numel(directory)
   
    newfolder = [folder sf directory(iD).name sf 'CT-postcontrast/VesselAnalysis/'];
    
    if(~exist([newfolder 'Vessels.mat'],'file'))
       InputImage = load_untouch_nii([newfolder 'frangifilteredthresh.nii']); 
       nFiles = nFiles + 1
       Vessels = VesselAnalysis3D(InputImage);
       AllVessels{nFiles} = Vessels;
       save([newfolder 'Vessels.mat'],'Vessels');
    end
    
end

folder = 'C:/FinishedData/GoodData/M01/'
sf = '/';
directory = dir(folder);

for iD = 3:numel(directory)
   
    newfolder = [folder sf directory(iD).name sf 'CT-postcontrast/VesselAnalysis/'];
    
    if(~exist([newfolder 'Vessels.mat'],'file'))
       InputImage = load_untouch_nii([newfolder 'frangifilteredthresh.nii']); 
       nFiles = nFiles + 1;
       Vessels = VesselAnalysis3D(InputImage);
       AllVessels{nFiles} = Vessels;
       save([newfolder 'Vessels.mat'],'Vessels');
    end
    
end