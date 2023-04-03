/**
In this file I will put all functions related to the preprocessing of the data

**/
//clc;
//clear;

MAX_DIST = 600; // maximum distance that we allow our sensor to measure

/**
    Find the data considered as irregular (less than 2cm or more than half the max) and smooth it with the average of the two last values
    If the value is over 60cm we put it at 60 as a roof
**/
function data = smoothIrregular(raw)
    data = raw
     for i = 3:prod(size(raw)) //loop through all the data
            if(raw(i)<20 || raw(i)>MAX_DIST/2)
                data(i)=(data(i-2)+data(i-1))/2;
            end
            if(data(i)>MAX_DIST | isnan(data(i)))
                data(i)=MAX_DIST;
                end
        end
endfunction

//Exemple
//PATH = "C:\devRoot\data\signal_processing\sensor_data_processing";
//ref = csvRead(PATH+'\data_compare\proto1.csv',",");
////ref = csvRead('C:\devRoot\data\tests_uniformes\rouge_compo_4_REF.csv',",");
//dat = ref(:,2); //transposée car opération prévue pour une matrice en colonne
//new = smoothIrregular(dat);
//w=gca();
//plot(dat, 'blue');
//plot(new, 'red');      // plot peaks
//legend("raw data", "preprocessed data");

/**
    Interpolation of a set of points to smooth the data
**/
function data = smoothData(time1, raw, power)
    time = unique(time1(2:$));
    dat = raw(1:prod(size(time))); //limit data size
    dat(isnan(dat))=MAX_DIST;
    dat=smooth([time';dat'],power)(2,:);
    TAILLE = prod(size(raw));
    data = ones(1,TAILLE)*600;
    for i=1:prod(size(dat))
        data(i)=dat(i);
    end
    data = data';
endfunction

//Exemple
//PATH = "C:\devRoot\data\signal_processing\sensor_data_processing";
//ref = csvRead(PATH+'\data_compare\proto1.csv',",");
////ref = csvRead('C:\devRoot\data\tests_uniformes\rouge_compo_4_REF.csv',",");
//dat = ref(:,2);
//t = 1:prod(size(dat));
//new = smoothData(t',dat, 5); //using generated time
//other = smoothData(ref(:,1),dat, 100); // using the real data time
//w=gca();
//plot(dat, 'blue');
//plot(new, 'red');      
//plot(other, 'black');
//legend("raw data", "preprocessed data gen", "preprocessed data real");

/**
    Put all the unwanted data in a roof : over 60cm, undefined or 0
    Since we look at the local minimums this will allow us to avoid mistakes from incoherent data
**/
function data = cutIrregular(raw)
      for i = 3:prod(size(raw))
    if(raw(i)>MAX_DIST | isnan(raw(i)) | raw(i)==0) then
        raw(i)=MAX_DIST;
        end
   end
    data = raw;
endfunction

//Exemple
//PATH = "C:\devRoot\data\signal_processing\sensor_data_processing";
//ref = csvRead(PATH+'\data_compare\proto11.csv',",");
////ref = csvRead('C:\devRoot\data\tests_uniformes\rouge_compo_4_REF.csv',",");
//dat = ref(:,2); //transposée car opération prévue pour une matrice en colonne
//new = cutIrregular(dat);
//w=gca();
//plot(dat, 'blue');
//plot(new, 'red');      // plot peaks
//legend("raw data", "preprocessed data");

/**
    Process the data using the detected values of our prototype as well as the raw distance
    With this we will only keep the data around the detected = true, set all the rest to 600 and then process our data
**/

function data = smartPreProcess(raw, detec)
    raw(isnan(detec) | detec<1)=600; //if the distance value is not considered as detected then we put it to 600
    data = cutIrregular(raw);
endfunction

//Exemple
//PATH = "C:\devRoot\data\signal_processing\sensor_data_processing";
//ref = csvRead(PATH+'\data_compare\proto5.csv',",");
////ref = csvRead('C:\devRoot\data\tests_uniformes\rouge_compo_4_REF.csv',",");
//dat = ref(:,2); //transposée car opération prévue pour une matrice en colonne
//new = smartPreProcess(dat, ref(:,5));
//w=gca();
//plot(dat, 'blue');
//plot(new, 'red');      // plot peaks
//legend("raw data", "preprocessed data");
//figure()
//deriv = diff(new)
//stuff = new(deriv>-1 & deriv<1)
//plot(stuff)

/*
PATH = "C:\devRoot\data\signal_processing\sensor_data_processing";
ref = csvRead(PATH+'\data_compare\prot1.csv',",");
ref2 = csvRead(PATH+'\data_compare\prot2.csv',",");
//ref = csvRead('C:\devRoot\data\tests_uniformes\rouge_compo_4_REF.csv',",");
dat = ref(:,2); //transposée car opération prévue pour une matrice en colonne
//new = smoothIrregular(dat);
w=gca();
plot(ref(:,6), ref(:,5), ref(:,6),dat );
//plot(new, 'red');      // plot peaks
legend("detec","raw data");
figure()
plot(ref2(:,6), ref2(:,5), ref2(:,6),ref2(:,2) );
legend("detec","raw data");
