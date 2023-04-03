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
MIN_DATA = 1;
NB_DATA_FILES = 11;
KERNEL = [-0.0540035   0.0124964  -0.0138118   0.0730636  -0.0424413   0.0023968  -0.0918923 0.1123128  -0.0044512   0.127324  -0.4140271   0.2624241   0.2624241  -0.4140271 0.127324  -0.0044512   0.1123128  -0.0918923   0.0023968  -0.0424413   0.0730636 -0.0138118   0.0124964  -0.0540035]; //convolution kernel

global dataProto
global dataProtoPrepro
global dataProtoProcessed

dataProto=cell(NB_DATA_FILES,1);
dataProtoPrepro=cell(NB_DATA_FILES,1);
dataProtoProcessed=cell(NB_DATA_FILES,1);
dataRef = cell(NB_DATA_FILES,1);

for i=MIN_DATA:NB_DATA_FILES //for as many data files as we have
        
        //get the data
        dataProto{i}= csvRead(PATH+'\data_compare\proto'+string(i)+'.csv',","); //the original data
        dataProtoPrepro{i}= csvRead(PATH+'\data_compare\proto'+string(i)+'.csv',","); //the preprocessed data
        dataProtoProcessed{i}= csvRead(PATH+'\data_compare\proto'+string(i)+'.csv',","); //the data once it has been processed
        dataRef{i}= csvRead(PATH+'\data_compare\capteurs'+string(i)+'.csv',",");
    end

// --- CONVOLUTION KERNEL ---
kernelList = cell(30,1);

kernelList{1} = 1/256*[1 4 6 4 1 4 16 24 16 4 6 24 36 24 6 4 16 24 16 4 1 4 6 4 1]; // filtre gaussien
kernelList{2} = -1/256*[1 4 6 4 1 4 16 24 16 4 6 24 -476 24 6 4 16 24 16 4 1 4 6 4 1]; // filtre masque flou qui accentue le pic des images
coef = 10;
kernelList{3} = [0 0 0 0 1 0 0 0 0]+ ([0 0 0 0 1 0 0 0 0]-[1 1 1 1 1 1 1 1 1]/coef)*coef; // sharpening filter https://en.wikipedia.org/wiki/Unsharp_masking
kernelList{4} = [-0.0125661  -0.0047423   0.0052415   0.0170011   0.0300105   0.0436333   0.057162 0.0698647   0.0810332   0.0900316   0.0963398   0.0995893   0.0995893   0.0963398 0.0900316   0.0810332   0.0698647   0.057162   0.0436333   0.0300105   0.0170011 0.0052415  -0.0047423  -0.0125661]; // chebyshev ordre 24 pass band 50 hz
kernelList{5} = [0.0372283  -0.0251997   0.0278522  -0.0503677   2.205D-17  -0.0658655  -0.0481084 -0.0587992  -0.1223217  -2.205D-17  -0.2854172   0.5291927   0.5291927  -0.2854172 2.205D-17  -0.1223217  -0.0587992  -0.0481084  -0.0658655   2.205D-17  -0.0503677 0.0278522  -0.0251997   0.0372283]; // rectangle ordre 24 pass band 100 hz
kernelList{6} = [-0.0540035   0.0124964  -0.0138118   0.0730636  -0.0424413   0.0023968  -0.0918923 0.1123128  -0.0044512   0.127324  -0.4140271   0.2624241   0.2624241  -0.4140271 0.127324  -0.0044512   0.1123128  -0.0918923   0.0023968  -0.0424413   0.0730636 -0.0138118   0.0124964  -0.0540035]; // rectangle ordre 24 pass band 100 hz -> low 20
kernelList{7} = ffilt("bp",50,10,40);
x = [-10:10];
gauss = exp(-(x/10).^2); // une forme de gaussienne d'épaisseur environ 10, soit a peu près la même chose que la petite boite
kernelList{8} = gauss / sum(gauss); // Normalisation, pour que la convolution ne change pas la valeur moyenne
[kernelList{9}, rep, frequ] = wfir('bp', 50, [0.01,0.1],'re', [0 0]);
kernelList{10}= [0;0;0;5;5;5;5;4;3;2;1;0];
kernelList{11} = ones(1,11)/11;
kernelList{12}= ones(1,201)/201;
FIN = 12;


kernelListSTR = ["[1/3 1/3 1/3]" "[2 1 2 1]" "[1 -1 1]" "[ 0 1 0 1 -4 1 0 1 0]" "[0 -1 0 -1 5 -1 0 -1 0]" "[0 0.2 0.4 0.6 0.8 1 0.8 0.6 0.4 0.2 0]" "[0.0058178   0.0152432   0.0279459   0.0432177   0.0600211   0.0770718   0.09295 0.09295   0.0770718   0.0600211   0.0432177   0.0279459   0.0152432   0.0058178]" "[-0.0125661  -0.0047423   0.0052415   0.0170011   0.0300105   0.0436333   0.057162 0.0698647   0.0810332   0.0900316   0.0963398   0.0995893   0.0995893   0.0963398 0.0900316   0.0810332   0.0698647   0.057162   0.0436333   0.0300105   0.0170011 0.0052415  -0.0047423  -0.0125661]"];
TAILLE = prod(size(kernelListSTR));

for i=1:TAILLE
    kernelList{i+FIN}=evstr(kernelListSTR(i));
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
    detec n° ; prepro n° ; filter n° ; data n° ; Proto ; Sick ; Antenna ; ratio
    D'abord detec ensuite traitement : 1 ; 1 -> 2 ; 1 -> 3 ; 1 ... 1 ; 2
**/

NB_PRETREATMENT = 5;
NB_TREATMENT = 9;
NB_DETEC = 5;
CurrentLine = 1;

//Our CSV table : 6 columns, as many rows as our data files * PREtreatments * treatments to apply * detection to apply + 1 row for the text
    csvData=cell(8,NB_DATA_FILES*NB_TREATMENT*NB_DETEC*NB_PRETREATMENT+1);
    //initialiser les 6 premières colonnes du tableau csv
    csvData{1,1}= "Detec n° ";
    csvData{2,1}= "Prepro n° ";
    csvData{3,1}= "Filter n° ";
    csvData{4,1}= "Data n°  ";
    csvData{5,1}= "Prototype ";
    csvData{6,1}= "Sick ";
    csvData{7,1}= "Antenna ";
    csvData{8,1}= "Ratio ";
    
    //all detection algorithm
    for i=1:NB_DETEC
        //all pretreatments of the raw data
         for j=1:NB_PRETREATMENT
            //all filter processing
            for k=1:NB_TREATMENT
                //all data
                for l=MIN_DATA:NB_DATA_FILES
                            CurrentLine= CurrentLine+1;
                            csvData{1,CurrentLine}= string(i);
                            csvData{2,CurrentLine}= string(j);
                            csvData{3,CurrentLine}= string(k);
                            csvData{4,CurrentLine}= string(l);
                            disp(CurrentLine);
                            
                            //data
                            proto = dataProto{l};
                            proto_preprocessed = dataProtoPrepro{l};
                            proto_processed = dataProtoProcessed{l};
                            ref = dataRef{l};
                            
                            //- -   THE NUMBER OF BOTTLES   -   -
                            
                            //choice of prefilter to apply preprocessing
                            proto_preprocessed(:,2) = preProcess_data(proto(:,4),proto(:,2), j, -1);
                            
                            //choice of filter
                            switch k
                                //convolution, j = 1 
                                case 1
                                    [resultat1, resultat2]= convolution_process(proto_preprocessed(:,2), KERNEL,-1,-1);
                                    proto_processed(:,2)=resultat1;
                                 //circular convolution, j = 2 
                                case 2
                                    [resultat1, resultat2]= circ_convolution_process(proto_preprocessed(:,2), KERNEL,-1,-1);
                                    proto_processed(:,2)=resultat1;
                                    //j > 2, all my other process
                                else
                                    [resultat1, resultat2] = process_data(proto_preprocessed(:,2), -1, k+1, -1);
                                    proto_processed(:,2)=resultat1;
                                end
                            
                            //Prototype count bottles, nbBouteille1 gets the number of bottles counted, vide is empty
                            [nbBouteille1, vide] = count_peaks(proto_processed(:,1),proto_processed(:,2),-1,i+1, -1);
                            nbProto = length(nbBouteille1);
                            csvData{5,CurrentLine}= string(nbProto);
                            
                            //Reference sensor count bottles, nbBouteilleRef1 gets the number of bottles counted by the Sick sensor while nbBouteilleRef2 is for the antenna sensor
                            [nbBouteilleRef1, nbBouteilleRef2] = count_peaks(ref(:,1),ref(:,2),ref(:,3),i+1, -1);
                            nbRef1 = length(nbBouteilleRef1);
                            nbRef2 = length(nbBouteilleRef2);
                            csvData{6,CurrentLine}= string(nbRef1);
                            csvData{7,CurrentLine}= string(nbRef2);
                            
                            //- -   THE RATIO   -   -
                            csvData{8,CurrentLine}= string((nbProto/nbRef1+nbProto/nbRef2)*50); //formula (H5/I5+H5/J5)*100/2
                            
    //                        disp(strcat(["Ligne : " string(CurrentLine) " i : " string(i) " j : " string(j) " k : " string(k)]))
                end
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
        for i=1:NB_DATA_FILES*NB_TREATMENT*NB_DETEC*NB_PRETREATMENT+1
            disp(strcat([csvData{1,i} ";" csvData{2,i} ";" csvData{3,i} ";" csvData{4,i} ";" csvData{5,i} ";" csvData{6,i} ";" csvData{7,i} "\n"]))
            mfprintf(RESU2,strcat([csvData{1,i} ";" csvData{2,i} ";" csvData{3,i} ";" csvData{4,i} ";" csvData{5,i} ";" csvData{6,i} ";" csvData{7,i} "\n"]));
            end
        mfprintf(RESU2,'\n\n');
        mclose(RESU2);
