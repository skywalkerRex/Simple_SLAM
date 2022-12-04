function outMatrix = matrixShift(inMatrix, offSetX, offSetY)
    outMatrix = rot90(inMatrix);
    offSetX = -offSetX;
    % offSetY = -offSetY;
    outMatrix = circshift(outMatrix, offSetX);
    if(offSetX < 0)
        outMatrix(end+offSetX+1:end) = 0;
    else
        outMatrix(1:offSetX) = 0;
    end
    outMatrix = rot90(outMatrix,3);
    outMatrix = circshift(outMatrix, offSetY);
    if(offSetY < 0)
        outMatrix(end+offSetY+1:end) = 0;
    else
        outMatrix(1:offSetY) = 0;
    end
end