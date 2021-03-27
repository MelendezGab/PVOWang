% Gabriel Melendez Melendez
% October 2017

function [marked_image] = embedding(image,blocks_array, blocks_complexity, comp_scan_sec, mark, T1, T2)
    payload_counter=0;                    
    payload_size = length(mark);
    marked_image= image;                           
    ctrl_inf_flag=0;

    for i = 1:length(blocks_array)
        if payload_counter < payload_size
            %if lm(i) == '0' 
                disp(char(strcat('Block ----> ',{' '},num2str(i))));
                block = cell2mat(blocks_array(i));     
                if blocks_complexity(i) <= T2                    
                    [sb1,sb2,sb3,sb4] = get_subblocks(block);              
                    % Embbed into 2x2 sized blocks
                    [sb1, payload_counter,final_pee]= mark_block(sb1, mark, payload_counter);
                    final_sb_control = strcat(final_pee,'00');
                    if payload_counter < payload_size
                        [sb2, payload_counter,final_pee]= mark_block(sb2, mark, payload_counter);
                        final_sb_control = strcat(final_pee,'01');
                    end
                    if payload_counter < payload_size
                        [sb3, payload_counter,final_pee]= mark_block(sb3, mark, payload_counter);
                        final_sb_control = strcat(final_pee,'10');
                    end
                    if payload_counter < payload_size
                        [sb4, payload_counter,final_pee]= mark_block(sb4, mark, payload_counter);
                        final_sb_control = strcat(final_pee,'11');
                    end                    
                    marked_block = [sb1 sb2; sb3 sb4];
                    blocks_array(i) = {marked_block};
                    
                elseif T2 < blocks_complexity(i) && blocks_complexity(i) <= T1
                    % Embbed into 4x4 sized block
                    [marked_block, payload_counter,final_pee] = mark_block(block, mark, payload_counter);
                    blocks_array(i) = {marked_block};
                    final_sb_control = strcat(final_pee,'00');
                elseif T1 <= blocks_complexity(i)
                    % Block is not marked 
                end
%--------------------------------------------------------------------------                
                % Control information embedding
                if payload_counter == payload_size && ctrl_inf_flag == 0
                    disp(strcat('Final block: ',{' '},final_sb_control));
                    [blocks_array, mark, payload_size ] = control_inf_embedding(image,blocks_array, mark, T1, T2, i, comp_scan_sec, final_sb_control);
                    ctrl_inf_flag = 1;
                end
%--------------------------------------------------------------------------
            %end;
        else
            break;
        end
    end    
    disp(strcat('Embedded bits: ',{' '},num2str(payload_counter)));
    cont = 0;                
    block_dims = size(cell2mat(blocks_array(1)));
    for i=1:floor(size(image,1)/block_dims(1))
        for j=1:floor(size(image,2)/block_dims(2))
            cont = cont + 1;
            row_s = block_dims(1)*(i-1)+1;
            row_f = block_dims(1)*(i-1)+block_dims(1);
            
            col_s = block_dims(2)*(j-1)+1;
            col_f = block_dims(2)*(j-1)+block_dims(2);
            
            marked_image(row_s:row_f,col_s:col_f)= cell2mat(blocks_array(cont));
        end
    end
    marked_image = uint8(marked_image);     
end