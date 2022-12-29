/**
In this file I will put all functions related to data processing

**/

function [result, ] = convolution(data, weightVector, makeFilter)
    if makeFilter then
        order = weightVector(1);
        lf = weightVector(1);
        hf = weightVector(2);
        y = ffilt("bp",order, lf, hf);
//        [y, rep, frequ] = wfir('bp', 50, [0.01,0.1],'re', [0 0])
    else
        y = weightVector;
end

    clin = conv(data,y);
endfunction

function [result, ] = circularConvolution(data, weightVector, makeFilter)
    if makeFilter then
        order = weightVector(1);
        lf = weightVector(1);
        hf = weightVector(2);
        y = ffilt("bp",order, lf, hf);
//        [y, rep, frequ] = wfir('bp', 50, [0.01,0.1],'re', [0 0])
    else
        y = weightVector;
end

    clin = conv(data,y);
endfunction

function result = medFilt(data, N)
endfunction
