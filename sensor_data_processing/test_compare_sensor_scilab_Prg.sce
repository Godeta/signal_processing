/**
    This file is made of different tests to compare the results I got using Scilab to what I have using my C program in the sensor.
    There are 3 different steps to compare : the preprocessing, the process and the peak finding algorithm.
    All the data used for this will be put in a specific folder named "scilab_sensor_compare_data"

**/
    clear;
    clc;

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
    
    for i=1:20
        close()
    end
    //test données, en 2 version prepro et 3 données brutes
    prot=csvRead(PATH+P_PROTO+string("4_prepro_normal")+".csv",",");
    prepro = prot(:,2);
    brut = prot(:,3);
    sciPrepro = smoothIrregular(brut);
    
    lgth = length(brut);
    plot(1:lgth,prot(:,3),1:lgth,prepro,1:lgth,sciPrepro);
    legend("raw","sensor", "scilab");

    
//    refe=csvRead(PATH+P_REF+string(1)+".csv",",");
//    result = count_cylinders(refe(:,2))
//    disp(result)
//    plot(refe(:,2))
//    figure()
    
    
//    //sans scilab
//    new = prot(:,2);
    result1 = cutIrregular(prot(:,3));
//    
    //avec scilab
    //new = smoothIrregular(prot(:,2));
    result1 = gaussFilter(result1,11);
    figure();
    xtitle("Filtre gaussien sur le signal du capteur");
    plot(result1)
    
//   trace tangent line
//    figure()
//    t=1:length(result1)
//    t=t'
//    plot(t,result1)
//    xtitle("b")
//    dy=diff(result1)./diff(t)
//    k=1169; // point number 220
//    tang=(t-t(k))*dy(k)+result1(k)
//    plot(t,tang)
//    scatter(t(k),result1(k))
//    disp(length(peakfinder(result1,20,500,-1,1)));
//    disp(length(peakfinder(result1,0.9,2,1,1)));
//    disp(count_cylinders(prot(:,3)))
    
    //Circular Queue
    global CQ;
    
    return
    //filtering using gauss parabola, full convolution
function result = gaussCumulativeSum(data, sizeOf)
    global CQ;
    x = [-sizeOf:sizeOf];
   gauss = exp(-(x/sizeOf).^2); // une forme de gaussienne d'épaisseur environ 10, soit a peu près la même chose que la petite boite
   gauss = gauss / sum(gauss); // Normalisation, pour que la convolution ne change pas la valeur moyenne
   resultat =0;
   prev =0;
    //equivalent a mon appel de ma fonction de récup des données sur mon capteur
    for i=1:length(data)
        //pour chaque valeur de mon noyau
            for j=1:length(x)
                    resultat = resultat + data(i)*gauss(modulo(i,length(x))+1) - prev * gauss(modulo(i-1,length(x))+1);
                end
        result(i)= resultat;
//        disp(data(i)*gauss(modulo(i,length(x))+1))
    end
//    disp(size(result));
endfunction
    result2 = cutIrregular(prot(:,3));
    result2(1)=600;
    result2 = gaussCumulativeSum(result2,11);
    figure();
    xtitle("Filtre gaussien cumulatif sur le signal du capteur");
    plot(result2)
    return

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

//filtering using gauss parabola, full convolution
function result = gaussFilter2(data, sizeOf)
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
    result = conv(data, gauss,'valid');
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
    
    //test Gauss
    PADDING = 12;
    processed = gaussFilter2(prepro, PADDING/2);
    lgth = length(processed);
    sciPro = gaussFilter2(sciPrepro, PADDING/2);
    
//    plot(1:lgth,processed,1:lgth,sciPro);
//    legend("sensor processed","scilab processed");
    //test Gauss par intervalles
//    p1 = gaussFilter2(prepro(1:21), 11);
//    p2 = gaussFilter2(prepro(22:44), 11);

//    //tentative restituer mon gauss en temps réel (un gauss "full" par intervalles ne fonctionne pas)
//    figure();
//    c = 1;
//    p = [];
//    for i=1:PADDING-1:length(prepro)-PADDING
////       p(c) = gaussFilter2(prepro(i:i+PADDING), PADDING/2);
////       c=c+1;
//    p=cat(1,p,gaussFilter2(prepro(i:i+PADDING), 11));
//    end
////    plot2d(p(:,15))
//    plot2d(p);
//    xtitle("Somme convolution valide")
    
    //lorsque l'on diminue la résolution on a des résultats très intéressants MAIS : si une bouteille arrête de bouger alors on va la détécter plusieurs fois...
    //possibilité de faire quelque chose en le combinant avec detec ou pas ? -> on retrouve soucis de 2 bouteilles côtes à côtes
    c = 1;
    for i=1:PADDING-1:length(prepro)-PADDING
       q(c) = prepro(i)
       c=c+1;
    end
    figure();
    plot(q)
    xtitle("Résolution diminuée")
    
    peakfinder(q,300,500,-1,1)
    
    //detection pics sur résolution diminuée : on récupère toutes les variations de signe puis on enlève celles qui sont incohérentes (inf 2* le min)
    pic = []
    m=min(q)
    for i=2:length(q)-1
        if(q(i-1)>q(i) && q(i+1)>q(i)) then
//            disp(q(i));
            if(q(i)<4*m) then 
//                disp("ok")
                    pic=cat(1,pic,q(i));
                end
        end
    end
    
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

////test detection extremum
//    val = length(peakfinder(processed,10,500,-1,1));
//    xtitle("Processed min "+string(val))
//    val = length(peakfinder(processed,0.9,2,1,1));
//    xtitle("Processed max "+string(val))
//    
//    val = length(peakfinder(sciPrepro,10,500,-1,1));
//    xtitle("Scilab processed min "+string(val))
//    val = length(peakfinder(sciPrepro,0.9,2,1,1));
//    xtitle("Scilab Processed max "+string(val))
    
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



/**
NOTE

2 DIFFERENT APPROACHES 
-> interval based gaussian convolution with cut-off
-> cumulative sum with convolution

-   -   -   -   First one -   -   -   -

Gauss full convolution with a small kernel (9 values) and a bigger set of points (21 values)
void gauss(int points[NB_PTS+NB_KERNEL-1], int ind) {
//	/* GAUSS
		int l = NB_PTS+NB_KERNEL - 1;
		int n, k = 0;
		int y[NB_PTS];

		for(int a=0; a<NB_PTS; a++){
			y[a]=points[a];
			points[a]=0;
		}

		for (n = 0; n < l; n++) {
//			y[n] = 0;
			points[n]=0;
			for (k = 0; k < NB_PTS; k++) {
//				//copy the point values during the first loop
//				if(n==0) {
////					y[k]=points[k];
//					y[NB_PTS]=points[NB_PTS];
//					y[(k+ind)%NB_PTS]=points[(k+ind)%NB_PTS];
//				}
				// To right shift the impulse
				if ((n - k) >= 0
					&& (n - k) <= NB_KERNEL-1) {

					// Main calculation
					points[n] = points[n] + y[(k+ind)%NB_PTS] * gaussKernel9[n - k];
//					points[n] = points[n] + y[(k+ind)%NB_PTS] * avgKernel[n - k];
//					points[n] = y[k];
//					points[n] = points[n] + y[k] * avgKernel[n - k];
				}
			}
		}
	}

int findPeak(int points[NB_PTS]) {
	for (int i=1; i<NB_PTS-1;i++) {
		if(prevPeak ==1) { //peak detected, we search for the outside
			if(points[i]>DIST_MIN_PEAK && points[i]<DIST_MIN_OUT) {
//				return points[i];
				serial_debug_printf("Val : %d  \r\n", points[i]);
				prevPeak =0;
				return 0;
			}
		}
		else { //seach for peak
			//précédent > actuel et actuel < suivant
					if(points[(i-1)]>points[i] && points[(i+1)]>points[i] && points[i]<DIST_MIN_PEAK){
						prevPeak =1;
						return points[i];
					}

		}
	}
	return 0;
}

Start of the process
	points[ind]= vl53l1x_get_distance();
	detec[ind]= mcp4911_getOutputValue(&mcp4911_cfg);
	//serial_debug_printf("indice : %d\r\n", ind);

	ind++;
	//Once our table is full
	if(ind >= NB_PTS){
		//apply preprocessing on the data
			preProcess(points, detec);
Apply Gauss :
			for(int i=0; i<NB_PTS; i++) {
				pointsPro[i]=points[i];
			}
		//apply gauss filter
			gauss(pointsPro,ind);
Send the data :
            for (int i=NB_KERNEL-1; i<NB_PTS-1;i++) {//cuting off wrong points
				serial_debug_printf("%d\r\n", pointsPro[i]);
			}
Count peaks :
		//search peak
		 //max 2 peak in an interval ? result 0 1 2
//			int peak = findPeak(points);
			//if we found a peak
//			if(peak>0 && peak != prevPeak){
//			if(peak>0){
//				nbCylinder++;
////				prevPeak = peak;
//				serial_debug_printf("Nouveau pic : %d Nombre total : %d \r\n", peak, nbCylinder);
//			}
//

-   -   -   -   Second one -   -   -   -
1 value at a time we accumulate the weigth * value without forgeting to reset
Order : (i + k)%total -> k is the place we are supposed to get, i is our current place
 val = sum - oldVal*oldWeigth + newVal* newWeigth
