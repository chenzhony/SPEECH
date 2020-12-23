%sizex1 and sizey1 is size of cropimage, maskNumber is how many DCT number
%you want to collect
function [vectormask] = getTriMask(sizex1,sizey1,maskNumber)
    vectormask = zeros(sizex1,sizey1);
    count = 1;
    lineNumber = 1;
    while maskNumber > 0
        maskNumber = maskNumber - count;
        count = count + 1;
    end
    moreNumber = count -1 + maskNumber;
    count = count-2;
    while count > 0
        moreNumber = moreNumber - 1;
        if moreNumber >= 0
            reminder = 1;
        else
            reminder = 0;
        end
        for i = 1: count + reminder
            vectormask(lineNumber,i) = 1;
        end
        count = count - 1;
        lineNumber = lineNumber+1;
        
    end 
end
