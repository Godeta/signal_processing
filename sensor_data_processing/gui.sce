/**
    * This file is the main file : it creates the gui and calls the "apply_algorithms.sci" file
    in order to process the data.
**/


clc;
clear;
close()

//  * get my functions
PATH = get_absolute_file_path("gui.sce");
PATH_IMAGE = PATH + "title.jpg";
chdir(PATH)
getd('lib');
// parameters
listPeakText = 'none|find_extremum|peakfinder|localmax'; //replace 'find_extremum|peakfinder' 
listFilteringText = 'none|convolution|circular convolution|median|hampel|moving average |sgolay filter |customLap |Gauss filter |fast root mean square'; // replace 'median'
NB_DATA_FILES = 5;

global dataProto
dataProto=cell(NB_DATA_FILES,1);
dataRef = cell(NB_DATA_FILES,1);

for i=1:NB_DATA_FILES //for as many data files as we have
        
        //get the data
        dataProto{i}= csvRead(PATH+'\data_compare\proto'+string(i)+'.csv',",");
        dataRef{i}= csvRead(PATH+'\data_compare\capteurs'+string(i)+'.csv',",");
    end
    
//GUI_SHOW();

// This GUI file is generated by guibuilder version 4.2.1
//////////
f=figure('figure_position',[-8,-8],'figure_size',[1552,840],'auto_resize','on','background',[33],'figure_name','Graphic window number %d','dockable','off','infobar_visible','off','toolbar_visible','off','menubar_visible','off','default_axes','on','visible','off');
//////////
handles.dummy = 0;
handles.checkPlot=uicontrol(f,'unit','normalized','BackgroundColor',[0.1,0.1,0.1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[1,1,1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.6916026,0.2281633,0.2215385,0.0907029],'Relief','default','SliderStep',[0.01,0.1],'String','Plot charts','Style','checkbox','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','checkPlot','Callback','checkPlot_callback(handles)')
handles.listPeaks=uicontrol(f,'unit','normalized','BackgroundColor',[0.1,0.1,0.1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[1,1,1],'HorizontalAlignment','left','ListboxTop',[1],'Max',[1],'Min',[0],'Position',[0.0349359,0.1781633,0.2964744,0.1407029],'Relief','default','SliderStep',[0.01,0.1],'String',listPeakText,'Style','listbox','Value',[1],'VerticalAlignment','middle','Visible','on','Tag','listPeaks','Callback','listPeaks_callback(handles)')
handles.title=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.3516346,0.9024943,0.2996795,0.0952381],'Relief','default','SliderStep',[0.01,0.1],'String','title.jpg','Style','image','Value',[1,1,0,0,0],'VerticalAlignment','middle','Visible','on','Tag','title','Callback','title_callback(handles)')
handles.vectorEntry=uicontrol(f,'unit','normalized','BackgroundColor',[0.2,0.6,0.8],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[1,1,1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.3884936,0.5716326,0.2259615,0.138322],'Relief','default','SliderStep',[0.01,0.1],'String','[1/3 1/3 1/3]','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','vectorEntry','Callback','')
handles.listFilters=uicontrol(f,'unit','normalized','BackgroundColor',[0.1,0.1,0.1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[1,1,1],'HorizontalAlignment','left','ListboxTop',[1],'Max',[1],'Min',[0],'Position',[0.0349359,0.560907,0.2964744,0.1497732],'Relief','default','SliderStep',[0.01,0.1],'String',listFilteringText,'Style','listbox','Value',[1],'VerticalAlignment','middle','Visible','on','Tag','listFilters','Callback','listFilters_callback(handles)')
handles.checkPdata=uicontrol(f,'unit','normalized','BackgroundColor',[0.1,0.1,0.1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[1,1,1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.6916026,0.647483,0.2215385,0.0975057],'Relief','default','SliderStep',[0.01,0.1],'String','Plot processed data','Style','checkbox','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','checkPdata','Callback','checkPdata_callback(handles)')
handles.checkFilterCreation=uicontrol(f,'unit','normalized','BackgroundColor',[0.1,0.1,0.1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[1,1,1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.6916026,0.5445125,0.2215385,0.0770975],'Relief','default','SliderStep',[0.01,0.1],'String','Create filter','Style','checkbox','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','checkFilterCreation','Callback','checkFilterCreation_callback(handles)')
handles.textFilter=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Impact','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.0632051,0.7460317,0.2399359,0.0766893],'Relief','default','SliderStep',[0.01,0.1],'String','Filtering','Style','text','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','textFilter','Callback','')
handles.textPeak=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Impact','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.0632051,0.3579365,0.2399359,0.0766893],'Relief','default','SliderStep',[0.01,0.1],'String','Detection of the peaks','Style','text','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','textPeak','Callback','')
handles.credit=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[10],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.7380769,0.0045351,0.2591026,0.0294785],'Relief','default','SliderStep',[0.01,0.1],'String','Réalisé par Arnaud GODET 12/2022','Style','text','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','credit','Callback','')
handles.textVector=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Impact','FontSize',[16],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.3815064,0.7460317,0.2399359,0.0766893],'Relief','default','SliderStep',[0.01,0.1],'String','Convolution vector','Style','text','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','textVector','Callback','')
handles.startButton=uicontrol(f,'unit','normalized','BackgroundColor',[0.1,0.1,0.1],'Enable','on','FontAngle','normal','FontName','Verdana','FontSize',[18],'FontUnits','points','FontWeight','normal','ForegroundColor',[1,1,1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.3532372,0.1020408,0.2964744,0.0952381],'Relief','default','SliderStep',[0.01,0.1],'String','Press to start','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','startButton','Callback','startButton_callback(handles)')
handles.checkCSV=uicontrol(f,'unit','normalized','BackgroundColor',[0.1,0.1,0.1],'Enable','on','FontAngle','normal','FontName','Verdana','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[1,1,1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.4003906,0.2372035,0.2215385,0.0773783],'Relief','default','SliderStep',[0.01,0.1],'String','Generate CSV','Style','checkbox','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','checkCSV','Callback','checkCSV_callback(handles)')


f.visible = "on";


//////////
// Callbacks are defined as below. Please do not delete the comments as it will be used in coming version
//////////

function checkPlot_callback(handles)
    disp(get(handles.checkPlot,"value"));
endfunction

//on click on the list of peak 
function listPeaks_callback(handles)
    choice = get(handles.listPeaks, "value");
    //if we choose something else than "none"
    if (choice >1) then
            
      for i=1:NB_DATA_FILES //for as many data files as we have
        
        //get the data from our table
        proto= dataProto{i};
        ref= dataRef{i};
        //disp(dataProto{i}(:,2))
        //apply peak detection algorithm
        // nbBouteille1 gets the number of bottles counted, vide is empty
        [nbBouteille1, vide] = count_peaks(proto(:,1),proto(:,2),-1,choice, get(handles.checkPlot,"value"));
        //nbBouteilleRef1 gets the number of bottles counted by the Sick sensor while nbBouteilleRef2 is for the antenna sensor
        [nbBouteilleRef1, nbBouteilleRef2] = count_peaks(ref(:,1),ref(:,2),ref(:,3),choice, get(handles.checkPlot,"value"));
        
        //display results in prompt
        disp("Nombre bouteilles du fichier prototype "+string(i)+" -> "+string(length(nbBouteille1)) );//+ " taille des données : "+ string(length(proto(:,2))));
        disp("Nombre bouteilles du fichier de réference "+string(i)+" Sick  -> "+string(length(nbBouteilleRef1))+" Antenne  -> "+string(length(nbBouteilleRef2)) );//+ " taille des données : "+ string(length(ref(:,2))));
        end
    end
endfunction


function title_callback(handles)
//Write your callback for  title  here
endfunction



function listFilters_callback(handles)
    choice2 = get(handles.listFilters, "value");
    //if we choose something else than "none"
    if (choice2 >1) then
            
      for i=1:NB_DATA_FILES //for as many data files as we have
        
        //get the data
        proto= csvRead(PATH+'\data_compare\proto'+string(i)+'.csv',",");
        ref= csvRead(PATH+'\data_compare\capteurs'+string(i)+'.csv',",");
        
        //apply peak detection algorithm
            
        //when we check the create filter box It will make a linear convolution using the text inside our vectorEntry box 
        if(get(handles.checkFilterCreation,"value")) then
            //when whe chose circular convolution
            if (choice2==3) then
                [resultat1, resultat2]= circ_convolution_process(proto(:,2), evstr(get(handles.vectorEntry,"String")),-1,get(handles.checkPdata,"value"));
                dataProto{i}(:,2)=resultat1;
            else //linear convolution
               [resultat1, resultat2]= convolution_process(proto(:,2), evstr(get(handles.vectorEntry,"String")),-1,get(handles.checkPdata,"value"));
                dataProto{i}(:,2)=resultat1;
               //disp(dataProto{i}(:,2))
                //disp(get(handles.checkPlot,"value"))
            end
        else
            [resultat1, resultat2] = process_data(proto(:,2), -1, choice2, get(handles.checkPdata,"value"))
            dataProto{i}(:,2)=resultat1;
            end
        
        
    end
    else 
        //if we choose the first one which is "none"
    end
endfunction

function checkPdata_callback(handles)
//Write your callback for  checkPdata  here

endfunction


function checkFilterCreation_callback(handles)
//Write your callback for  checkFilterCreation  here
disp(get(handles.checkFilterCreation,"value"));
disp(evstr(get(handles.vectorEntry,"String")))
//disp(dataProto{i}(:,2))
endfunction

function startButton_callback(handles)
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
endfunction


function checkCSV_callback(handles)
//Write your callback for  checkCSV  here

endfunction


