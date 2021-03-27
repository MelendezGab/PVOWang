% Gabriel Melendez Melendez
% October 2017

function [ marked_block, payload_counter, final_pee] = mark_block(block, mark, payload_counter)
    block_dims = size(block);
    array_size = block_dims(1)*block_dims(2);
    block_array = reshape(block,[1,array_size]);
    [sorted_block, sorted_index] = sort(block_array);

    u = min(sorted_index(array_size),sorted_index(array_size-1));
    v = max(sorted_index(array_size),sorted_index(array_size-1));
    dmax = block_array(u) - block_array(v);

    s = min(sorted_index(1),sorted_index(2));
    t = max(sorted_index(1),sorted_index(2));
    dmin = block_array(s) - block_array(t); 

    final_pee='0';
    if(dmax==1 || dmax==0)
        payload_counter = payload_counter + 1;
        disp(strcat('embed into dmax=',num2str(dmax)));
        sorted_block(array_size) = sorted_block(array_size)+ str2num(mark(payload_counter));
        final_pee = '0';
    else        
        disp(strcat('expand dmax=',num2str(dmax)));
        sorted_block(array_size) = sorted_block(array_size) + 1;
    end
     if payload_counter < length(mark)
        if(dmin==1 || dmin==0)            
            payload_counter = payload_counter + 1;
            disp(strcat('embed into dmin=',num2str(dmin)));
            sorted_block(1) = sorted_block(1)- str2num(mark(payload_counter));
            final_pee = '1';            
        else       
            disp(strcat('expand dmin=',num2str(dmin)));
            sorted_block(1) = sorted_block(1) - 1;  
        end
     end
     
    [~, inv_index] = sort(sorted_index); 
    unsorted_array = sorted_block(inv_index);
    marked_block = reshape(unsorted_array,[block_dims(1),block_dims(2)]);

end

