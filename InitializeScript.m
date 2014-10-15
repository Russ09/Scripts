%InitialiseScript
function ReturnImage = ClickInitialize(SourceImage,TargetImage,Transformation);


figure(1)
cla reset
dims = size(TargetImage.img);
h = patch(isosurface(permute(TargetImage.img,[2,3,1]),1000));
set(h,'EdgeColor','none','FaceColor',[1,0,0]);
alpha(h,0.1);
lighting gouraud;
axis equal
camlight;
    xlabel('xaxis');
    ylabel('yaxis');
    zlabel('zaxis');
view(0,15);
pause(0.1);


fprintf('Click on the apex of the tumour then hit return');
P1 = select3d(h);
pause


fprintf('Click on the base of the tumour then hit return');
P2 = select3d(h);
pause


figure(1)
cla reset
dims = size(SourceImage.img);
h2 = patch(isosurface(permute(SourceImage.img,[2,3,1]),100));
set(h2,'EdgeColor','none','FaceColor',[0,1,0]);
alpha(h2,0.1);
lighting gouraud;
axis equal
camlight;
    xlabel('xaxis');
    ylabel('yaxis');
    zlabel('zaxis');
view(0,15);
pause(0.1);


fprintf('Click on the apex of the tumour then hit return');
P3 = select3d(h);
pause


fprintf('Click on the base of the tumour then hit return');
P4 = select3d(h);
pause


V1 = P1 - P2;
V2 = P3 - P4;

Cross = cross(V1,V2);
Cross = Cross./norm(Cross);
angle = dot(V1,V2)/(norm(V1)*norm(V2));

Rot = [cos(angle) + Cross(1)^2*(1-cos(angle)),Cross(1)*Cross(2)*(1-cos(angle) - Cross(3)*sin(angle), Cross(11)*Cross(3)*(1-cos(angle))+Cross(2)*sin(angle);...
    Cross(2)*Cross(1)*(1-cos(angle)) + Cross(2)*sin(angle),cos(angle+ Cross(2)^2*(1-cos(angle),Cross(2)*Cross(3)*(1-cos(angle)) - Cross(1)*sin(angle);...
    Cross(3)*Cross(1)*(1- cos(angle)) - Cross(2)*sin(angle), Cross(3)*Cross(2)*(1-cos(angle))+Cross(1)*sin(angle),cos(angle)+Cross(3)^2*(1-cos(angle))];


Trans1 = [eye(3),[0;0;0];-P1,1];
Trans2 = [Rot,[0;0;0];[0,0,0,1]];
Trans3 = [eye(3),[0;0;0];P3,1];

Trans = Trans1*Trans2*Trans3;

    ReturnImage = SourceImage;
    tform = affine3d(Trans);
    A = SourceImage.img;
    R = imref3d(size(SourceImage.img));
    ReturnImage.img = imwarp(A,tform,'OutputView',R);





