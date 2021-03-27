% Gabriel Melendez Melendez
% October 2017

function [descompressed_lm] = decompress_locmap(compressed_lm)
    global comp_out comp_dec arith_coder_path;
    javaaddpath(arith_coder_path)
    ob = Compresion();
    
    compressed_lm_size = size(compressed_lm);
    bytes_number = compressed_lm_size(2)/8;
    bytes = zeros(bytes_number,1);
    
    for i=1:bytes_number
        start_b = 8*(i-1)+1;
        end_b = start_b+7;
        bytes(i,1) = bin2dec(compressed_lm(start_b:end_b));
    end
    file_ac = fopen(comp_out,'w');
    fwrite(file_ac,bytes,'uint8');
    fclose(file_ac);
    descompressed_lm = ob.descomprimir_lm(comp_out,comp_dec);
end

