/**
In this file I will put all functions related to peak detection

**/
//clc;
//clear;
// Function to detect peaks in the input array
function peaks = detect_peaks_naive(arr, longueur)
  // Allocate memory for the list of peak values
  peaks = zeros(longueur, 1);

  // Loop through the input array and check for peaks
  for i = 1:longueur
    // A peak is found if the current element is greater than its neighbors
    if (i == 1 || arr(i) > arr(i-1)) && (i == longueur || arr(i) > arr(i+1))
      peaks(i) = arr(i);
    end
  end
endfunction

/** Exemple :
// Define an input array
arr = [1, 2, 3, 2, 1];
// Get the longueur of the array
longueur = length(arr);
// Detect peaks in the array
peaks = detect_peaks_naive(arr, longueur);
// Show peak
w=gca();
peaks = peaks';
plot2d(1:1:longueur,arr);
plot2d(1:1:longueur,peaks, -3);
pl1=w.children(1);pl1.children.mark_foreground=5;  // in red
**/

/**
    Detect the local maximum or minimum in an array
    Take in input the array and the sign
    If sign is positive it will output the local maximums
    If sign is negative it will output the local minimums
    The way It works is that It will check if a value is an extremum among 8 of it's neighbours
        Then It will check if the value makes sense so not above 1.2 times further than the average
**/
function [indice, value] = find_extremums(arr, signe)
  longueur = length(arr);
  // Allocate memory for the list of peak values
  peaks = zeros(longueur, 1);
    ts = abs(arr(1,100)+arr(1,1000)+arr(1,2000))/3; //moyenne de 3 valeurs random
//    disp(ts)
    if(ts>40) then
        ts = 40; //distance minimale de 4 cm
    end
//    disp(ts)
  // Loop through the input array and check for peaks
  for i = 5:longueur-5
      if(arr(i)>ts)
          if(signe>0)
            // A peak is found if the current element is greater than its neighbors
            if ((arr(i) > arr(i-1)) && (arr(i) > arr(i-2)) && (arr(i) > arr(i-3)) && (arr(i) > arr(i-4))) && (i == longueur || (arr(i) > arr(i+1) && (arr(i) > arr(i+2)) && (arr(i) > arr(i+3)) && (arr(i) > arr(i+4))))
              peaks(i) = arr(i);
          end
      else
          if ((arr(i) < arr(i-1)) && (arr(i) < arr(i-2)) && (arr(i) < arr(i-3)) && (arr(i) < arr(i-4))) && (i == longueur || (arr(i) < arr(i+1) && (arr(i) < arr(i+2)) && (arr(i) < arr(i+3)) && (arr(i) < arr(i+4))))
              peaks(i) = arr(i);
//              disp(peaks(i))
          end
      end
    end
  end
  
  //test pour vérifier ma condition
//  for i=980:990
//      disp(arr(i));
//      disp(i)
//      disp(((arr(i) < arr(i-1)) && (arr(i) < arr(i-2)) && (arr(i) < arr(i-3)) && (arr(i) < arr(i-4))) && (i == longueur || (arr(i) < arr(i+1) && (arr(i) < arr(i+2)) && (arr(i) < arr(i+3)) && (arr(i) < arr(i+4)))))
//      disp("- - -")
//  end

//création d'un stop en haut pour éviter de comptabiliser des valeurs irréalistes
val = arr(peaks>1);
avg = mean(val);
highStop = avg*1.15;
//disp(peaks>1)
//disp(highStop);

//on recréer un tableau qui dit pour chaque indice de notre vecteur de valeurs si on conserve la valeur ou non
peaks2 = zeros(longueur, 1);
for i = 5:longueur-5
    if(peaks(i)>1 && arr(i)<highStop) then
        peaks2(i)=arr(i);
    end
end
value = val(val<highStop);
//value = val;
[r N]=size(arr);
f = r*N*(1:N)/N   // frequency scale
//disp(size(f))
indice = f(peaks2>1);
endfunction

//Exemple
//PATH = "C:\devRoot\data\signal_processing\sensor_data_processing";
//ref = csvRead(PATH+'\data_compare\proto3.csv',",");
////ref = csvRead('C:\devRoot\data\tests_uniformes\rouge_compo_4_REF.csv',",");
//a = ref(:,2)'; //transposée car opération prévue pour une matrice en colonne
//[indice,value] = find_extremums(a,-1);
//w=gca();
//plot2d(a);
//plot2d(indice,value,-3);      // plot peaks
//pl1=w.children(1);pl1.children.mark_foreground=5;  // in red

function [i, y] = localmax(x, s)
    // This function finds local maxima within vector x
    //
    // Usage:
    //        [i, y] = localmax(x, s) 
    // 
    // where  x: input vector
    //        s: strict (2), semistrict (1) or loose (0) local maxima
    //        i: vector of indexes where x reaches local maxima
    //        y: vector of values of x at such indexes   
    //
    // Local maxima are defined as values greater than or equal to the
    // immediately preceding and immediately following ones. Argument 
    // s is optional. If it is equal to 2, strict maxima are found 
    // (i.e., the values are strictly greater than the neighbouring 
    // ones); if it is equal to 1, semistrict maxima are found (i.e.,
    // the values are strictly greater than at least one neighbouring
    // value); if it is equal to 0, loose maxima are found (i.e., the
    // values are greater than or equal to the neighbouring ones). x 
    // may be either a row vector or a column vector. If x is complex,
    // abs(x) is used instead of x and given as the second output 
    // argument.
    // 
    // NOTE: In order to assess the first and last elements the vector
    //       x is extended with -inf values 
    //
    // ------------------------------
    // Author: Federico Miyara

    // Default value for s (loose maxima)
    if argn(2)<2
        s = 0;
    end

    // Ensure x is a column vector
    if size(x,1)==1
        x = x(:);
        wasrow = 1;
    else 
        wasrow = 0;
    end

    // For complex signals, the maximum will be obtained for
    // the absolute value 
    if isreal(x)==0
        x = abs(x);
    end

    // Compute a vector xdec that is positive on indexes where x
    // is decreasing. To that end, the next value is subtracted
    // from each value of x
    xdec = x - [x(2:$); -%inf];

    // Compute a vector xinc that is positive on indexes where x
    // is increasing. To that end, the preceding value is subtracted
    // from each value of x
    xinc = x - [-%inf; x(1:$-1)];

    // Obtain a vector whose components are 1 if both xdec and xinc
    // are positive or non-negative according to s.
    switch s
    case 2
        maxi = (xdec>0).*(xinc>0);
    case 1
        maxi =  (xdec>=0).*(xinc>0) + (xdec>0).*(xinc>=0);
    case 0
        maxi = (xdec>=0).*(xinc>=0);
    end

    // Find the indexes corresponding to nonzeros
    i = find(maxi); 

    // If x was a row vector, so must be i
    if wasrow== 1
        i = i(:).';
    else
        i = i(:);
    end

    // Provide the second output argument if requested 
    if argn(1)>1
        y = x(i);
        // If x was a row vector, so must be y
        if wasrow==1
            y = y(:).';
        else
            y = y(:);
        end
    end

endfunction
////Exemple
////ref = csvRead('C:\devRoot\data\capteurs_data_3.csv',",");
//figure
//ref = csvRead('C:\devRoot\data\tests_uniformes\bleu_compo_3_ident_REF.csv',",");
//a = ref(:,2)'; //transposée car opération prévue pour une matrice en colonne
//ts=min(a)+(max(a)-min(a))/20;
//[r N]=size(a);
//f = r*N*(1:N)/N   // frequency scale
//w=gca();
//plot2d(f,a);        // plot signal
//a(a<ts)=ts;
//
//peaks=localmax(a,2);
//
//plot(f,ones(1,N)*ts,"b");            // plot threshold
//plot2d(f(peaks),a(peaks),-3);      // plot peaks
//pl1=w.children(1);pl1.children.mark_foreground=5;  // in red


function peaks=peak_detect(signal,threshold)

// This function detect the peaks of a signal : 
// --------------------------------------------
// For an input row vector "signal" , the function return 
// the position of the peaks of the signal.
//
// The ouput "peaks" is a row vector (size = number of peaks),
// "peaks" =[] if no peak is found.
//
// Optional argument "threshold" eliminates the peaks under
// the threshold value (noise floor). 
//
// Clipped peaks (more than 2 samples of the signal at the same value)
// are not detected.
// -------------------------------------------------------------------
//     Jean-Luc GOUDIER      11-2011
// -------------------------------------------------------------------

[nargout,nargin] = argn(0);
if nargin==2 then ts=threshold;
end;
if nargin==1 then ts=min(signal);
end;

[r c]=size(signal);
Ct=getlanguage();
if Ct=="fr_FR" then
     Msg="Erreur : le signal n''est pas un vecteur colonne";
else
     Msg="Error : signal is not a row vector";
end
if r>1 then
    error(Msg);
end;

Lg=c-1; 
d_s=diff(signal); 
dd_s=[d_s(1),d_s(1,:)];               // diff first shift
d_s=[d_s(1,:),d_s(Lg)];               // diff size correction
ddd_s=[dd_s(1),dd_s(1,1:Lg)];         // diff second shift
Z=d_s.*dd_s;                          // diff zeros

peaks=find(((Z<0 & d_s<0)|(Z==0 & d_s<0 & ddd_s>0)) & signal>ts);

endfunction

//// Exemple
//ref = csvRead('C:\devRoot\data\tests_uniformes\bleu_compo_3_ident_REF.csv',",");
//a = ref(:,2)'; //transposée car opération prévue pour une matrice en colonne
//[r N]=size(a);
//f = r*N*(1:N)/N   // frequency scale
//ts=min(a)+(max(a)-min(a))/20;
//a(a<ts)=ts;
//plot2d(f,a);        // plot signal
//
//peaks=peak_detect(a,ts);
//
//plot2d(f,ones(1,N)*ts);            // plot threshold
////figure;
//plot2d(f(peaks),a(peaks),-3);      // plot peaks

/**
The function peakfinder takes in five input arguments:

* x0: A vector of data.
* sel (optional): A scalar value that determines the selectivity of the peaks. This value is used to filter out smaller peaks in the data. If not provided, the default value is (max(x0)-min(x0))/20.
* thresh (optional): A scalar value that determines the threshold for peak detection. Peaks with magnitude less than this threshold will be ignored. If not provided, no threshold is used.
* extrema (optional): An integer value that specifies whether to find maxima (1) or minima (-1). If not provided, the default value is 1 (maxima).
* plotPeaks (optional): A boolean value that specifies whether to plot the data and the detected peaks. If not provided, the default value is 0 (no plot).

The code first checks that the input data is a vector and that the sel, thresh, and extrema arguments are valid. It then takes the absolute value of the input data if it is not real, and it sets the default values for the optional arguments if they are not provided.

Next, the code calculates the derivative of the input data and finds the indices where the derivative changes sign. These indices correspond to the local extrema in the data. The code then filters out any extrema that do not meet the threshold or selectivity criteria, and it stores the remaining extrema in the value and indice variables. Finally, the code plots the data and the detected peaks if the plotPeaks argument is set to 1.
**/
function [value,indice] = peakfinder(x0, sel, thresh, extrema, plotPeaks)
s = size(x0);
flipData =  s(1) < s(2);
len0 = prod(size(x0));
if len0 ~= s(1) && len0 ~= s(2)
    error('PEAKFINDER:Input','The input data must be a vector')
elseif isempty(x0)
    value = {[],[]};
    return;
end
if ~isreal(x0)
    warning('PEAKFINDER:NotReal','Absolute value of data will be used')
    x0 = abs(x0);
end
if argn(2) < 2 || isempty(sel)
    sel = (max(x0)-min(x0))/20;
//    disp(sel);
elseif ~or(type(sel)==[1 5 8]) || ~isreal(sel) //si on a pas donné un nombre
    sel = (max(x0)-min(x0))/4;
    warning('PEAKFINDER:InvalidSel',...
        'The selectivity must be a real scalar.  A selectivity of //.4g will be used',sel)
elseif prod(size(sel)) > 1
    warning('PEAKFINDER:InvalidSel',...
        'The selectivity must be a scalar.  The first selectivity value in the vector will be used.')
    sel = sel(1);
end
if argn(2) < 3 || isempty(thresh)
    thresh = [];
elseif ~or(type(thresh)==[1 5 8]) || ~isreal(thresh)
    thresh = [];
    warning('PEAKFINDER:InvalidThreshold',...
        'The threshold must be a real scalar. No threshold will be used.')
elseif prod(size(thresh)) > 1
    thresh = thresh(1);
    warning('PEAKFINDER:InvalidThreshold',...
        'The threshold must be a scalar.  The first threshold value in the vector will be used.')
end
if argn(2) < 4 || isempty(extrema)
    extrema = 1;
else
    extrema = sign(extrema(1)); // Should only be 1 or -1 but make sure
    if extrema == 0
        error('PEAKFINDER:ZeroMaxima','Either 1 (for maxima) or -1 (for minima) must be input for extrema');
    end
end
if argn(2) < 5 || isempty(plotPeaks)
    plotPeaks =0;
end
x0 = extrema*x0(:); // Make it so we are finding maxima regardless
thresh = thresh*extrema; // Adjust threshold according to extrema.
dx0 = diff(x0); // Find derivative
dx0(dx0 == 0) = -1; // This is so we find the first of repeated values
ind = find(dx0(1:$-1).*dx0(2:$) < 0)+1; // Find where the derivative changes sign
disp(size(ind))
// Include 
    x = x0(ind); //tableau des valeurs de magnitude où on a un changement de signe
    minMag = -200;//min(x); //ok avec = x(1)
//    disp(minMag)
//    disp(x(1))
    if(isempty(x)) then //pour régler un bug qui arrivait je ne sais pas trop pourquoi
        x=100;
        end
    
//    disp(x0(1))
//    disp(size(x))
    leftMin = min(x(1), x0(1)); //ok avec = 0
// x only has the peaks, valleys, and possibly endpoints
len = prod(size(x));
if len > 2 // Function with peaks and valleys
    // Set initial parameters for loop
    tempMag = minMag;
    foundPeak = 0;
    
    // Skip the first point if it is smaller so we always start on a
    //   maxima
    if x(1) >= x(2)
        ii = 0;
    else
        ii = 1;
    end
    // Preallocate max number of maxima
    maxPeaks = ceil(len/2);
    peakLoc = zeros(maxPeaks,1);
    peakMag = zeros(maxPeaks,1);
    cInd = 1;
    // Loop through extrema which should be peaks and then valleys
    while ii < len
        ii = ii+1; // increment search
        // Reset peak finding if we had a peak and the next peak is bigger
        //   than the last or the left min was small enough to reset.
        if foundPeak
            tempMag = minMag;
            foundPeak = 0;
        end
        // Found new peak that was lager than temp mag and selectivity larger
        //   than the minimum to its left.
        if x(ii) > tempMag && x(ii) > leftMin + sel
            tempLoc = ii;
            tempMag = x(ii);
        end
        // Make sure we don't iterate past the length of our vector
        if ii == len
            break; // We assign the last point differently out of the loop
        end
        ii = ii+1; // Move onto the valley
        // Come down at least sel from peak
        if ~foundPeak && tempMag > sel + x(ii)
            foundPeak = 1; // We have found a peak
            leftMin = x(ii);
            peakLoc(cInd) = tempLoc; // Add peak to index
            peakMag(cInd) = tempMag;
            cInd = cInd+1;
        elseif x(ii) < leftMin // New left minima
            leftMin = x(ii);
        end
    end

    // Create output
    if cInd > 1
        peakInds = ind(peakLoc(1:cInd-1));
        peakMags = peakMag(1:cInd-1);
    else
        peakInds = [];
        peakMags = [];
    end
else // This is a monotone function where an endpoint is the only peak
    [peakMags,xInd] = max(x);
 
        peakMags = [];
        peakInds = [];
end
//// Apply threshold value.  Since always finding maxima it will always be
////   larger than the thresh.
//if ~isempty(thresh)
//    m = peakMags>thresh;
//    peakInds = peakInds(m);
//    peakMags = peakMags(m);
//end
// Rotate data if needed
if flipData
    peakMags = peakMags.';
    peakInds = peakInds.';
end
// Change sign of data if was finding minima
if extrema < 0
    peakMags = -peakMags;
    x0 = -x0;
end

//plot and result outputs
if(plotPeaks==1)
    figure;
//    disp(peakMags)
    plot(1:len0,x0,'.-',peakInds,peakMags,'ro',ind,x,'go','linewidth',2);
    xtitle("Nombre de bouteilles : "+string(length(peakMags)));
    
    /*
    for i=1:length(peakMags)
    t=1:length(x0)
    t=t'
    disp(size(t))
    dy=diff(x0)./diff(t)
    k=peakInds(i); // point number 220
    lgt = 50; //length of the tangent 
    DECAL = 1; //number of points away from our detected minimum
    t=t(k-lgt:k+lgt,1)
    disp(size(t))
    tang=(t-t(lgt+1))*dy(k)+x0(k)
    tangPre=(t-t(lgt-DECAL+1))*dy(k-DECAL)+x0(k-DECAL)
    tangPost=(t-t(lgt+DECAL))*dy(k+DECAL)+x0(k+DECAL)
    plot(t,tang, "b",t,tangPre, "g", t,tangPost, "r")
    scatter(t(lgt+1),x0(k))
    legend("tan point "+string(i));
    end
    */
end
value = peakMags;
indice = peakInds;

endfunction

//Exemple

//ref = csvRead('C:\devRoot\data\tests_uniformes\rouge_compo_4_REF.csv',",");
//PATH = "C:\devRoot\data\signal_processing\sensor_data_processing";
//ref = csvRead(PATH+'\data_compare\proto3.csv',",");
//a = ref(:,2)'; //transposée car opération prévue pour une matrice en colonne
//[val,indice] = peakfinder(a,0.5,500,-1,1); //test modif sel et threeshold 
//peakfinder(a,0.9,2,1,1);


/**
    Détecte les minimums
**/
function [local_min,index] = find_local_min_in_noisy_signal(signal, window_size)
  n = length(signal);
  local_min = [];
  index = [];
  //taille min-max valeur acceptable
    minVal=min(signal)+(max(signal)-3*min(signal))/20;
    if(minVal>40) 
        minVal = 40; //distance minimale de 4 cm
    end
  maxVal = min(signal(100:2000))/2+minVal;

  for i = window_size+1 : n-window_size-1
    window = signal(i-window_size : i+window_size);
    min_value = min(window);
    if signal(i) == min_value && signal(i)<maxVal && signal(i)>minVal && signal(i)<signal(i-1) && signal(i)<signal(i+1)
      local_min = [local_min, signal(i)];
      index = [index,i];
    end
  end
endfunction

//Exemple
//PATH = "C:\devRoot\data\signal_processing\sensor_data_processing";
//ref = csvRead(PATH+'\data_compare\proto3.csv',",");
//data1 = ref(:,2)
//[amp,ind] = find_local_min_in_noisy_signal(data1, 10)
//plot(data1, "b")
//plot2d(ind,amp, -3)

/**
    Compte le nombre de bouteilles détectées en se basant sur le principe des données de réference
    Donc si on détecte puis perd la détection on ajoute 1
    Ce programme sert à s'assurer de la fiabilité du nombre de références
**/
function result = count_cylinders(signal)
  tabLoc = zeros(1,1);
  tabMag = zeros(1,1);
  n = length(signal);
  count = 0;
  for i=2:n
      if(signal(i-1)>=2 && signal(i) <2) then
          count=count+1;
          tabLoc(count)=i-1;
          tabMag(count)=signal(i-1);
      end
      
  end
  plot(tabLoc,tabMag, "ro");
  disp(size(tabLoc))
  result = count;
endfunction

//Exemple
//PATH = "C:\devRoot\data\signal_processing\sensor_data_processing";
//ref = csvRead(PATH+'\data_compare\capteurs11.csv',",");
//data1 = ref(:,2)
//result = count_cylinders(data1)
//disp(result)
//plot(data1)
//title(string(result))

//for i=1:11
//    PATH = "C:\devRoot\data\signal_processing\sensor_data_processing";
//    ref = csvRead(PATH+'\data_compare\capteurs'+string(i)+ '.csv',",");
//    data1 = ref(:,2)
////    result = count_cylinders(data1)
//    [value,indice] = peakfinder(data1,0.9,2,1,-1);
//    result = length(value);
//    disp(result)
//end

/**
    Function to detect peaks which works pretty well but not perfect
    **/
    function [derivLoc, derivMag,peakLoc, peakMag] = oldCumulativePeakDetection(data, sel, coef, minMag)
        //1st step, imitate real time data gathering
        prev = 0;
        prev2 = 0;
        ipdx =1;
        ip2dx =1;
        cInd = 1;
        if argn(2) < 2 || isempty(sel) then sel = 30; end
        if argn(2) < 3 || isempty(coef) then coef = 1.35; end
        if argn(2) < 4 || isempty(minMag) then minMag = 100; end
        derivLoc = zeros(1,1);
        derivMag = zeros(1,1);
        peakLoc = zeros(1,1);
        peakMag = zeros(1,1);
        cInd2 = 1;
        
    for i=1:length(data)
//        if(isempty(data(i))) then //pour régler un bug qui arrivait je ne sais pas trop pourquoi
//        data(i)=100;
//        end
        //dérivative
        dx = data(i)-prev;
        if(dx==0)then dx=-1 end
        dx2 = prev- prev2;
        if(dx2==0)then dx2=-1 end
        //peak if change of sign in derivative
        if(dx * dx2 <0 && i>1) then
            indi = i-1;
            if(data(indi)<minMag) then minMag = data(indi); end
            //here we get the list of points where the derivative change
            derivLoc(cInd2) = indi;
            derivMag(cInd2) = data(indi);
            cInd2 = cInd2 +1;
            if(data(ipdx)<data(ip2dx)+sel && data(ipdx) < minMag*coef+sel) then
                if(data(ipdx) < data(indi)-sel) then
                    disp("val pre "+string(data(ip2dx)) + "val actuelle " + string(data(ipdx)));
                    peakLoc(cInd) = ipdx;
                    peakMag(cInd) = data(ipdx);
                    cInd = cInd +1;
                end
            end
            //update derivatives
            if(data(ipdx) ~= data(indi) && data(ip2dx) ~= data(ipdx) && i>2)then
            ip2dx = ipdx;
            ipdx = indi;
            end
        end
        //update our values
        prev2 = prev;
        prev = data(i)
    end
    endfunction

    /**
    Function to detect peaks based upon the one in peak_detection.sci
    **/
    function [derivLoc, derivMag,peakLoc, peakMag] = cumulativePeakDetection(data, sel, coef, minMag)
        //1st step, imitate real time data gathering
        prev = 0;
        prev2 = 0;
        ipdx =1;
        ip2dx =1;
        cInd = 1;
        if argn(2) < 2 || isempty(sel) then sel = 30; end
        if argn(2) < 3 || isempty(coef) then coef = 1.35; end
        if argn(2) < 4 || isempty(minMag) then minMag = 100; end
        derivLoc = zeros(1,1);
        derivMag = zeros(1,1);
        peakLoc = zeros(1,1);
        peakMag = zeros(1,1);
        cInd2 = 1;
        
    for i=1:length(data)
//        if(isempty(data(i))) then //pour régler un bug qui arrivait je ne sais pas trop pourquoi
//        data(i)=100;
//        end
        //dérivative
        dx = data(i)-prev;
        if(dx==0)then dx=-1 end
        dx2 = prev- prev2;
        if(dx2==0)then dx2=-1 end
        //peak if change of sign in derivative
        if(dx * dx2 <0 && i>1) then
            if(data(i)<minMag) then minMag = data(i); end
            //here we get the list of points where the derivative change
            derivLoc(cInd2) = i-1;
            derivMag(cInd2) = data(i-1);
            cInd2 = cInd2 +1;
            if(data(ipdx)<data(ip2dx)+sel && data(ipdx) < minMag*coef+sel) then
                if(data(ipdx) < data(i)-sel) then
//                    disp("val pre "+string(data(ip2dx)) + "val actuelle " + string(data(ipdx)));
                    peakLoc(cInd) = ipdx-1;
                    peakMag(cInd) = data(ipdx-1);
                    cInd = cInd +1;
                end
            end
            ip2dx = ipdx;
            ipdx = i;
        end
        //update our values
        prev2 = prev;
        prev = data(i)
    end
    endfunction

////Exemple
//    PATH = "C:\devRoot\data\signal_processing\sensor_data_processing";
//    P_PROTO = '\data_compare\scilab_sensor_compare_data\test_cumulative_count';
//    prot=csvRead(PATH+P_PROTO+".csv",",");
//    result2 = prot(:,4);
//    [ii,ma,ind, mag] = cumulativePeakDetection(result2);
//    plot(1:length(result2),result2,ii, -ma, "yo",ind, mag, "po");
//    xtitle(" Detec cumulative : "+string(length(mag)))
//    legend("Signal", "Detection algo scilab", "Changement dérivée", "Changement dérivé algo cumu" ,"Points détéctés algo cumu");

    /**
    Function to detect peaks based upon the one in peak_detection.sci
    **/
    function [derivLoc, derivMag,peakLoc, peakMag] = cumulativeThresholdPeakDetection(data, threshold)
        //1st step, imitate real time data gathering
        prev = 0;
        prev2 = 0;
        cInd = 1;
        cInd2 = 1;
        derivLoc = zeros(1,1);
        derivMag = zeros(1,1);
        peakLoc = zeros(1,1);
        peakMag = zeros(1,1);
        valid = 0;
        
    for i=1:length(data)
//        if(isempty(data(i))) then //pour régler un bug qui arrivait je ne sais pas trop pourquoi
//        data(i)=100;
//        end
        //dérivative
        dx = data(i)-prev;
        if(dx==0)then dx=-1 end
        dx2 = prev- prev2;
        if(dx2==0)then dx2=-1 end
        //peak if change of sign in derivative
        if(dx * dx2 <0 && i>1) then
            //here we get the list of points where the derivative change
            derivLoc(cInd2) = i-1;
            derivMag(cInd2) = data(i-1);
            cInd2 = cInd2 +1;
            if(data(i) < threshold) then
                valid = 1;
            end
            if(data(i)>threshold && valid == 1) then
                    valid = 0;
//                    disp("val pre "+string(data(ip2dx)) + "val actuelle " + string(data(ipdx)));
                    peakLoc(cInd) = i-1;
                    peakMag(cInd) = data(i-1);
                    cInd = cInd +1;
                end
        end
        //update our values
        prev2 = prev;
        prev = data(i)
    end
    endfunction

////Exemple
//    PATH = "C:\devRoot\data\signal_processing\sensor_data_processing";
//    P_PROTO = '\data_compare\scilab_sensor_compare_data\test_cumulative_count';
//    prot=csvRead(PATH+P_PROTO+".csv",",");
//    result2 = prot(:,4);
//    [ii,ma,ind, mag] = cumulativeThresholdPeakDetection(result2, 150);
//    plot(1:length(result2),result2,ii, -ma, "yo",ind, mag, "po");
//    xtitle(" Detec cumulative : "+string(length(mag)))
//    legend("Signal", "Changement dérivée","Points détéctés algo cumu");
