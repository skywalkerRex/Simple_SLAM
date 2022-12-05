function outMatrix = matrixShift(inMatrix, offSetX, offSetY)
    outMatrix = circshift(inMatrix, offSetY);
    if(offSetY < 0)
        outMatrix(end+offSetY+1:end) = 0;
    elseif(offSetY > 0)
        outMatrix(1:offSetY) = 0;
    end
    if(offSetX < 0)
        outMatrix(:,1:end+offSetX) = outMatrix(:,abs(offSetX)+1:end);
        outMatrix(:,end+offSetX+1:end) = 0;
    elseif(offSetX > 0)
        outMatrix(:,offSetX+1:end) = outMatrix(:,1:end-offSetX);
        outMatrix(:,1:offSetX) = 0;
    end
end