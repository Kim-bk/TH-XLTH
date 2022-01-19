function  [Dist, pos] = Euclidean_Distance_Vowel(mfccMatrixTraning, mfccMatrix)
    [~,~, vowelNumber] = size(mfccMatrixTraning);
    [FRAME_NUMBER,~] = size(mfccMatrix);
    averageDistance = zeros(1, vowelNumber);
    for i = 1 : vowelNumber
        minDist = zeros(1, FRAME_NUMBER);
        for frame = 1:FRAME_NUMBER
            [minDist(frame), ~] = Euclidean_Distance(mfccMatrixTraning(:,:,i), mfccMatrix(frame,:));
        end
        averageDistance(i) = sum(minDist)/FRAME_NUMBER;
    end
    [Dist, pos] = min(averageDistance);
end