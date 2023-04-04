/**
    This file is made of different tests to compare the results I got using Scilab to what I have using my C program in the sensor.
    There are 3 different steps to compare : the preprocessing, the process and the peak finding algorithm.
    All the data used for this will be put in a specific folder named "scilab_sensor_compare_data"

**/

/**
    test to compare the processing of raw data with scilab to the processing inside my sensor and checc If they are equal
    **/
    //  * get my functions
    PATH = get_absolute_file_path("test_compare_sensor_scilab_Prg.sce");
    P_PROTO = '\data_compare\scilab_sensor_compare_data\test_capt_pro_';
    P_REF = '\data_compare\scilab_sensor_compare_data\test_capt_pro_REF_';
    chdir(PATH)
    getd('lib');
    NB_DATA = 2;
    close(); close(); //close the windows

////    plot all data
//    for(i=1:NB_DATA)
//        
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
    
    for i=1:20
        close()
    end
    prot=csvRead(PATH+P_PROTO+string(1)+".csv",",");
    refe=csvRead(PATH+P_REF+string(1)+".csv",",");
    result = count_cylinders(refe(:,2))
    disp(result)
    plot(refe(:,2))
    figure()
    
    
    //sans scilab
    new = prot(:,2);
    result1 = prot(:,3);
    
    //avec scilab
    //new = smoothIrregular(prot(:,2));
    result1 = gaussFilter(result1,21);
    
    plot(result1)
    
    disp(length(peakfinder(result1,10,500,-1,1)));
    disp(length(peakfinder(result1,0.9,2,1,1)));
    disp(count_cylinders(prot(:,3)))

/**
-   -   -   -    C code in the sensor for the preprocessing -   -   -   -

void preProcess(int points[NB_PTS], int detec[NB_PTS]) {
	if(detec[0]<1){
						points[0]=MAX_DIST;
					}
	if(detec[1]<1){
							points[1]=MAX_DIST;
						}
	//for each element in our array
	for (int i=2; i<NB_PTS; i++) {
		if(detec[i]<1){
					points[i]=MAX_DIST;
				}
		else {
		int currentVal = points[i];
		//lower limit 20 mm, upper limit 300 mm, if we are out of this boundary we change our value
		if(currentVal<20 || currentVal>MAX_DIST/2 ) {
			points[i]=(points[i-2]+points[i-1])/2;
			}
		}
	}
	//smart preprocess using the detection false/true value
	//raw(isnan(detec) | detec<1)=600; //if the distance value is not considered as detected then we put it to 600
	  //  data = cutIrregular(raw);

}
**/

//filtering using gauss parabola
function result = gaussFilter(data, sizeOf)
    x = [-sizeOf:sizeOf];
   gauss = exp(-(x/sizeOf).^2); // une forme de gaussienne d'épaisseur environ 10, soit a peu près la même chose que la petite boite
   gauss = gauss / sum(gauss); // Normalisation, pour que la convolution ne change pas la valeur moyenne
//    n=length(gauss)
//    m=length(data)
//    X=[data,zeros(1,n)]; 
//    H=[gauss,zeros(1,m)]; 
//    for i=1:n+m-1
//     Y(i)=0;
//        for j=1:m
//            if(i-j+1>0)
//                disp(i)
//                disp(j)
//                Y(i)=Y(i)+X(j)*H(i-j+1);
//            else
//        end
//    end
//end
//     result = Y;
    //result = linearconvolve(data,gauss);
    result = conv(data, gauss,'same');
//    disp(size(result));
endfunction

/**
-   -   -   -   C code for the Gaussian convolution -   -   -   -
    void gauss(int points[NB_PTS*2-1]) {
		int l = NB_PTS+NB_PTS - 1;
		int n, k = 0;
		int y[NB_PTS*2-1];

		for (n = 0; n < l; n++) {
			y[n] = 0;
			for (k = 0; k < NB_PTS; k++) {
				//copy the point values during the first loop
				if(n==0) {
					y[k]=points[k];
				}
				// To right shift the impulse
				if ((n - k) >= 0
					&& (n - k) <= NB_PTS-1) {

					// Main calculation
					points[n] = points[n] + y[k] * gaussKernel[n - k];
				}
			}
		}

	}
**/



////calcul dérivée 
//n = length(new)-1
//for i=1:n
//    deriv(i)=new(i)-new(i+1)
//end
//plot(deriv, "red")
//
//  count = 0;
//  for i=2:n
//      if(deriv(i-1)<0 && deriv(i) >0) then
//          count=count+1;
//          ind(count)=i;
//      end
//end
//scatter(ind,deriv(ind),10,"green");
//title(string(count))

/**
-   -   -   -   C code for the peakfinder algorithm -   -   -   -

**/

/**
-   -   -   -   C code of the whole -   -   -   -
void CountNumberofCylinders(){
//	 Active if we send the command "s"
//	 * this function uses NB_POINTS defined in main.h,
//	 * If we make It bigger more points will be taken
//	  before checking if there is a bottle.
//
//	
//	  Get NB_POINTS and put them in a table
	 

	static int ind = 0;

	points[ind]= vl53l1x_get_distance();
	detec[ind]= mcp4911_getOutputValue(&mcp4911_cfg);
	//serial_debug_printf("indice : %d\r\n", ind);

	ind++;
	//Once our table is full
	if(ind >= NB_PTS){
			ind=0;
			//avant prepro
			for(int i=0; i<NB_PTS; i++) {
							pointsPro[i]=points[i];
						}
		//apply preprocessing on the data
			preProcess(points, detec);
			//for(int i=0; i<NB_PTS; i++) {
				//pointsPro[i]=points[i];
			//}
		//apply gauss filter
			//gauss(pointsPro);

			//send all points
						for (int i=0; i<NB_PTS;i++) {//*2-1
							serial_debug_printf("%d, %d\r\n", points[i], pointsPro[i]);
							//serial_debug_printf("%d\r\n", pointsPro[i]);
						}

//			
//		//search peak
//		 * max 2 peak in an interval ? result 0 1 2
//			int peak = findPeak(points);
//			//if we found a peak
//			if(peak>0){
//				nbCylinder++;
//			}
//			serial_debug_printf("Pic en : %d de valeur : %d \r\n", peak, points[peak]);
//			
	}
**/





