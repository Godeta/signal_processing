/**
    * This file generates a CSV file with all the data processed by the different functions we can try with the GUI
**/

// --- CLEAR SCILAB SPACE ---
clc;
clear;
close()

//  --- GET MY FUNCTIONS ---
PATH = get_absolute_file_path("gui.sce");
PATH_IMAGE = PATH + "title.jpg";
chdir(PATH)
getd('lib');

// --- PARAMETERS ---
NB_DATA_FILES = 5;
global dataProto
dataProto=cell(NB_DATA_FILES,1);
dataRef = cell(NB_DATA_FILES,1);

for i=1:NB_DATA_FILES //for as many data files as we have
        
        //get the data
        dataProto{i}= csvRead(PATH+'\data_compare\proto'+string(i)+'.csv',",");
        dataRef{i}= csvRead(PATH+'\data_compare\capteurs'+string(i)+'.csv',",");
    end

// --- CSV GENERATION PROGRAM ---

//The start button will launch our test based on our parameters. It can also generate a CSV file with the result data.
    csvData=cell(3,NB_DATA_FILES+1);
//----- first we take the filtered data
    choice2 = get(handles.listFilters, "value");
    //if we choose something else than "none"
    if (choice2 >1) then
            
      for i=1:NB_DATA_FILES //for as many data files as we have
        
        //get the data
        proto= csvRead(PATH+'\data_compare\proto'+string(i)+'.csv',",");
        ref= csvRead(PATH+'\data_compare\capteurs'+string(i)+'.csv',",");
        
        //apply data processing
        if(get(handles.checkFilterCreation,"value")) then
            [resultat1, resultat2]= convolution_process(proto(:,2), evstr(get(handles.vectorEntry,"String")),-1,get(handles.checkPdata,"value"))
            dataProto{i}(:,2)=resultat1;
            end
    end
end

//----- then we aply our peak detection algorithm
    choice = get(handles.listPeaks, "value");
    
    //initialiser les 2 premières lignes du tableau csv
    csvData{1,1}= "Nb bouteilles prototype";
    csvData{2,1}= "Nb bouteilles Sick";
    csvData{3,1}= "Nb bouteilles antenne";
    //if we choose something else than "none"
    if (choice >1) then
            
      for i=1:NB_DATA_FILES //for as many data files as we have
        
        //get the data from our table
        proto= dataProto{i};
        ref= dataRef{i};
        //apply peak detection algorithm
        // nbBouteille1 gets the number of bottles counted, vide is empty
        [nbBouteille1, vide] = count_peaks(proto(:,1),proto(:,2),-1,choice, get(handles.checkPlot,"value"));
        //nbBouteilleRef1 gets the number of bottles counted by the Sick sensor while nbBouteilleRef2 is for the antenna sensor
        [nbBouteilleRef1, nbBouteilleRef2] = count_peaks(ref(:,1),ref(:,2),ref(:,3),choice, get(handles.checkPlot,"value"));
        
        //display results in prompt
        //disp("Nombre bouteilles du fichier prototype "+string(i)+" -> "+string(length(nbBouteille1)) );//+ " taille des données : "+ string(length(proto(:,2))));
        //disp("Nombre bouteilles du fichier de réference "+string(i)+" Sick  -> "+string(length(nbBouteilleRef1))+" Antenne  -> "+string(length(nbBouteilleRef2)) );//+ " taille des données : "+ string(length(ref(:,2))));
        
        //ajouter les résultats au tableau de données CSV
        csvData{1,i+1}= string(length(nbBouteille1));
        csvData{2,i+1}= string(length(nbBouteilleRef1));
        csvData{3,i+1}= string(length(nbBouteilleRef2));
        end
    end

//----- if CSV is checked It will generate a file in which we have our results.
    if(get(handles.checkCSV,"value")) then
        printf("\n");
        printf("############################################################################\n")
        printf(" Saving the result in a .cvs file \n")
        printf("############################################################################\n")
        printf("\n");
        RESU2 = mopen(PATH + "data_output" + ".csv",'w') ;
        for i=1:NB_DATA_FILES+1
            disp(strcat([csvData{1,i} ";" csvData{2,i} ";" csvData{3,i} "\n"]))
            mfprintf(RESU2,strcat([csvData{1,i} ";" csvData{2,i} ";" csvData{3,i} "\n"]));
            end
        mfprintf(RESU2,'\n\n');
        mclose(RESU2);
        
    end
