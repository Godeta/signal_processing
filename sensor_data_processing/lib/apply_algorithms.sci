//  * get my functions

/**
    * Apply preprocessing on the data
    funchoice is the function used to process the data
    showChart display a chart of the data if it's value is 1
**/
    function result = preProcess_data(detec, data, funChoice, showChart)
        name = "undefined";
        /**
        preprocess data here
        **/
        select funChoice
            //none
     case 1 then
         result = data;
         name = "none"
            //smoothIrregular
        case 2 then
            result = smoothIrregular(data);
            name = "smoothIrregular"
            
            //smoothData with generated time
        case 3 then
            t = 1:prod(size(data));
            result = smoothData(t',data, 5); //using generated time
            name = "smoothDataGeneTime";
            
//            this part doesn't work with the file proto9 and also it didn't give very good result so I just got rid of it
//            //smoothData with the real time
//        case 4 then 
//            result = smoothData(time,data, 100); // using the real data time
//            name = "smoothDataRealTime"

        case 4 then
            result= smartPreProcess(data,detec);
            name="smartPreProcess";
            
            //cutIrregular
        case 5 then
            result = cutIrregular(data);
            name = "cutIrregular";
    else
        result=0;
        disp("Mauvaise valeur pour le choix de fonction pour le traitement des données !\n");
        disp(string(funChoice))
    end
    //disp(name);
        //affichage du résultat
            if(showChart==1)
                disp("Afficher ? "+ string(showChart));
                figure;
//                plot2d(result);
               // specify different sizes
                x=1:length(result);
                // set color map
//                gcf().background=2;
//                gcf().color_map = coolcolormap(64);
                scatter(x,result, 10, x, "fill");
                //nom plus ou moins unique pour comparer les données
                xtitle(strcat(["Filter " name " data n° " string(data(1)) "-" string(data(100)) "-" string(data(1000))]));
            end
    endfunction

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
//    disp(name);
    
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
            //choix de la fonction peakfinder qui détecte les sommets
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
        
        //
        //choix de la fonction peakfinder qui détecte les minimums
        case 7 then
            [value,indice] = peakfinder(value1,10,500,-1,showChart); //plot or not directly included in the function
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
        disp(string(funChoice))
    end
        
    endfunction
    
    
    /**
    test to compare the processing of raw data with scilab to the processing inside my sensor and checc If they are equal
    **/
    PATH = "C:\devRoot\data\signal_processing\sensor_data_processing";
    P_PROTO = '\data_compare\test_capt_pro_';
    P_REF = '\data_compare\test_capt_pro_REF_';
    NB_DATA = 2;
    
    //plot all data
//    for(i=1:NB_DATA)
//        close(); close(); //close the windows
//        prot=csvRead(PATH+P_PROTO+string(i)+".csv",",");
//        refe=csvRead(PATH+P_REF+string(i)+".csv",",");
//        figure();
//        siz=prod(size(prot(:,2)));
//        time = 1:siz;
//        plot(time,prot(:,2),time, prot(:,3));
//        disp(length(peakfinder(prot(:,3),0.5,500,-1,1)));
//        
//        xtitle("Proto"+string(i));
//        legend("Prepro", "Processed");
//        figure();
//        plot(refe(:,2));
//        xtitle("Refe"+string(i));
//        
//        if(modulo(i,2)==0)then
//            new = smoothIrregular(prot(:,2));
//            result1 = gaussFilter(prot(:,2),21);
//            figure();
//            plot(time,new,time,result1); 
//            xtitle("Scilab process data");
//            legend("Prepro", "Gauss");
//         end
//            
//        
//    end
    
//    for i=1:20
//        close()
//    end
prot=csvRead(PATH+P_PROTO+string(1)+".csv",",");
refe=csvRead(PATH+P_REF+string(1)+".csv",",");
result = count_cylinders(refe(:,2))
disp(result)
plot(refe(:,2))
figure()

    conv
//sans scilab
new = prot(:,2);
result1 = prot(:,3);

//avec scilab
//new = smoothIrregular(prot(:,2));
result1 = gaussFilter(new,21);

plot(result1)

disp(length(peakfinder(result1,10,500,-1,1)));
disp(length(peakfinder(result1,0.9,2,1,1)));
//disp(count_cylinders(prot(:,3)))
