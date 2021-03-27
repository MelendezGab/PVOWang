% Gabriel Melendez Melendez
% October 2017

function [recovered_image, mark] = extraction(marked_image)
    [block_size_n,block_size_m,T1,T2,last_marked_block,scan_sec,mark_image,final_sb,comp_scan_sec] = control_inf_extraction(marked_image);
    
    marked_image = mark_image;
    [blocks_array, blocks_complexity, ~] = get_blocks(marked_image,block_size_n, block_size_m); 
    payload_counter=0;                       
    recovered_image= marked_image;        
    mark = '';
        
    for i = 1:length(blocks_array)
        block = cell2mat(blocks_array(i)); 
        disp(char(strcat('Block: ',{' '}, num2str(i))));
        if i < last_marked_block 
            if blocks_complexity(i) <= T2
                % Extract from 2x2 sized blocks
                [sb1,sb2,sb3,sb4] = get_subblocks(block);                    
                [rb1, mark, payload_counter] = block_extraction(sb1,mark,payload_counter);
                [rb2, mark, payload_counter] = block_extraction(sb2,mark,payload_counter);
                [rb3, mark, payload_counter] = block_extraction(sb3,mark,payload_counter);
                [rb4, mark, payload_counter] = block_extraction(sb4,mark,payload_counter);
                rec_block = cell2mat([rb1 rb2; rb3 rb4]);
                blocks_array(i) = mat2cell(rec_block,block_size_n,block_size_m);
            elseif  T2 < blocks_complexity(i)&& blocks_complexity(i) <= T1
                % Extract from 4x4 sized block
                [rec_block, mark, payload_counter] = block_extraction(block,mark,payload_counter);
                blocks_array(i) = rec_block;
            elseif T1 <= blocks_complexity(i)
                % There are no embedded bits
            end
        elseif i == last_marked_block
            if blocks_complexity(i) <= T2
                % Extraer Bloques de 2x2
                [sb1,sb2,sb3,sb4] = get_subblocks(block);
                if (strcmp(final_sb(2:3),'00'))                       
                    [rb1, mark, payload_counter] = last_block_extraction(sb1,mark,payload_counter,final_sb(1));
                    rec_block = [rb1 sb2; sb3 sb4];
                elseif (strcmp(final_sb(2:3),'01'))                        
                    [rb1, mark, payload_counter] = last_block_extraction(sb1,mark,payload_counter, '1');
                    [rb2, mark, payload_counter] = last_block_extraction(sb2,mark,payload_counter, final_sb(1));
                    rec_block = [rb1 rb2; sb3 sb4];
                elseif (strcmp(final_sb(2:3),'10'))
                    [rb1, mark, payload_counter] = last_block_extraction(sb1,mark,payload_counter, '1');
                    [rb2, mark, payload_counter] = last_block_extraction(sb2,mark,payload_counter, '1');
                    [rb3, mark, payload_counter] = last_block_extraction(sb3,mark,payload_counter, final_sb(1));
                    rec_block = [rb1 rb2; rb3 sb4];
                else
                    [rb1, mark, payload_counter] = last_block_extraction(sb1,mark,payload_counter, '1');
                    [rb2, mark, payload_counter] = last_block_extraction(sb2,mark,payload_counter, '1');
                    [rb3, mark, payload_counter] = last_block_extraction(sb3,mark,payload_counter, '1');
                    [rb4, mark, payload_counter] = last_block_extraction(sb4,mark,payload_counter, final_sb(1)); 
                    rec_block = [rb1 rb2; rb3 rb4];
                end
                blocks_array(i) = {rec_block};
            elseif  T2 < blocks_complexity(i)&& blocks_complexity(i) <= T1
                % Extract from 4x4 sized block
                [rec_block, mark, payload_counter] = last_block_extraction(block,mark,payload_counter,final_sb(1));
                blocks_array(i) = {rec_block};
            elseif T1 <= blocks_complexity(i)
                % There are no bits
            end
        else
            break;
        end
    end
    
    disp(strcat(num2str(payload_counter+65+length(comp_scan_sec)),' extracted bits.'));
    
    cont=0;
    for i=1:floor(size(marked_image,1)/block_size_n)
        for j=1:floor(size(marked_image,2)/block_size_m)
            cont = cont + 1;
            row_s = block_size_n*(i-1)+1;
            row_f = block_size_n*(i-1)+block_size_n;
            
            col_s = block_size_m*(j-1)+1;
            col_f = block_size_m*(j-1)+block_size_m;            
            
            recovered_image(row_s:row_f,col_s:col_f)= cell2mat(blocks_array(cont));
        end
    end
    
    recovered_image = uint8(recovered_image); 
    recovered_image = histogram_postprocessing(recovered_image,scan_sec);
    
end

