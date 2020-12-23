imageLocation = [
555.5100  182.5100  181.9800  106.9800;
574.5100  194.5100  170.9800  118.9800;
567.5100  169.5100  180.9800  105.9800;
566.5100  168.5100  188.9800  107.9800;
557.5100  173.5100  191.9800  134.9800;
574.5100  175.5100  174.9800  123.9800;
567.5100  178.5100  182.9800  122.9800;
570.5100  179.5100  175.9800  134.9800;
564.5100  176.5100  182.9800  122.9800;
579.5100  177.5100  172.9800  130.9800;
579.5100  178.5100  170.9800  122.9800
563.5100  178.5100  189.9800  120.9800;
587.5100  179.5100  173.9800  119.9800;
576.5100  166.5100  181.9800  127.9800;
572.5100  173.5100  177.9800  121.980;
576.5100  178.5100  167.9800  129.9800
560.5100  169.5100  200.9800  113.9800;
569.5100  173.5100  179.9800  127.9800;
570.5100  173.5100  182.9800  119.9800;
573.5100  170.5100  181.9800  118.9800;
555.5100  182.5100  181.9800  106.9800;
574.5100  194.5100  170.9800  118.9800;
567.5100  169.5100  180.9800  105.9800;
566.5100  168.5100  188.9800  107.9800;
557.5100  173.5100  191.9800  134.9800;
574.5100  175.5100  174.9800  123.9800;
567.5100  178.5100  182.9800  122.9800;
570.5100  179.5100  175.9800  134.9800;
564.5100  176.5100  182.9800  122.9800;
579.5100  177.5100  172.9800  130.9800;
579.5100  178.5100  170.9800  122.9800
563.5100  178.5100  189.9800  120.9800;
587.5100  179.5100  173.9800  119.9800;
576.5100  166.5100  181.9800  127.9800;
572.5100  173.5100  177.9800  121.980;
576.5100  178.5100  167.9800  129.9800
560.5100  169.5100  200.9800  113.9800;
569.5100  173.5100  179.9800  127.9800;
570.5100  173.5100  182.9800  119.9800;
573.5100  170.5100  181.9800  118.9800];
 
% get Applying Mask
% videoNumber=20;
% [newMask] = GenerateApplyingMask(imageLocation,videoNumber);





for FileNumber = 18:40
    
        %set up File path for MFCC Audio Video
        if FileNumber<21
            MFCCFileName = ['/usr/local/bin/visualNewRecording/WeightCombine/MFCCs/train/',num2str(FileNumber),'.mfc'];
        else            
            MFCCFileName = ['/usr/local/bin/visualNewRecording/WeightCombine/MFCCs/test/',num2str(FileNumber),'.mfc'];
        end
        audioFileName = ['AudioFile/',num2str(FileNumber),'.wav'];
        videolFileName = ['/Users/chenzhongye/Downloads/clipmovie/movieonly/', num2str(FileNumber),'.mov'];
        disp(FileNumber);
        disp(imageLocation(FileNumber,:));
        % Read audio and pre-emphasis filtered signal
        [x, fs] = audioread(audioFileName);
        preEmphasis = [1 -0.97];                
        preEmphasisSignal = filter(preEmphasis, 1, x);
        
        %set up video and audio info or default parameter
        videoFrameRate = 30;
        audioFrameRate = 100;
        combineFrameRate = 100;
        numSampled = length(x);
        secondNumber  = fix(numSampled/fs);         %how many seconds
        numberVec = secondNumber * combineFrameRate; % how many frames 
        hammingSample = 320;

        videoNumChannel = 104;
        audioNumChannel = 30;
        combineFrameChannel = videoNumChannel + audioNumChannel;
        maskNumber = 100;
        time = 333333; %1/30=0.033   333ms =3333333 

        
        mfcfile = fopen( MFCCFileName, 'w', 'ieee-be' );       % mfcspeechFileName is .mfc file 'w' and 'ieee-be' is the writing type
            fwrite( mfcfile, numberVec, 'int32' );          % 10ms = 10000ns
            fwrite( mfcfile, 100000, 'int32' );              % 100 ns unit, 40000 sample 4ms per frame 4000us 4000000ns/100 = 40000
            fwrite( mfcfile, 4*134, 'int16' );                % the number of data per frame 30, 4 byte per data
            fwrite( mfcfile, 9, 'int16' );                  % 9 is USER 6 is MFCC more detail in HTK book                 % 9 is USER 6 is MFCC more detail in HTK book

            % Read video
            v = VideoReader(videolFileName);   % video object
            disp("Framerate: " + v.FrameRate)
            vidHeight = v.Height;
            vidWidth = v.Width;
            s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);  % data structure s with 2 variables cdata and colormap to hold the movie data
            %end of read video
            
            
            % image crop string, store all image loaction to image crop
            for second = 1: secondNumber
                videoVector = zeros(videoNumChannel,videoFrameRate);
                combineVector = zeros(videoNumChannel,combineFrameRate);
                for videoFrame = 1:videoFrameRate
                    s(videoFrame).cdata = readFrame(v);
                    img_frame = s(videoFrame).cdata;

                    % cropping the image

                    cropped_image2 =  imcrop(img_frame,imageLocation(FileNumber,:));

                    % DCT of the image
                    gray_img = im2gray(cropped_image2);
                    gray_dct_img = dct2(gray_img);
                    
                    % collect 100 data from gray image 
                    % three different mask
                    % first mask 100 vector square 10 * 10 in top left corner
                    % dct_mask_img = gray_dct_img(1:10,1:10); 
                    
                    % second triangle mask shape of mask in top left corner
                    [imageSizeX,imageSizeY] = size(gray_img);
                    [TriMask] = getTriMask(imageSizeX,imageSizeY,maskNumber);
                    dct_mask_img = TriMask.*gray_dct_img;

                    %third mask simply call applying mask
%                     if FileNumber > 20
%                         structField = FileNumber - 20;
%                     else
%                         structField = FileNumber;
%                     end
%                     my_field = strcat('v',num2str(structField));
%                     dct_mask_img = (newMask.(my_field)).*gray_dct_img;
                    
                    dct_feature = dct_mask_img(:);
                    dct_feature = nonzeros(dct_feature);

                    % normalizing the image
                    imgdouble = double(cropped_image2)/255;
                    lips_rgb_sum = sum(imgdouble, 3);
                    imgNor = imgdouble ./ lips_rgb_sum;

                    rmat = imgNor(:,:,1);
                    gmat = imgNor(:,:,2);
                    bmat = imgNor(:,:,3);

                    % change RGB level
                    levelr = 0.20;
                    levelg = 0.3;
                    levelb = 0.18;
                    imgr = imbinarize(rmat,levelr);
                    imgg = imbinarize(gmat,levelg);
                    imgb = imbinarize(bmat,levelb);

                    % filling the green image
                    Icomp = imcomplement(imgg);
                    Ifill = imfill(Icomp,'holes');

                    stats = regionprops('table',Ifill,'Centroid', 'MajorAxisLength','MinorAxisLength', 'BoundingBox');

                    major_axis_array = [stats.MajorAxisLength];
                    minor_axis_array = [stats.MinorAxisLength];
                    centroid_array = [stats.Centroid];

                    max_majorAxisLength = max(major_axis_array);
                    [sizex,sizey]=size(major_axis_array);

                    for i = 1:sizex
                        if( max_majorAxisLength == major_axis_array(i) )
                            binary_image_feature = [centroid_array(i,1), centroid_array(i,2), max_majorAxisLength, minor_axis_array(i)];
                        end
                    end

                    % two method one is not normalize one is normalize
                    %feature = normalize([dct_feature' binary_image_feature]);
                    binary_image_feature = 10 * binary_image_feature;
                    feature = [dct_feature' binary_image_feature];
                    videoVector (:,videoFrame) = feature;
                end
                
                %data interpolation to match frame rate of audio and video
                for Row = 1:videoNumChannel
                     video_y = videoVector(Row,:);
                     
%                     first way to interpolation
%                     video_x = 0:videoFrameRate - 1;
%                     query_x = 0:videoFrameRate-1/audioFrameRate-1:videoFrameRate-1;
%                     video_interp = interp1(video_x, video_y, query_x, 'spline');
                      
                    %second way to interpolation
                    visual_x = 1:videoFrameRate;
                    query_x = linspace(1, videoFrameRate, audioFrameRate);
                    video_interp = interp1(visual_x, video_y, query_x, 'spline');
                    combineVector(Row,:) = video_interp;
                end
                
                
                AudioVector = zeros(audioNumChannel,audioFrameRate);
                startPos = 1;

                for AudioFrame = 1:audioFrameRate
                    hammingSignal = preEmphasisSignal(startPos: startPos + hammingSample - 1).*hamming(hammingSample); 
                    frequencySignal = fft(hammingSignal);                                                       % fft to the hamming signal
                    shortTimeMag = abs(frequencySignal(1 : hammingSample/2));   
                    melfbank = Create_MelFrequencyFilterBank(fs ,hammingSample, audioNumChannel);                      % applying linear filterbank
                    triMelBank = melfbank * shortTimeMag;
                    logSignal = log((triMelBank));
                    dctSignal = dct(logSignal); 
                    AudioVector(:,AudioFrame) = dctSignal;
                    startPos = startPos + hammingSample/2; %overlap  
                end
                for WriteRow = 1:audioNumChannel
                    combineVector(videoNumChannel+WriteRow,:) = AudioVector(WriteRow,:); 
                end
                for WriteFrame = 1:combineFrameRate
                    for WriteCol = 1 :combineFrameChannel
                        fwrite(mfcfile, combineVector(WriteCol,WriteFrame), 'float32'); 
                    end
                end
            end

end