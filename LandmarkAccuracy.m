%   Landmark accuracy analysis.

Directory = 'C:/Project 2/Initial Data/data/Veerle-Ben-Russ_CT-DCE/'

Cases = dir(Directory);
nFiles = 0;

for iF = 3:numel(Cases)
   
    FolderName = Cases(iF).name;
    FolderPath = [Directory FolderName];
    FolderContents = dir(FolderPath);
    
    if(exist([FolderPath '/Landmarks.mat'],'file'));
        nFiles = nFiles+1;
        
        Landmarks = load([FolderPath '/Landmarks.mat']);
        Landmarks = Landmarks.Landmarks;
        nLandmarks = size(Landmarks.MRPoints,1);
        SSDFinal(nFiles) = Landmarks.SSDFinal/nLandmarks;
        SSDInit(nFiles) = Landmarks.SSDInit/nLandmarks;
        
    end
        
end

nFiles



