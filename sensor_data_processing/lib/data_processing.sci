/**
In this file I will put all functions related to data processing
Insirations : https://www.mathworks.com/help/signal/ug/signal-smoothing.html et https://www.mathworks.com/help/signal/index.html?s_tid=CRUX_lftnav 
**/

//convolution using a specified vector
function result = convolution(data, weightVector, makeFilter)
//    disp(weightVector)
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
    result = conv(data,y, "same");
endfunction

//circular convolution
function result = circularConvolution(data, weightVector, makeFilter)
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
    N = length(data);
    L = length(y);
    outputSize = N + L -1;
    xpad = [data' zeros(1,outputSize-N)];
    ypad = [y zeros(1,outputSize-L)];
    fx = fft(xpad, 1, 1)
    fy = fft(ypad)
    ccirc = abs(fft(fx.*fy,-1,1));
    result = ccirc'(length(y):$,1);
endfunction

// -- test Hampel filter --
//exemple use : data = hampel_filter_forloop(u, 10, 3);
function result = hampel_filter_forloop(input_series, window_size, n_sigmas)
    if(isempty(n_sigmas)) then
    n_sigmas = 3;
    end
    n = length(input_series);
    new_series = input_series;
    k = 1.4826 // scale factor for Gaussian distribution
    
    indices = [0]
    
    for i=window_size:n-window_size
        x0 = median(input_series((i - window_size+1):(i + window_size)))
        S0 = k * median(abs(input_series((i - window_size+1):(i + window_size)) - x0))
        if (abs(input_series(i) - x0) > n_sigmas * S0) then
            new_series(i) = x0
            cat(indices,i);
            end
    end
    result= new_series;
endfunction

//the moving average is a convolution with an equally distributed vector so that the sum = 1, sizeOf is the size of our moving average
function result = moving_average(data,sizeOf)
    //default value of sizeOf
    if(isempty(sizeOf) || sizeOf <1) then
    sizeOf = 10
    end
    y = ones(1,sizeOf)/sizeOf;
    result = conv(data,y, "same");
endfunction

//correlation based on a radar processing exemple I found in a pdf document on scilab
function result = correlationR(data,sizeOf)
    data_fold = mtlb_fliplr (data);
    original_signal = ones(1,length(data)-1);
    conv(data,data_fold);
    //default value of sizeOf
    if(isempty(sizeOf) || sizeOf <1) then
    sizeOf = 10
    end
    y = ones(1,sizeOf)/sizeOf;
    result = conv(data,y, "same");
endfunction
/* Correlation
R = w ; // o nl y Noise S i g n a l

R_fold = mtlb_fliplr (R ) ;
Received_Absence = conv (x , R_fold ) ; // 
figure();
plot(n,sqrt(Received_Presence(length(n)/2:length(n)/2+length(n)-1)), 'green', n, x, 'red');
*/

//Median filter: only need the data as an input
function result = medianFilter(x)
    z=[];
    z(1) = median([0 0 x(1) x(2) x(3)]);
    z(2) = median([0 x(1) x(2) x(3) x(4)]);
    z(length(x)-1) = median([0 x(1) x(2) x(3) x(4)]);
    z(length(x)) = median([0 x(1) x(2) x(3) x(4)]);
    for i=3:length(x)-2
        z(i)=median([x(i-2) x(i- 1) x(i) x(i + 1) x(i + 2)]);
    end
    result = z;
endfunction


//custom filter inspired by Laplacian, It's a pretty random thing because I failed to implement what I initially wanted
function result = customLap(data)
    n = 100;
    // Initialize the Laplacian matrix
    L = zeros(n, n);
    
    // Set the main diagonal elements to 1
    L(1:n + 1:n^2) = 1;
    
    // Set the adjacent off-diagonal elements to -1
    L(2:n + 1:n^2 - 1) = -0.4;
    L(n + 1:n + 1:n^2 - n) = -0.4;
    // Print the Laplacian matrix
    y = zeros(n, 1);
    // Perform the convolution -> revoir https://math.stackexchange.com/questions/3878457/creating-the-1d-laplacian-matrix 
    for i = 1:n
        y(i) = sum(L(i,:));
    end
    
    result = conv(data, y,'same');
endfunction

// User defined function to find linear convolution
function y = linearconvolve(x,h)
m = length(x);
n = length(h);
y = cell(n+m-1,1);
//Method : Using Direct Convolution Sum Formula
for i = 1:n+m-1
//    disp(i)
    conv_sum = 0;
    for j = 1:i
        if (((i-j+1) <= n)&(j <= m))
            conv_sum = conv_sum + x(j)*h(i-j+1);
        end;
    end;    
    y{j} = conv_sum;
end;
//disp(y)
endfunction

//filtering using gauss parabola
function result = gaussFilter(data, sizeOf)
    x = [-sizeOf:sizeOf];
   gauss = exp(-(x/sizeOf).^2); // une forme de gaussienne d'épaisseur environ 10, soit a peu près la même chose que la petite boite
   gauss = gauss / sum(gauss); // Normalisation, pour que la convolution ne change pas la valeur moyenne
//    n=length(gauss)
//    m=length(data)
//    X=[data,zeros(1,n)]; 
//    H=[gauss,zeros(1,m)]; 
//    for i=1:n+m-1
//     Y(i)=0;
//        for j=1:m
//            if(i-j+1>0)
//                disp(i)
//                disp(j)
//                Y(i)=Y(i)+X(j)*H(i-j+1);
//            else
//        end
//    end
//end
//     result = Y;
    result = linearconvolve(data,gauss);
//    result = conv(data, gauss,'same');
//    disp(size(result));
endfunction

//fast root mean square
function result = fMsqrt(data, sizeOf)
    y = ones(1,sizeOf)
    clin = conv(data.^2,y, "same")
    result = sqrt(clin/sum(y))
endfunction

/**
Let's attempt to remove the effect of the line noise by using a moving average filter.

If you construct a uniformly weighted moving average filter, it will remove any component that is periodic with respect to the duration of the filter.

There are roughly 1000 / 60 = 16.667 samples in a complete cycle of 60 Hz when sampled at 1000 Hz. Let's attempt to "round up" and use a 17-point filter. This will give us maximal filtering at a fundamental frequency of 1000 Hz / 17 = 58.82 Hz.

sgolayfilt(u, 1, 17);
**/

