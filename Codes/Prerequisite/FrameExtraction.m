
%%Extracting & Saving of frames from a Video file through Matlab Code%%

clc;
close all;
clear all;

%Prerequisite -- All the videos must be numbered from 1 in ascending
%order.Only then the videos can be read.

for i=1:102     	%Number of iterations=Number of videos in the working directory
    p=int2str(i);

    % assigning the name of sample avi file to a variable

    filename = strcat(p,'.avi');

    %reading a video file
    mov = VideoReader(filename);

    % Defining Output folder 
    opFolder = fullfile(cd, p);

    %if  not existing 
    if ~exist(opFolder, 'dir')
    %make directory & execute as indicated in opfolder variable
	    mkdir(opFolder);
    end

    %getting no of frames
    numFrames = mov.NumberOfFrames;

    %setting current status of number of frames written to zero
    numFramesWritten = 0;

    %for loop to traverse & process from frame '1' to 'last' frames 
    for t = 1 : numFrames
        currFrame = read(mov, t);    %reading individual frames
        opBaseFileName = sprintf('%3.3d.png', t);
        opFullFileName = fullfile(opFolder, opBaseFileName);
        imwrite(currFrame, opFullFileName, 'png');   %saving as 'png' file
        %indicating the current progress of the file/frame written
        progIndication = sprintf('Wrote frame %4d of %d.', t, numFrames);
        disp(progIndication);
        numFramesWritten = numFramesWritten + 1;
    end      %end of 'for' loop

    progIndication = sprintf('Wrote %d frames to folder "%s"',numFramesWritten, opFolder);
    disp(progIndication);
end
%End of the code