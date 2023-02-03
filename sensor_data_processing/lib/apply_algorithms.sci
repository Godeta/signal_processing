//  * get my functions

/**
    * Apply data processing
    value2 is optionnal, if it is given then we are processing reference sensors data (Sick and Antenna)
    funchoice is the function used to process the data
    Otherwise we are processing our prototype sensor data
    The function returns the processed data
    endfunction
**/
    function [result1, result2] = process_data(value1, value2, funChoice, showChart)
        if argn(2) < 2 || isempty(value2)
            value2 = -1;
        end
        name = "undefined";
        /**
        process data here
        **/
        select funChoice
            //convolution but not checked create filter
            
            //circular convolution but not checked create filter
            
            //median
        case 4 then
            result1 = medianFilter(value1);
            result2 =0;
            name = "median";
            
            //hampel filter
        case 5 then
            //function 
            result1 = hampel_filter_forloop(value1, 10, 3);
            if(value2 ~=-1)
                [indice,value]=find_extremums(value2', 1);
                result2 = value;
            else
                result2=0;
            end
            name = "hampel";
            
            //moving average
        case 6 then
            result1 = moving_average(value1,10);
            result2 =0;
            name = "average";
            
            //Savitzky-Golay Filters
        case 7 then
            result1 = sgolayfilt(value1, 3, 7);
            result2=0;
            name = "sgolay";
            
            //Custom filter inspired by Laplacian
        case 8 then
            result1 = customLap(value1);
            result2=0;
            name = "customlap";
            
            //Gauss filter
        case 9 then
            result1 = gaussFilter(value1,10);
            result2=0;
            name = "gauss";
            
            //fast root mean square
        case 10 then
            result1 = fMsqrt(value1, 30);
            result2=0;
            name = "fast root mean square";
    else
        result1=0;
        result2=0;
        disp("Mauvaise valeur pour le choix de fonction pour le traitement des données !\n");
        disp(string(funChoice))
    end
        //affichage du résultat
            if(showChart==1)
                disp("Afficher ? "+ string(showChart));
                figure;
                plot2d(result1);
                //nom plus ou moins unique pour comparer les données
                xtitle(strcat(["Filter " name " data n° " string(value1(1)) "-" string(value1(100)) "-" string(value1(1000))]));
                if(value2 ~=-1)
                    plot2d(value2);
                    end
            end
    endfunction
    
    /**
        * Convolution data processing
        Uses the convolution matrix input in the GUI
        value2 is optionnal, if it is given then we are processing reference sensors data (Sick and Antenna)
        funchoice is the function used to process the data
        Otherwise we are processing our prototype sensor data
        The function returns the processed data
        endfunction
    **/
    function [result1, result2] = convolution_process(value1, kernel, value2, showChart)
        if argn(2) < 3 || isempty(value2)
            value2 = -1;
        end
        /**
        process data here
        **/
        
        result1=convolution(value1,kernel);
        if(value2 ~=-1)
            result2 = convolution(value2,kernel);
        else
            result2=0;
            
        //affichage du résultat
            if(showChart==1)
                //disp("Afficher ? "+ string(showChart));
                figure;
                plot2d(result1);
                name = "convolution checked";
                xtitle(strcat(["Filter " name " data n° " string(value1(1)) "-" string(value1(100)) "-" string(value1(1000))]));
                if(value2 ~=-1)
                    plot2d(result1);
                    end
            end
            end
    endfunction
    
        /**
        * Same as convolution but with the function circular
    **/
    function [result1, result2] = circ_convolution_process(value1, kernel, value2, showChart)
        if argn(2) < 3 || isempty(value2)
            value2 = -1;
        end
        /**
        process data here
        **/
        
        result1=circularConvolution(value1,kernel);
        if(value2 ~=-1)
            result2 = circularConvolution(value2,kernel);
        else
            result2=0;
            
        //affichage du résultat
            if(showChart==1)
                //disp("Afficher ? "+ string(showChart));
                figure;
                plot2d(result1);
                name = "circular conv checked";
                xtitle(strcat(["Filter " name " data n° " string(value1(1)) "-" string(value1(100)) "-" string(value1(1000))]));
                if(value2 ~=-1)
                    plot2d(result1);
                    end
            end
            end
    endfunction
    
/**
    * Count the number of peaks
    
    Available functions in peak_detection.sci
    - detect_peaks(arr, longueur)
    - find_extremums(arr, signe)
    - localmax(x, s)
    - peak_detect(signal,threshold)
    - peakfinder(x0, sel, thresh, extrema,plotPeaks)
    
**/
    function [result1, result2] = count_peaks(time, value1, value2, funChoice, showChart)
        if argn(2) < 3 || isempty(value2)
            value2 = -1;
        end
        //disp(value1);
        select funChoice
            //choix de la fonction find_extremums
        case 2 then
            [indice,value]=find_extremums(value1', 1);
            result1 = value;
            if(value2 ~=-1)
                [indice,value]=find_extremums(value2', 1);
                result2 = value;
            else
                result2=0;
            //affichage du résultat
            if(showChart==1)
                disp("Afficher ? "+ string(showChart));
                figure;
                w=gca();
                plot2d(value1);
                plot2d(indice,value,-3);      // plot peaks
                pl1=w.children(1);pl1.children.mark_foreground=5;  // in red
            end
    end
            //choix de la fonction peakfinder
        case 3 then
            [value,indice] = peakfinder(value1,0.9,2,1,showChart); //plot or not directly included in the function
            result1 = value;
            if(value2 ~=-1)
                [value,indice] = peakfinder(value2,0.9,2,1,0);
                result2=value;
            else
                result2=0;
        end
        
            //choix de la fonction localmax
        case 4 then
            val = value1';
            ts=min(val)+(max(val)-min(val))/2+0.5; //threshold
            val(val<ts)=ts;
            peaks=localmax(val,2);
            result1 = val(peaks);
            if(showChart==1) then
                figure;
                w=gca();
//                disp(size(result1))
//                disp(size(f(peaks)))
                [r N]=size(val);
                f = r*N*(1:N)/N   // frequency scale
                plot2d(f,val);        // plot signal
                disp("test ");
                disp(ts)
                plot(f,ones(1,N)*ts,"b");            // plot threshold
                plot2d(f(peaks),result1,-3);      // plot peaks
                pl1=w.children(1);pl1.children.mark_foreground=5;  // in red
            end
            if(value2 ~=-1)
                val = value2';
                ts=min(val)+(max(val)-min(val))/2+0.5; //threshold
                val(val<ts)=ts;
                peaks=localmax(val,2);
                result2 = val(peaks);
            else
                result2=0;
            end
            
            //choix de la fonction detect_peaks_naive
            case 5 then
            // Get the longueur of the array
             longueur = length(value1);
            // Detect peaks in the array
            peaks = detect_peaks_naive(value1, longueur);
            result1 = peaks;
            if(showChart==1) then
                figure;
              // Show peak
                w=gca();
                peaks = peaks';
                plot2d(1:1:longueur,value1);
                plot2d(1:1:longueur,peaks, -3);
                pl1=w.children(1);pl1.children.mark_foreground=5;  // in red
             end
            if(value2 ~=-1)
                longueur = length(value2);
            // Detect peaks in the array
            peaks = detect_peaks_naive(value2, longueur);
            result2 = peaks;
            else
                result2=0;
            end
            
            //choix de la fonction local_min_noisy
            case 6 then
            [amp,ind] = find_local_min_in_noisy_signal(value1, 10)
            result1 = amp;
            
            if(showChart==1)then
                figure;
                plot(value1, "b")
                plot2d(ind,amp, -3)
            end
            if(value2 ~=-1)
                [amp,ind] = find_local_min_in_noisy_signal(value2, 10)
                result2=amp;
            else
                result2=0;
        end
    else
        result1=0;
        result2=0;
        disp("Mauvaise valeur pour le choix de fonction comptage de pics à appliquer !");
        disp(string(funChoice))
    end
        
    endfunction
