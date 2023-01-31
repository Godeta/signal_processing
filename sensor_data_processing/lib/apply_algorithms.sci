//  * get my functions

/**
    * Apply data processing
    value2 is optionnal, if it is given then we are processing reference sensors data (Sick and Antenna)
    funchoice is the function used to process the data
    Otherwise we are processing our prototype sensor data
    The function returns the processed data
    endfunction
**/
    function [result1, result2] = process_data(time, value1, value2, funChoice, showChart)
        if argn(2) < 3 || isempty(value2)
            value2 = -1;
        end
        /**
        process data here
        **/
        select funChoice
        case 1 then
            //function 
            [indice,value]=find_extremums(value1', 1);
            result1 = value;
            if(value2 ~=-1)
                [indice,value]=find_extremums(value2', 1);
                result2 = value;
            else
                result2=0;
            
    end
        case 2 then
            //choix de la fonction peakfinder
            [value,indice] = peakfinder(value1,0.9,2,1,showChart); //plot or not directly included in the function
            result1 = value;
            if(value2 ~=-1)
                [value,indice] = peakfinder(value2,0.9,2,1,0);
                result2=value;
            else
                result2=0;
        end
    else
        result1=0;
        result2=0;
        disp("Mauvaise valeur pour le choix de fonction comptage de pics à appliquer !");
    end
        //affichage du résultat
            if(showChart==1)
                disp("Afficher ? "+ string(showChart));
                figure;
                plot2d(value1);
                xtitle("Filtered data");
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
        case 1 then
            //choix de la fonction find_extremums
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
        case 2 then
            //choix de la fonction peakfinder
            [value,indice] = peakfinder(value1,0.9,2,1,showChart); //plot or not directly included in the function
            result1 = value;
            if(value2 ~=-1)
                [value,indice] = peakfinder(value2,0.9,2,1,0);
                result2=value;
            else
                result2=0;
        end
    else
        result1=0;
        result2=0;
        disp("Mauvaise valeur pour le choix de fonction comptage de pics à appliquer !");
    end
        
    endfunction
