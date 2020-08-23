%Program to rename videos in ascending order starting from 1

a ='E:\Project\hmdb51_org\throw';                       %Path where the videos are stored
A =dir( fullfile(a, '*.avi') );                         %Reading videos
fileNames = { A.name };

for iFile = 1 : numel( A )
  newName = fullfile(a, sprintf( '%d.avi', iFile ) );
  movefile( fullfile(a, fileNames{ iFile }), newName );    
end

%End of code