
    clc;
        fileID=fopen('E:\Project\Weizmann Files\New\glcm1.csv','a');    % path for output csv file
        total=2000;            % Total number of features

        for k=1:total
            fprintf(fileID,'att_%d,',k);        %Writing into csv file as columns
        end

        fprintf(fileID,'Class');            %Last Column
        fprintf(fileID,'\n');

        path4=('C:\Users\debjit\Desktop\Weizman Frames\Walk\');	    % path for input files......

        for p=1:9                       % No of folders
            chr = int2str(p); 
            path3=strcat(path4,chr,'\');  
            imagefiles=dir(strcat(path3,'*.png'));
            nfiles = length(imagefiles);
            cnt=0;f=0;
            a=floor(nfiles/19);
            for im=1:a:nfiles
                cnt1=0;
                f=f+1;
                currentfilename = imagefiles(im).name;
                display(strcat(path3,currentfilename));
                A=imread(strcat(path3,currentfilename));

                %Background Subtraction
                level = graythresh(A);
                BW = imbinarize(A,level);
                uint8Image = uint8(255 * BW);
                A_gray=rgb2gray(uint8Image);
                
                % Convert into Grayscale
                A_gray = rgb2gray(I);

                % Convert into double format
                A_gray = im2double(A_gray);

                % Output the binary
                B_thresh_100 = im2bw(A_gray, 30/255);
                
%                 B_thresh_100 = imcomplement(A);
                
                %Bounding Box
                
                %Leftmost point
                f1=1;
                for i=1:91
                    for j=1:145
                       if( (B_thresh_100(i,j)==0)&( B_thresh_100(i,j+1)==0))
                           d1(f1)=j;
                           f1=f1+1;
                           break
                       end
                    end
                end
                p1=min(d1);

                %Rightmost point
                f1=1;
                for i=1:91
                    for j=146:-1:2
                       if( (B_thresh_100(i,j)==0)&( B_thresh_100(i,j-1)==0))
                           d2(f1)=j;
                           f1=f1+1;
                           break
                       end
                    end
                end
                p2=max(d2);

                %Topmost point
                f1=1;
                for i=1:145
                    for j=1:91
                       if( (B_thresh_100(j,i)==0)&( B_thresh_100(j,i+1)==0))
                           d3(f1)=j;
                           f1=f1+1;
                           break
                       end
                    end
                end
                p3=min(d3);

                %Bottommost point
                f1=1;
                for i=2:146
                    for j=91:-1:1
                       if(( B_thresh_100(j,i)==0)&( B_thresh_100(j,i-1)==0))
                           d4(f1)=j;
                           f1=f1+1;
                           break
                       end
                    end
                end
                p4=max(d4);


                q = B_thresh_100(p3:p4,p1:p2);
                q=imresize(q,[120 60]);
                c=1;
                
                %GLCM Feature Extraction
                 offsets = [0 1; -1 1; -1 0; -1 -1];
                 GLCM2 = graycomatrix(q,'NumLevels',2,'Offset',offsets);
                 stats = GLCM_Features(GLCM2);
                 t1= struct2array(stats);
                 
                 %Storing GLCM Features
                 for i=1:52
                     d(f,i)=t1(1,i);
                 end
            end
            
            %Sparse Filtering
            rng default % For reproducibility
            Q = 50;
            obj = sparsefilt(d,Q,'IterationLimit',100);
            y0 = transform(obj,d(:,:));
            y0 = reshape(y0,[1 size(y0,2)*size(y0,1)]);
            for q=1:1000
                fprintf(fileID,'%d,',y0(q));
            end
            %Assigning Class name
            fprintf(fileID,'E');
            fprintf(fileID,'\n');
%         end
%     end
end
fclose(fileID);
