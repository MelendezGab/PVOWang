% Gabriel Melendez Melendez
% January 2018

%HISTOGRAM_PREPROCESSING 
% Image histogram is shrunk by modifying 0 and 255 grayscale values to 1
% and 254 respectively. A scan sequence is generated, which is compressed
% and embedded as part of control information. 

function [ mod_image, scan_secuence] = histogram_preprocessing(image)
    dims = size(image);
    mod_image = image;
    cont = 0;
    scan_secuence = '';
    mod_image(mod_image==255)=254;
    mod_image(mod_image==0)=1;

    for i=1:dims(1)
        for j=1:dims(2)
            if (mod_image(i,j)==254 || mod_image(i,j)==1)
                cont = cont + 1;
                if(mod_image(i,j) == image(i,j))
                    scan_secuence(cont)='0';
                else
                    scan_secuence(cont)='1';
                end
            end
        end
    end
end

