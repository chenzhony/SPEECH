function [variable] = GenerateApplyingMask(imageLocation)
    for movieFileNumber = 17:17
        filename = ['/Users/chenzhongye/Downloads/clipmovie/movie/',num2str(movieFileNumber),'.mov'];
        v = VideoReader(filename);   % video object
        vidHeight = v.Height;
        vidWidth = v.Width;
        s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);  % data structure s with 2 variables cdata and colormap to hold the movie data

        k = 1;
        while hasFrame(v)
            s(k).cdata = readFrame(v);
            img_frame = s(k).cdata;

            cropped_image =  imcrop(img_frame,imageLocation(movieFileNumber,:));
            imggray = im2gray(cropped_image);
            img_dct = dct2(imggray);

            img_dct(abs(img_dct) < 40) = 0;
            idx=img_dct==0;
            newidx = idx - 1;
            if (k==1)
                sumidx = newidx;
            else
                sumidx = sumidx + newidx;
            end
            k = k+1;
        end
        my_field = strcat('v',num2str(movieFileNumber));
        for threhold = 800:3000
            variable.(my_field) = sumidx;
            variable.(my_field)(abs(variable.(my_field)) < threhold+1) = 0;
            variable.(my_field)(abs(variable.(my_field)) > threhold) = 1;
            newout=sum(variable.(my_field)(:));
            if newout == 99
                break
            end
        end
        disp(newout);
        disp(threhold);
    end
end