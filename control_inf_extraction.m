% Gabriel Melendez Melendez
% October 2017

function [block_size_n, block_size_m, T1, T2, last_block,scan_sec,recovered_image,final_sb_control,comp_scan_sec] = control_inf_extraction( marked_image )
    im_dims = size(marked_image);
    scan_sec_length_bits ='';
    cont=0;
    for i = 50:65
        cont = cont + 1;
        scan_sec_length_bits(cont) = num2str(bitget(marked_image(1,i),1)); 
    end
    scan_sec_size = bin2dec(scan_sec_length_bits);
    aux_inf = '';
    cont = 0;
    lsb_backup_size = 65 + scan_sec_size; 
    
    for i=1:im_dims(1)
        for j=1:im_dims(2)
            cont = cont + 1;
            if cont <= lsb_backup_size
            aux_inf(cont)=num2str(bitget(marked_image(i,j),1));
            else 
                break;
            end
        end
        if cont > lsb_backup_size
            break;
        end
    end
 
    block_size_n = bin2dec(aux_inf(1:6));
    block_size_m = bin2dec(aux_inf(7:12));
    T1 = bin2dec(aux_inf(13:20));
    T2 = bin2dec(aux_inf(21:28));
    final_sb_control = aux_inf(29:31);
    last_block = bin2dec(aux_inf(32:49));   
    comp_scan_sec = aux_inf(66:length(aux_inf));
    
    lm_java_lang_string = decompress_locmap(comp_scan_sec);
    scan_sec = lm_java_lang_string.toCharArray();
    
    [blocks_array, blocks_complexity, ~] = get_blocks(marked_image,block_size_n,block_size_m); 
    payload_counter=0;                     
    recovered_image = marked_image;          
    mark = '';

    for i = last_block+1:length(blocks_array)
            disp(char(strcat('Block: ',{' '}, num2str(i))));
            if payload_counter < lsb_backup_size
                block = cell2mat(blocks_array(i));               
                if blocks_complexity(i) <= T2
                % Extract from 2x2 sized blocks
                [sb1,sb2,sb3,sb4] = get_subblocks(block);                                        
                [rb1, mark, payload_counter] = ctrl_inf_block_extraction(sb1,mark,payload_counter,lsb_backup_size);
                [rb2, mark, payload_counter] = ctrl_inf_block_extraction(sb2,mark,payload_counter,lsb_backup_size);                  
                [rb3, mark, payload_counter] = ctrl_inf_block_extraction(sb3,mark,payload_counter,lsb_backup_size);
                [rb4, mark, payload_counter] = ctrl_inf_block_extraction(sb4,mark,payload_counter,lsb_backup_size);
                rec_block = [rb1,rb2;rb3,rb4];
                blocks_array(i) = {rec_block};
                elseif  T2 < blocks_complexity(i) && blocks_complexity(i) <= T1
                % Extract from 4x4 sized block
                [rec_block, mark, payload_counter] = ctrl_inf_block_extraction(block,mark,payload_counter,lsb_backup_size);
                blocks_array(i) = {rec_block};
                elseif T1 <= blocks_complexity(i)
                % There are no embedded bits
                end
            else
                break;
            end
    end
    cont=0;
    for i=1:floor(im_dims(1)/block_size_n)
        for j=1:floor(im_dims(2)/block_size_m)
            cont = cont + 1;
            row_s = block_size_n*(i-1)+1;
            row_f = block_size_n*(i-1)+block_size_n;
            
            col_s = block_size_m*(j-1)+1;
            col_f = block_size_m*(j-1)+block_size_m;
            
            recovered_image(row_s:row_f,col_s:col_f)= cell2mat(blocks_array(cont));
        end
    end
    
    recovered_image = uint8(recovered_image); 
    
    cont = 0;   
    for i=1:im_dims(1)
        for j=1:im_dims(2)
            cont = cont + 1;
            if cont <= lsb_backup_size
            recovered_image(i,j)=bitset(recovered_image(i,j),1,+bin2dec(mark(cont)));
            else 
                break;
            end
        end
        if cont > lsb_backup_size
            break;
        end
    end
end

