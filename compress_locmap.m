% Gabriel Melendez Melendez
% October 2017

% COMPRESS_LOCMAP A location map / scan sequence is received, then, a JAVA 
% class is instanced to use arithmetic coding. 

function [compressed_lm] = compress_locmap(lm)
    global comp_in comp_out arith_coder_path;
    javaaddpath(arith_coder_path);
    ob = Compresion();
    ob.comprimir_lm(lm, comp_in, comp_out);
    
    file_ac = fopen(comp_out);
    original_bytes = fread(file_ac);

    num_bytes = size(original_bytes);
    compressed_lm = '';
    for i=1:num_bytes(1)
        inicio = 8*(i-1)+1;
        fin = inicio+7;
        compressed_lm(inicio:fin) = dec2bin(original_bytes(i,1),8);
    end
    fclose(file_ac);
end

