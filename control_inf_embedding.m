% Gabriel Melendez Melendez
% October 2017

function [blocks_array, mark, new_payload_size] = control_inf_embedding(image,blocks_array, mark, T1,T2, block_counter,lmc,final_sb)
    disp('-----------------   CONTROL INF  -----------------');
    cont = 0;
    marked_image = image;
    [block_size_n,block_size_m] = size(cell2mat(blocks_array(1)));
    row_blocks = floor(size(image,1)/block_size_n);
    col_blocks = floor(size(image,2)/block_size_m);
    
    for i2=1:row_blocks
        for j2=1:col_blocks
            cont = cont + 1;
            row_s = block_size_n*(i2-1)+1;
            row_f = block_size_n*(i2-1)+block_size_n;

            col_s = block_size_m*(j2-1)+1;
            col_f = block_size_m*(j2-1)+block_size_m;
            marked_image(row_s:row_f,col_s:col_f)= cell2mat(blocks_array(cont));
        end
    end
    marked_image = uint8(marked_image);  
    
    %   Control information metadata
    %   block_sizes     =   6  bits
    %   thresholds      =   8  bits (1-255)
    %   last block      =   16 bits
    %   scan sec size   =   16 bits
    %   las block info  =   3 bits 
    
    aux_inf = strcat(dec2bin(block_size_n,6),dec2bin(block_size_m,6),dec2bin(T1,8),dec2bin(T2,8),final_sb,dec2bin(block_counter,18),dec2bin(length(lmc),16),lmc);
    backup(1:length(aux_inf)) = '0';
    [dim1, dim2] = size(marked_image);
    cont = 0;
    for i=1:dim1
        for j=1:dim2
            if cont <  length(aux_inf)
                cont = cont + 1;
                backup(cont) = num2str(bitget(marked_image(i,j),1));
                marked_image(i,j) = bitset(marked_image(i,j),1,bin2dec(aux_inf(cont)));
            end
        end
    end
    marked_image = uint8(marked_image); 
    [blocks_array, ~, ~] = get_blocks(marked_image,block_size_n, block_size_m); 
    mark = strcat(mark,backup);
    new_payload_size = length(mark);
end

