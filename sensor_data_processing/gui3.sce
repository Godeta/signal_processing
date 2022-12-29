// This GUI file is generated by guibuilder version 4.2.1
//////////
f=figure('figure_position',[400,50],'figure_size',[640,480],'auto_resize','on','background',[33],'figure_name','Graphic window number %d','dockable','off','infobar_visible','off','toolbar_visible','off','menubar_visible','off','default_axes','on','visible','off');
//////////
handles.dummy = 0;
handles.checkPlot=uicontrol(f,'unit','normalized','BackgroundColor',[0.1,0.1,0.1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[1,1,1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.1194551,0.1081633,0.2019231,0.0907029],'Relief','default','SliderStep',[0.01,0.1],'String','Plot charts','Style','checkbox','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','checkPlot','Callback','checkPlot_callback(handles)')
handles.listPeaks=uicontrol(f,'unit','normalized','BackgroundColor',[0.1,0.1,0.1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[1,1,1],'HorizontalAlignment','left','ListboxTop',[1],'Max',[1],'Min',[0],'Position',[0.0625641,0.3092744,0.3157051,0.0907029],'Relief','default','SliderStep',[0.01,0.1],'String','find_extremum|peakfinder','Style','listbox','Value',[1],'VerticalAlignment','middle','Visible','on','Tag','listPeaks','Callback','listPeaks_callback(handles)')
handles.title=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.3974359,0.9024943,0.2996795,0.0952381],'Relief','default','SliderStep',[0.01,0.1],'String','title.jpg','Style','image','Value',[1,1,0,0,0],'VerticalAlignment','middle','Visible','on','Tag','title','Callback','title_callback(handles)')
handles.nbFile=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.4092949,0.6648526,0.2759615,0.138322],'Relief','default','SliderStep',[0.01,0.1],'String','Number of files (default : 0)','Style','edit','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','nbFile','Callback','')
handles.listFilters=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[1],'Max',[1],'Min',[0],'Position',[0.0625641,0.5103855,0.3157051,0.0907029],'Relief','default','SliderStep',[0.01,0.1],'String',["median filter" "convolution"],'Style','listbox','Value',[1],'VerticalAlignment','middle','Visible','on','Tag','listFilters','Callback','listFilters_callback(handles)')
handles.resultTable=uicontrol(f,'unit','normalized','BackgroundColor',[-1,-1,-1],'Enable','on','FontAngle','normal','FontName','Tahoma','FontSize',[12],'FontUnits','points','FontWeight','normal','ForegroundColor',[-1,-1,-1],'HorizontalAlignment','left','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.4983974,0.0068027,0.4839744,0.600907],'Relief','default','SliderStep',[0.01,0.1],'String','Table of results','Style','table','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','resultTable','Callback','resultTable_callback(handles)')


f.visible = "on";


//////////
// Callbacks are defined as below. Please do not delete the comments as it will be used in coming version
//////////



function checkPlot_callback(handles)
    set(handles.checkPlot,"value",-get(handles.checkPlot,"value"));
    //disp(get(handles.checkPlot,"value"));
endfunction


function listPeaks_callback(handles)
    choice = get(handles.listPeaks, "value");
  for i=1:5
    proto= csvRead('C:\devRoot\data\data_compare\proto'+string(i)+'.csv',",");
    ref= csvRead('C:\devRoot\data\data_compare\capteurs'+string(i)+'.csv',",");
    [nbBouteille1, nbB2] = count_peaks(proto(:,1),proto(:,2),-1,choice, get(handles.checkPlot,"value"));
    disp("Nombre bouteilles du fichier prototype "+string(i)+" -> "+string(length(nbBouteille1)) );//+ " taille des données : "+ string(length(proto(:,2))));
    [nbBouteille1, nbB2] = count_peaks(ref(:,1),ref(:,2),ref(:,3),choice, get(handles.checkPlot,"value"));
    disp("Nombre bouteilles du fichier de réference "+string(i)+" Sick  -> "+string(length(nbBouteille1))+" Antenne  -> "+string(length(nbB2)) );
    //+ " taille des données : "+ string(length(ref(:,2))));
    end
endfunction


function title_callback(handles)
//Write your callback for  title  here
endfunction



function listFilters_callback(handles)
//Write your callback for  listFilters  here

endfunction


function resultTable_callback(handles)
//Write your callback for  resultTable  here

endfunction

