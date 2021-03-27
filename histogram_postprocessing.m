% Gabriel Melendez Melendez
% January 2018

%HISTOGRAM_POSTPROCESSING Scan sequence obtained in histogram preprocessing
%is used to recover original 0 and 255 grayscale values. 

function [ image ] = histogram_postprocessing( image, scan_secuence )
    dims = size(image);
    cont = 0;
    for i=1:dims(1)
        for j=1:dims(2)
            if image(i,j) == 254 || image(i,j) == 1
                cont = cont + 1;
                if scan_secuence(cont) == '1'
                    if image(i,j) == 254
                        image(i,j) = 255;
                    else
                        image(i,j) = 0;
                    end
                end
            end
        end
    end
end

