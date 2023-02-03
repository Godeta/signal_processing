/**
    * This file generates a CSV file with all the data processed by the different functions we can try with the GUI
**/

// --- CLEAR SCILAB SPACE ---
clc;
clear;
close()

//  --- GET MY FUNCTIONS ---
PATH = get_absolute_file_path("csv_complete_generation.sce");
PATH_IMAGE = PATH + "title.jpg";
chdir(PATH)
getd('lib');

// --- PARAMETERS ---
NB_DATA_FILES = 5;
KERNEL = [1/3 1/3 1/3]; //convolution kernel

global dataProto
global dataProtoProcessed

dataProto=cell(NB_DATA_FILES,1);
dataProtoProcessed=cell(NB_DATA_FILES,1);
dataRef = cell(NB_DATA_FILES,1);

for i=1:NB_DATA_FILES //for as many data files as we have
        
        //get the data
        dataProto{i}= csvRead(PATH+'\data_compare\proto'+string(i)+'.csv',","); //the original data
        dataProtoProcessed{i}= csvRead(PATH+'\data_compare\proto'+string(i)+'.csv',","); //the data once it has been processed
        dataRef{i}= csvRead(PATH+'\data_compare\capteurs'+string(i)+'.csv',",");
    end


// --- CSV GENERATION PROGRAM ---
/**
    -   -   LISTE DE TRAITEMENTS    -   -
    1) Aucun filtre
    2) Filtre de convolution 1/3 1/3 1/3
    3) Filtre de convolution circulaire 1/3 1/3 1/3
    4) Filtre median
    5) Filtre hampel
    6) Moving average
    7) sgolay
    8) Gauss
    9) Fast root mean square
    
    -   -   LISTE DE DETECTIONS     -   -
    1) find_extremum
    2) peakfinder
    3) localmax
    4) detect_peaks_naive
    5) local_min_noisy
    
    -   -   CSV table   -   -
    detec n° ; filter n° ; data n° ; Proto ; Sick ; Antenna ; ratio
    D'abord detec ensuite traitement : 1 ; 1 -> 2 ; 1 -> 3 ; 1 ... 1 ; 2
**/
NB_TREATMENT = 9;
NB_DETEC = 5;
CurrentLine = 1;

//Our CSV table : 6 columns, as many rows as our data files * treatments to apply * detection to apply + 1 row for the text
    csvData=cell(7,NB_DATA_FILES*NB_TREATMENT*NB_DETEC+1);
    //initialiser les 6 premières colonnes du tableau csv
    csvData{1,1}= "Detec n° ";
    csvData{2,1}= "Filter n° ";
    csvData{3,1}= "Data n°  ";
    csvData{4,1}= "Prototype ";
    csvData{5,1}= "Sick ";
    csvData{6,1}= "Antenna ";
    csvData{7,1}= "Ratio ";
    
    //all detection algorithm
    for i=1:NB_DETEC
        //all filter processing
        for j=1:NB_TREATMENT
            //all data
            for k=1:NB_DATA_FILES
                        CurrentLine= CurrentLine+1;
                        csvData{1,CurrentLine}= string(i);
                        csvData{2,CurrentLine}= string(j);
                        csvData{3,CurrentLine}= string(k);
                        disp(CurrentLine);
                        
                        //data
                        proto = dataProto{k};
                        proto_processed = dataProtoProcessed{k};
                        ref = dataRef{k};
                        
                        //- -   THE NUMBER OF BOTTLES   -   -
                        
                        //choice of filter
                        switch j
                            //convolution, j = 1 
                            case 1
                                [resultat1, resultat2]= convolution_process(proto(:,2), KERNEL,-1,-1);
                                proto_processed(:,2)=resultat1;
                             //circular convolution, j = 2 
                            case 2
                                [resultat1, resultat2]= circ_convolution_process(proto(:,2), KERNEL,-1,-1);
                                proto_processed(:,2)=resultat1;
                                //j > 2, all my other process
                            else
                                [resultat1, resultat2] = process_data(proto(:,2), -1, j+1, -1);
                                proto_processed(:,2)=resultat1;
                            end
                        
                        //Prototype count bottles, nbBouteille1 gets the number of bottles counted, vide is empty
                        [nbBouteille1, vide] = count_peaks(proto_processed(:,1),proto_processed(:,2),-1,i+1, -1);
                        nbProto = length(nbBouteille1);
                        csvData{4,CurrentLine}= string(nbProto);
                        
                        //Reference sensor count bottles, nbBouteilleRef1 gets the number of bottles counted by the Sick sensor while nbBouteilleRef2 is for the antenna sensor
                        [nbBouteilleRef1, nbBouteilleRef2] = count_peaks(ref(:,1),ref(:,2),ref(:,3),i+1, -1);
                        nbRef1 = length(nbBouteilleRef1);
                        nbRef2 = length(nbBouteilleRef2);
                        csvData{5,CurrentLine}= string(nbRef1);
                        csvData{6,CurrentLine}= string(nbRef2);
                        
                        //- -   THE RATIO   -   -
                        csvData{7,CurrentLine}= string((nbProto/nbRef1+nbProto/nbRef2)*50); //formula (H5/I5+H5/J5)*100/2
                        
//                        disp(strcat(["Ligne : " string(CurrentLine) " i : " string(i) " j : " string(j) " k : " string(k)]))
            end
        end
    end
    
//  -   -   WRITE THE CSV   -   -
        printf("\n");
        printf("############################################################################\n")
        printf(" Saving the result in a .cvs file \n")
        printf("############################################################################\n")
        printf("\n");
        RESU2 = mopen(PATH + "data_output" + ".csv",'w') ;
        for i=1:NB_DATA_FILES*NB_TREATMENT*NB_DETEC+1
            disp(strcat([csvData{1,i} ";" csvData{2,i} ";" csvData{3,i} ";" csvData{4,i} ";" csvData{5,i} ";" csvData{6,i} ";" csvData{7,i} "\n"]))
            mfprintf(RESU2,strcat([csvData{1,i} ";" csvData{2,i} ";" csvData{3,i} ";" csvData{4,i} ";" csvData{5,i} ";" csvData{6,i} ";" csvData{7,i} "\n"]));
            end
        mfprintf(RESU2,'\n\n');
        mclose(RESU2);
