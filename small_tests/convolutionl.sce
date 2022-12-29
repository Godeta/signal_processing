
ref =  csvRead('C:\devRoot\data\tests_uniformes\rouge_compo_3_ident_lampe.csv',","); // données du prototype très bruitées
//ref = csvRead('C:\devRoot\data\tests_uniformes\rouge_compo_3_ident_lampe_REF.csv',","); // données capteur de référence

//ref = read('C:\devRoot\data\proto_data_2.dat',7012, 5); //données proto plutôt propres
//ref = csvRead('C:\devRoot\data\proto_data_3.csv',",");
//ref = csvRead('C:\devRoot\data\capteurs_data_3.csv',","); // données des capteurs de référence
data = [ref(:,1) ref(:,2)]

//x = [2 1 2 1];
//y = 1/3*[1 2 1];
//y = [-1 0 1];
//y = [1 -1 1] //detection 
//y = [ 0 1 0 1 -4 1 0 1 0] // filtre Laplacien detection contour https://fr.wikipedia.org/wiki/Noyau_(traitement_d'image)
//y = [0 -1 0 -1 5 -1 0 -1 0] // filtre réhausseur renforce contour
//y = 1/256*[1 4 6 4 1 4 16 24 16 4 6 24 36 24 6 4 16 24 16 4 1 4 6 4 1] // filtre gaussien
y = -1/256*[1 4 6 4 1 4 16 24 16 4 6 24 -476 24 6 4 16 24 16 4 1 4 6 4 1] // filtre masque flou qui accentue le pic des images
coef = 10
//y = [0 0 0 0 1 0 0 0 0]+ ([0 0 0 0 1 0 0 0 0]-[1 1 1 1 1 1 1 1 1]/coef)*coef // sharpening filter https://en.wikipedia.org/wiki/Unsharp_masking

//y = [-0.0125661  -0.0047423   0.0052415   0.0170011   0.0300105   0.0436333   0.057162 0.0698647   0.0810332   0.0900316   0.0963398   0.0995893   0.0995893   0.0963398 0.0900316   0.0810332   0.0698647   0.057162   0.0436333   0.0300105   0.0170011 0.0052415  -0.0047423  -0.0125661] // chebyshev ordre 24 pass band 50 hz
//y = [0.0372283  -0.0251997   0.0278522  -0.0503677   2.205D-17  -0.0658655  -0.0481084 -0.0587992  -0.1223217  -2.205D-17  -0.2854172   0.5291927   0.5291927  -0.2854172 2.205D-17  -0.1223217  -0.0587992  -0.0481084  -0.0658655   2.205D-17  -0.0503677 0.0278522  -0.0251997   0.0372283] // rectangle ordre 24 pass band 100 hz
//y = [-0.0540035   0.0124964  -0.0138118   0.0730636  -0.0424413   0.0023968  -0.0918923 0.1123128  -0.0044512   0.127324  -0.4140271   0.2624241   0.2624241  -0.4140271 0.127324  -0.0044512   0.1123128  -0.0918923   0.0023968  -0.0424413   0.0730636 -0.0138118   0.0124964  -0.0540035] // rectangle ordre 24 pass band 100 hz -> low 20
data1 = ref(:,2)
//y = [0 0.2 0.4 0.6 0.8 1 0.8 0.6 0.4 0.2 0]
//y = [0.0058178   0.0152432   0.0279459   0.0432177   0.0600211   0.0770718   0.09295 0.09295   0.0770718   0.0600211   0.0432177   0.0279459   0.0152432   0.0058178]
y = ffilt("bp",50,10,40)
//[y, rep, frequ] = wfir('bp', 50, [0.01,0.1],'re', [0 0])

clin = conv(data1,y);

//fast root mean square
//y = ones(1,2000)
//clin = conv(data1.^2,y)
//clin = sqrt(clin/sum(y))

    
N = length(data1);
L = length(y);
outputSize = N + L -1;

xpad = [data1' zeros(1,outputSize-N)];
ypad = [y zeros(1,outputSize-L)];
fx = fft(xpad, 1, 1)
fy = fft(ypad)
ccirc = fft(fx.*fy,-1,1);

subplot(3,1,1)
plot(ref(:,1),ref(:,2))
title('Original signal')

subplot(3,1,2)
//plot(ref(:,1),ref(:,2),"b",ref(:,1),clin(length(y):$,1),"r")
plot(ref(:,1),clin(length(y):$,1))
title('Linear Convolution of x and y     y= ['+strcat(string(y), ' ')+']')

subplot(3,1,3)
//plot(ref(:,1),ref(:,2),"b",ref(:,1),ccirc'(length(y):$,1),"r")
plot(ref(:,1),ccirc'(length(y):$,1))
title('Circular Convolution of xpad and ypad')
//val = fft(data1)
//val = fft(ccirc')
figure;
//plot(abs(val(1000:7000)/7035))
title("Le filtre")
[c, ind] = xcorr(data1, data1,60500 ,"none");
plot(ind, c)
/*
res = filter(y, 1, data1)
plot(res)
