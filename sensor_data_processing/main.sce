/**
    * In this file I will apply my functions available in "data_processing.sci" or "peak_detection.sci" to manipulate my data and try to count the bottles

**/

clc;
clear;

//  * get my functions
PATH = get_absolute_file_path("main.sce");
chdir(PATH);
funcprot(0);
exec('lib/peak_detection.sci');
exec('lib/data_processing.sci');

/**
    * Apply data processing
    value2 is optionnal, if it is given then we are processing refenrence sensors data (Sick and Antenna)
    Otherwise we are processing our prototype sensor data
**/
    function [result1, result2] = process_data(time, value1, value2)
        if argn(2) < 3 || isempty(value2)
            value2 = -1;
        end
        /**
        process data here
        **/
        
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

/**
    * get my data : array of time, rawDistance, time2, Sick and Antenna with 10 lines of >10000 columns
    Apply the treatments on all my data
**/

f = figure();
  uicontrol(f, ...
"style", "text", ...
"string", "0", ...
"constraints", createConstraints("gridbag", [2, 1, 1, 1], [1, 1], "horizontal", "center"), ...
"tag", "count", ...
"margins", [5 5 5 5]);

//checkbox
function checkBox()
    set(check,"value",-get(check,"value"));
    //disp(get(check,"value"));
    set("count", "string", string(get(check,"value")));
endfunction

//liste graphique
function updateListBox(h)
  //disp("Valeur : "+string(get(h, "value")))
  choice = get(h, "value");
  for i=1:5
    proto= csvRead('C:\devRoot\data\data_compare\proto'+string(i)+'.csv',",");
    ref= csvRead('C:\devRoot\data\data_compare\capteurs'+string(i)+'.csv',",");
    [nbBouteille1, nbB2] = count_peaks(proto(:,1),proto(:,2),-1,choice, get(check,"value"));
    disp("Nombre bouteilles du fichier prototype "+string(i)+" -> "+string(length(nbBouteille1)) );//+ " taille des données : "+ string(length(proto(:,2))));
    [nbBouteille1, nbB2] = count_peaks(ref(:,1),ref(:,2),ref(:,3),choice, get(check,"value"));
    disp("Nombre bouteilles du fichier de réference "+string(i)+" Sick  -> "+string(length(nbBouteille1))+" Antenne  -> "+string(length(nbB2)) );//+ " taille des données : "+ string(length(ref(:,2))));
    //dims=2;
//    values=cat(dims,proto(:,1),proto(:,2));
//    vals = cat(dims,ref(:,2),ref(:,2),ref(:,3));
//    data = cat(dims,data,values);
end
  endfunction
  
width = 200;
height = 120;


set(f, "position", [0 0 width height]);
h = uicontrol(f, "style", "listbox", "callback", "updateListBox");
set(h, "position", [0 0 width height]);
set(h, "string", ["find extremum" "peakfinder" "banana" "berry" "grape"]);
check = uicontrol(f, "style", "pushbutton", "position", [0 0 200 20], "string", "Display charts", "BackgroundColor", [0.9 0.9 0.9], "callback", "checkBox");
set(check,"value",1);
//data = csvRead('C:\devRoot\data\tests_uniformes\rouge_compo_4.csv',",");
/*proto1 = csvRead('C:\devRoot\data\proto_data_3.csv',",");
time = data(:,1);
rawDistance = data(:,2);
averageDistance = data(:,3);
minMax = data(:,4);
boolDetec = data(:,5);

ref = csvRead('C:\devRoot\data\tests_uniformes\rouge_compo_4.csv',",");
ref1 = csvRead('C:\devRoot\data\capteurs_data_3.csv',",");
Rtime1 = ref1(:,1);
sick1 = ref1(:,2);
antenna1 = ref1(:,3);*/


/**
    * Show what is going on
**/
