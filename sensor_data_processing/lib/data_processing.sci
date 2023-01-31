/**
In this file I will put all functions related to data processing
Insirations : https://www.mathworks.com/help/signal/ug/signal-smoothing.html et https://www.mathworks.com/help/signal/index.html?s_tid=CRUX_lftnav 
**/

function result = convolution(data, weightVector, makeFilter)
    disp(weightVector)
    if argn(2) < 3 || isempty(makeFilter)
            makeFilter = -1;
        end
    if makeFilter==1 then
        order = weightVector(1);
        lf = weightVector(1);
        hf = weightVector(2);
        y = ffilt("bp",order, lf, hf);
//        [y, rep, frequ] = wfir('bp', 50, [0.01,0.1],'re', [0 0])
    else
        y = weightVector;
end
    //disp(y)
    result = conv(data,y);
endfunction

function result = circularConvolution(data, weightVector, makeFilter)
    if argn(2) < 3 || isempty(makeFilter)
            makeFilter = -1;
        end
    if makeFilter then
        order = weightVector(1);
        lf = weightVector(1);
        hf = weightVector(2);
        y = ffilt("bp",order, lf, hf);
//        [y, rep, frequ] = wfir('bp', 50, [0.01,0.1],'re', [0 0])
    else
        y = weightVector;
end

    result = conv(data,y);
endfunction

function result = medFilt(data, N)
endfunction

/**
Let's attempt to remove the effect of the line noise by using a moving average filter.

If you construct a uniformly weighted moving average filter, it will remove any component that is periodic with respect to the duration of the filter.

There are roughly 1000 / 60 = 16.667 samples in a complete cycle of 60 Hz when sampled at 1000 Hz. Let's attempt to "round up" and use a 17-point filter. This will give us maximal filtering at a fundamental frequency of 1000 Hz / 17 = 58.82 Hz.

sgolayfilt(u, 1, 17);
**/

/**

def hampel_filter_forloop(input_series, window_size, n_sigmas=3):
    
    n = len(input_series)
    new_series = input_series.copy()
    k = 1.4826 # scale factor for Gaussian distribution
    
    indices = []
    
    # possibly use np.nanmedian 
    for i in range((window_size),(n - window_size)):
        x0 = np.median(input_series[(i - window_size):(i + window_size)])
        S0 = k * np.median(np.abs(input_series[(i - window_size):(i + window_size)] - x0))
        if (np.abs(input_series[i] - x0) > n_sigmas * S0):
            new_series[i] = x0
            indices.append(i)
    
    return new_series, indices
    
    **/
