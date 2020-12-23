imageLocation = [555.5100  182.5100  181.9800  106.9800;
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



for video_number = 1:40
    videolFileName = ['/Users/chenzhongye/Downloads/clipmovie/movieonly/', num2str(video_number),'.mov'];
    if video_number < 21
        mfccFileName = ['/usr/local/bin/visualNewRecording/visualTriMask/MFCCs/train/', num2str(video_number),'.mfc'];
    else
        mfccFileName = ['/usr/local/bin/visualNewRecording/visualTriMask/MFCCs/test/', num2str(video_number),'.mfc'];
    end
    v = VideoReader(videolFileName);   % video object
    disp("Framerate: " + v.FrameRate)

    vidHeight = v.Height;
    vidWidth = v.Width;
    s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);  % data structure s with 2 variables cdata and colormap to hold the movie data
    
    % image crop string, store all image loaction to image crop
    
    
    %set up mfcc default parameter
    disp(imageLocation(video_number,:));
    numChannel = 104;
    numberVec = v.NumFrames;
    maskNumber = 100;
    time = 333333; %1/30=0.33   333ms =3333333 
    
    k = 1; %check frame number and iteration frame number
    mfcfile = fopen( mfccFileName, 'w', 'ieee-be' );       % mfcspeechFileName is .mfc file 'w' and 'ieee-be' is the writing type
        fwrite( mfcfile, numberVec, 'int32' );          % 10ms = 10000ns
        fwrite( mfcfile, time, 'int32' );              % 100 ns unit, 40000 sample 4ms per frame 4000us 4000000ns/100 = 40000
        fwrite( mfcfile, 4*numChannel, 'int16' );                % the number of data per frame 30, 4 byte per data
        fwrite( mfcfile, 9, 'int16' );                  % 9 is USER 6 is MFCC more detail in HTK book

        while hasFrame(v)
            s(k).cdata = readFrame(v);
            img_frame = s(k).cdata;

            % cropping the image
            
            cropped_image2 =  imcrop(img_frame,imageLocation(video_number,:));
            
            % DCT of the image
            gray_img = im2gray(cropped_image2);
            [sizexx,sizeyy] = size(gray_img);
            gray_dct_img = dct2(gray_img);
            
            % get 200 vector using will's mask
            %dct_mask_img = newsumidx4.*gray_dct_img;
            
            % get 100 vector square 10 * 10
            %dct_mask_img = gray_dct_img(1:10,1:10); 
            % 100 data from gray image
            % from binary 
            
            % get triangle shape of mask
             %[maskVector] = applyingMask(gray_dct_img,sizeyy,maskNumber);
            %dct_mask_img = maskVector.*gray_dct_img;
            
            
            %applying mask
            dct_mask_img = newMask.*gray_dct_img;

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
            
            %feature = normalize([dct_feature' binary_image_feature]);
            feature = [dct_feature' binary_image_feature];
            
            %disp(feature);
            % MFCC file head information
            %pause
            for j = 1:numChannel
                fwrite(mfcfile, feature(j), 'float32');
            end
            k = k+1;
        end
end

