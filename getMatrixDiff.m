function diff = getMatrixDiff(aMatrix, bMatrix, offSetX, offSetY)
    shiftMatrix = matrixShift(aMatrix, offSetX, offSetY);
    diffMatrix = shiftMatrix - bMatrix;
    diff = sum(abs(diffMatrix), 'all');
end