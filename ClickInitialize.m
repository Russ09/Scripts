%InitialiseScript
function [ReturnImage , Status ] = ClickInitialize(SourceImage,TargetImage,Status)

close all

figure(1)
cla reset
dims = size(TargetImage.img);
h = patch(isosurface(TargetImage.img,TargetImage.hdr.iso));
set(h,'EdgeColor','none','FaceColor',[1,0,0]);
alpha(h,0.8);
lighting gouraud;
axis equal
camlight;
    xlabel('xaxis');
    ylabel('yaxis');
    zlabel('zaxis');
view(0,15);
pause(0.1);

P1 = [];
P2 = [];
P3 = [];
P4 = [];
PX = [];
PY = [];

fprintf('Click on the apex of the tumour then hit return\r\n');
while(length(P1) < 3)
    pause
P1 = select3d(h);
end
hold on
scatter3(P1(1),P1(2),P1(3))



fprintf('Click on the base of the tumour then hit return\r\n');
while(length(P2) < 3)
   pause
P2 = select3d(h);
end
hold on
scatter3(P2(1),P2(2),P2(3))

fprintf('Click on the base of the tumour then hit return\r\n');
while(length(PX) < 3)
   pause
PX = select3d(h);
end
hold on
scatter3(PX(1),PX(2),PX(3))
pause
hold off

figure(1)
cla reset
dims = size(SourceImage.img);
h2 = patch(isosurface(SourceImage.img,SourceImage.hdr.iso));
set(h2,'EdgeColor','none','FaceColor',[0,1,0]);
alpha(h2,0.8);
lighting gouraud;
axis equal
camlight;
    xlabel('xaxis');
    ylabel('yaxis');
    zlabel('zaxis');
view(0,15);
pause(0.1);


fprintf('Click on the apex of the tumour then hit return\r\n');
while(length(P3) < 3)
    pause
P3 = select3d(h2);
end
hold on
scatter3(P3(1),P3(2),P3(3))
pause(0.01);


fprintf('Click on the base of the tumour then hit return\r\n');
while(length(P4) < 3)
    pause
P4 = select3d(h2);
end
hold on
scatter3(P4(1),P4(2),P4(3))


fprintf('Click on the base of the tumour then hit return\r\n');
while(length(PY) < 3)
   pause
PY = select3d(h2);
end
hold on
scatter3(PY(1),PY(2),PY(3))
hold off

V1 = P1 - P2;
V2 = P3 - P4;





Cross = cross(V1,V2);
Cross = Cross./norm(Cross);
angle = atan2(norm(cross(V1,V2)),dot(V1,V2));

Rot1 = [cos(angle) + Cross(1)^2*(1-cos(angle)),Cross(1)*Cross(2)*(1-cos(angle)) - Cross(3)*sin(angle), Cross(1)*Cross(3)*(1-cos(angle))+Cross(2)*sin(angle);...
    Cross(2)*Cross(1)*(1-cos(angle)) + Cross(3)*sin(angle),cos(angle)+ Cross(2)^2*(1-cos(angle)),Cross(2)*Cross(3)*(1-cos(angle)) - Cross(1)*sin(angle);...
    Cross(3)*Cross(1)*(1- cos(angle)) - Cross(2)*sin(angle), Cross(3)*Cross(2)*(1-cos(angle))+Cross(1)*sin(angle),cos(angle)+Cross(3)^2*(1-cos(angle))];




Trans1 = [eye(3),[0;0;0];-P3',1];
Trans2 = [Rot1,[0;0;0];[0,0,0,1]];
Trans3 = [eye(3),[0;0;0];P1',1];

TransFirst = Trans1*Trans2*Trans3;
    
    P3 = TransFirst'*[P3;1];
    P3 = P3(1:3);
    P4 = TransFirst'*[P4;1];
    P4 = P4(1:3);
    PY = TransFirst'*[PY;1];
    PY = PY(1:3);
    
    VX = P1 - PX;
    VX = VX/norm(VX);
    VY = P1 - PY;
    VY = VY/norm(VY);
    V1 = V1/norm(V1);
    
    PerpX = VX - (V1/norm(V1))*(dot(V1/norm(V1),VX));
    PerpY = VY - (V1/norm(V1))*(dot(V1/norm(V1),VY));
    
    Cross = cross(PerpX,PerpY)
    Cross = Cross./norm(Cross);
    angle = atan2(norm(cross(PerpX,PerpY)),dot(PerpX,PerpY));
    
    Rot2 = [cos(angle) + Cross(1)^2*(1-cos(angle)),Cross(1)*Cross(2)*(1-cos(angle)) - Cross(3)*sin(angle), Cross(1)*Cross(3)*(1-cos(angle))+Cross(2)*sin(angle);...
    Cross(2)*Cross(1)*(1-cos(angle)) + Cross(3)*sin(angle),cos(angle)+ Cross(2)^2*(1-cos(angle)),Cross(2)*Cross(3)*(1-cos(angle)) - Cross(1)*sin(angle);...
    Cross(3)*Cross(1)*(1- cos(angle)) - Cross(2)*sin(angle), Cross(3)*Cross(2)*(1-cos(angle))+Cross(1)*sin(angle),cos(angle)+Cross(3)^2*(1-cos(angle))];

    Trans1 = [eye(3),[0;0;0];-P1',1];
    Trans2 = [Rot2,[0;0;0];[0,0,0,1]];
    Trans3 = [eye(3),[0;0;0];P1',1];

TransSecond = Trans1*Trans2*Trans3;

Transform = TransFirst*TransSecond;

    ReturnImage = SourceImage;
    tform = affine3d(Transform);
    A = SourceImage.img;
    R = imref3d(size(SourceImage.img));
    ReturnImage.img = imwarp(A,tform,'OutputView',R);
    Status.InitialTransformation = TransFirst*TransSecond;
    Status.InitialTransformation(4,1:3) = Status.InitialTransformation(4,1:3).*SourceImage.hdr.dime.pixdim(2:4);
    
    P3 = TransSecond'*[P3;1];
    P3 = P3(1:3);
    P4 = TransSecond'*[P4;1];
    P4 = P4(1:3);
    PY = TransSecond'*[PY;1];
    PY = PY(1:3);
    
    Points1 = [P1,P2,PX];
    Points2 = [P3,P4,PY];

end 





