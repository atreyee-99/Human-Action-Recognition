% clear;
clc;
fileID=fopen('E:\Project\Weizmann Files\New\HOG1.csv','a');    % path for output csv file

total=2000;            % Total number of features

for k=1:total
    fprintf(fileID,'att_%d,',k);    %Writing into csv file as columns
end

fprintf(fileID,'Class');            %Last Column
fprintf(fileID,'\n');
path4=('C:\Users\debjit\Desktop\Weizman Frames\Walk\');     % path for input files......

for p=1:9                           % No of folders
    chr = int2str(p); 
    path3=strcat(path4,chr,'\');
    imagefiles=dir(strcat(path3,'*.png'));
    nfiles = length(imagefiles);
    cnt=0;
    f=0;
    for im=1:nfiles
        cnt1=0;
        f=f+1;
        currentfilename = imagefiles(im).name;
        display(strcat(path3,currentfilename));
        A=imread(strcat(path3,currentfilename));
        
        %Otsu Threshold for Background Subtraction
        B_thresh_100 = imcomplement(A);
                
        %Bounding Box
                
        %Leftmost point
        k=1;
        for i=1:144
            for j=1:179
                if( (B_thresh_100(i,j)==0)&( B_thresh_100(i,j+1)==0))
                     d1(k)=j;
                     k=k+1;
                     break
                end
            end
        end
        p1=min(d1);

        %Rightmost point
        k=1;
        for i=1:144
            for j=180:-1:2
                if( (B_thresh_100(i,j)==0)&( B_thresh_100(i,j-1)==0))
                     d2(k)=j;
                     k=k+1;
                     break
                end
            end
        end
        p2=max(d2);

        %Topmost point
        k=1;
        for i=1:179
            for j=1:144
                if( (B_thresh_100(j,i)==0)&( B_thresh_100(j,i+1)==0))
                     d3(k)=j;
                     k=k+1;
                     break
                end
            end
        end
        p3=min(d3);

        %Bottommost point
        k=1;
        for i=2:180
            for j=144:-1:1
                if(( B_thresh_100(j,i)==0)&( B_thresh_100(j,i-1)==0))
                     d4(k)=j;
                     k=k+1;
                     break
                end
            end
        end
        p4=max(d4);

        %Cropping the image to the bounding box
        q = B_thresh_100(p3:p4,p1:p2);
        q=imresize(q,[120 60]);

        %HOG Feature Extraction
        [featureVector,hogVisualization] = extractHOGFeatures(q,'CellSize',[16 16]);
        c=1;
        
        %Storing the features 
        for i=1:432
            d(f,i)=featureVector(1,i);
        end
    end
    
    %Sparse Filtering
    
    rng default % For reproducibility
    Q = 100;
    obj = sparsefilt(d,Q,'IterationLimit',100);
    y0 = transform(obj,d(:,:));
    y0 = reshape(y0,[1 size(y0,2)*size(y0,1)]);
    for z=1:2000
        fprintf(fileID,'%d,',y0(z));
    end
    %Assigning Class name
    fprintf(fileID,'E');
    fprintf(fileID,'\n');
end
fclose(fileID);