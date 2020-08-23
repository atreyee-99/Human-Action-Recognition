	% clear;
        clc;
        fileID=fopen('E:\Project\Weizmann Files\Test\surf.csv','a');    % path for output csv file
        total=400;            % Total number of features
        
	for k=1:total
            fprintf(fileID,'att_%d,',k);         %Writing into csv file as columns
        end
        
	fprintf(fileID,'Class');                %Last Column
        fprintf(fileID,'\n');
        
	path4=('C:\Users\debjit\Desktop\Weizman Frames\Wave2\');% path for input files......
        for p=1:9                   % No of folders
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
                
                level = graythresh(A);
                BW = imbinarize(A,level);
                uint8Image = uint8(255 * BW);
                A_gray=rgb2gray(uint8Image);
                
                % Convert into Grayscale
                A_gray = rgb2gray(I);

                % Convert into double format
                A_gray = im2double(A_gray);

%                 A_gray = imcrop(A_gray,[10 15 145 95]);

                % Output the binary
                B_thresh_100 = im2bw(A_gray, 30/255);
                
%                 B_thresh_100 = imcomplement(A);
                
                %Bounding Box

                %Leftmost point
                f=1;
                for i=1:144
                    for j=1:179
                       if( (B_thresh_100(i,j)==0)&( B_thresh_100(i,j+1)==0))
                           d1(f)=j;
                           f=f+1;
                           break
                       end
                    end
                end
                p1=min(d1);

                %Rightmost point
                f=1;
                for i=1:144
                    for j=180:-1:2
                       if( (B_thresh_100(i,j)==0)&( B_thresh_100(i,j-1)==0))
                           d2(f)=j;
                           f=f+1;
                           break
                       end
                    end
                end
                p2=max(d2);

                %Topmost point
                f=1;
                for i=1:179
                    for j=1:144
                       if( (B_thresh_100(j,i)==0)&( B_thresh_100(j,i+1)==0))
                           d3(f)=j;
                           f=f+1;
                           break
                       end
                    end
                end
                p3=min(d3);

                %Bottommost point
                f=1;
                for i=2:180
                    for j=144:-1:1
                       if(( B_thresh_100(j,i)==0)&( B_thresh_100(j,i-1)==0))
                           d4(f)=j;
                           f=f+1;
                           break
                       end
                    end
                end
                p4=max(d4);

                %Cropping the image to the Bounding Box
                q = B_thresh_100(p3:p4,p1:p2);
                q=imresize(q,[120 60]);
                c=1;
                
                %Extracting Surf Features
                points = detectSURFFeatures(q1);
                strongest = selectStrongest(points,10);
                c=1;
                for i=1:10
                    for k=1:2
                        if(points.Count<i)
                             d(f,c)=0;
                        else
                             d(f,c)=strongest.Location(i,k);
                        end
                        c=c+1;
                     end
                end 
                points = detectSURFFeatures(q2);
                strongest = selectStrongest(points,10);
                for i=1:10
                    for k=1:2
                        if(points.Count<i)
                            d(f,c)=0;
                        else
                            d(f,c)=strongest.Location(i,k);
                        end
                        c=c+1;
                    end
                end
            end
            
            %Sparse Filtering
            rng default % For reproducibility
            Q = 20;
            obj = sparsefilt(d,Q,'IterationLimit',100);
            y0 = transform(obj,d(:,:));
            y0 = reshape(y0,[1 size(y0,2)*size(y0,1)]);
            for q=1:400
                fprintf(fileID,'%d,',y0(q));
            end
            %Assigning Class Names
            fprintf(fileID,'B');
            fprintf(fileID,'\n');
        end
        fclose(fileID);
