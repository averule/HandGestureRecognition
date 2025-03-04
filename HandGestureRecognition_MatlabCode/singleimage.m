clc;
clear all;
close all;
TrainDatabasePath = 'E:\RSCOE\BE (E&TC)\project BE\Hand Gesture Recognition 3D\train1';
TestDatabasePath = 'E:\RSCOE\BE (E&TC)\project BE\Hand Gesture Recognition 3D\test1';
TestImage = strcat(TestDatabasePath,'\','1','.mpo');
im1 = imread(TestImage);
im = imresize(im1,0.01);
TrainFiles = dir(TrainDatabasePath);
%Train_Number = 0;
%T = [];
%for i = 1 : 20
    str = int2str(1);    
    str = strcat('\',str,'.mpo');
    str = strcat(TrainDatabasePath,str);
    im2 = imread(str);
    im3 = imresize(im2,0.01);
    img = rgb2gray(im3);                                                    %Gives the matrix form of the image
    %imshow(img);
    [irow icol] = size(img);                                                %Gives the size of the image matrix
    temp = reshape(img',irow*icol,1);                                       %Converts the inverse matrix of image into a single column matrix
    T = temp;                   
%end
m = mean(T,2);                                                              %returns a column containing mean value of each row 
%Train_Number = size(T,2);
%[r c] = size(T);
%A = zeros(r,c);  
%for i = 1 : Train_Number                                                    %to convert to double precision value (64-bit) so as to cover large numbers and find differences with mean values 
    temp = double(T(:,1))-m ; 
    A = [temp]; 
%end
L = A'*A;
[V D] = eig(L);                                                             %Eigen matrix : for detailed comparisons
L_eig_vec = zeros(L);  
%for i = 1 : size(V,2) 
    if( D(1,1)>1 )   
        L_eig_vec = [L_eig_vec V(:,1)];                                     %Separating positive(>0) Eigen values from the Eigen Matrix(removing black color)
    end
%end
L_eig_vec = [0];
%disp(L_eig_vec);
Eigenfaces = A * L_eig_vec;                                                 %Converts all the extracted eigen values to a double precision column matrix
%ProjectedImages = zeros(size(Eigenfaces));
ProjectedImages = [];
Train_Number = size(Eigenfaces,2);
for i = 1 : Train_Number
    temp = Eigenfaces'*A(:,i);               
    ProjectedImages = [ProjectedImages temp];                               %Creates projection from previous data 
end
InputImage = imread(TestImage);                                                    %Read input test image
InputImage = imresize(InputImage,0.01);
temp = rgb2gray(InputImage);                                                %Gray scale image formed
[irow icol] = size(temp);
InImage = reshape(temp',irow*icol,1);                                       
Difference = double(InImage)-m;                                             %Double precision (64 bit)
ProjectedTestImage = Eigenfaces'*Difference; 

Euc_dist = zeros(size(ProjectedImages));
for i = 1 : Train_Number                                                    %Calculates Euclidean distance(checks diff between projected and trained image)
    q = ProjectedImages(:,i);
    temp = ( norm( ProjectedTestImage - q ) )^2;
    Euc_dist = [Euc_dist temp];
end
[Euc_dist_min , Recognized_index] = min(Euc_dist);                          %Minimum Euclidean Distance
OutputName = strcat(int2str(Recognized_index),'.mpo');                      %Create path for recognized image
SelectedImage = strcat(TrainDatabasePath,'\',OutputName);
SelectedImage = imread(SelectedImage);
%imshow(im);
%title('Test Image');
figure();
imshow(SelectedImage);
title('Equivalent Image');
%str = strcat('Matched image is : ',output);
%disp(str);
op = strcat(int2str(Recognized_index),'');
temp=strcat('The identified gesture enclosed in the image is : ',op);
disp(temp);