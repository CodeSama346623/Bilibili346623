
%% 
function blocks=getblocks(S,I)

blocks = repmat(uint8(0),size(S));
for dim = [ 512 256 128 64 32 16 8 4 2 1 ] %512 256 128 64 32 16 1
    numblocks = length(find(S==dim));
    [i,j]=find(S==dim);
    if (numblocks > 0)
        if dim>1
            % …Ë÷√ÃÓ≥‰–Œ◊¥
%             valuetempt=(strel('disk',dim/2,0));
%                  valuetempt=(strel('diamond',dim/2));
                 valuetempt=(strel('square',dim/2));
            valuetempt=uint8(valuetempt.Neighborhood);
            valuetempt=imresize(valuetempt,[dim dim]);
            values = repmat(valuetempt,[1 1 numblocks]);
            for nnb=1:numblocks
                values(:,:,nnb)=valuetempt*iregion(I,i(nnb),j(nnb),dim);
            end           
        else
            values=repmat(uint8(1),[1 1 numblocks]);
            for nnb=1:numblocks
                values(nnb)=iregion(I,i(nnb),j(nnb),dim);
            end
        end
        
        blocks = qtsetblk(blocks,S,dim,values);
    end
end

end
