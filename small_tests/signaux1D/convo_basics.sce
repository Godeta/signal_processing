/*
// A GENERALAZED CONVOLUTION COMPUTING CODE IN MATLAB WITHOUT USING MATLAB BUILTIN FUNCTION conv(x,h)
clear all
function out = conv1(x,h)
    m=length(x);
    n=length(h);
    X=[x,zeros(1,n)]; 
    H=[h,zeros(1,m)]; 
    for i=1:n+m-1
        Y(i)=0;
        for j=1:m
            if(i-j+1>0)
                Y(i)=Y(i)+X(j)*H(i-j+1);
            else
                end
            end
    end
endfunction

// User defined function to find linear convolution
function y = linearconvolve(x,h)
m = length(x);
n = length(h);
y = cell(n+m-1,1);
//Method : Using Direct Convolution Sum Formula
for i = 1:n+m-1
//    disp(i)
    conv_sum = 0;
    for j = 1:i
        if (((i-j+1) <= n)&(j <= m))
            conv_sum = conv_sum + x(j)*h(i-j+1);
        end;
    end;    
    y{j} = conv_sum;
end;
//disp(y)
endfunction

// Here is where the summation is calculated -> https://www.geeksforgeeks.org/linear-convolution-using-c-and-matlab/
function [y] = calconv(x, h)
    l1 = length(x);
    l2 = length(h);
    N = l1 + l2 - 1;
    y = cell(N,1);
    for n = 1 : N
        conv_sum = 0;
        for k = 1 : l1
            if(n - k + 1 >= 1 & n - k + 1 <= l2)
                conv_sum = conv_sum + x(k) * h(n - k + 1);
            end
        end
        y{n}=conv_sum;
    end
endfunction

u1=[1;2;4;8]; 

plot(u1,'.') // on regarde parce que c'est joli
//axis([0 100 -8 8]) // fixe la zone de traçage (un peu comme xlim, et ylim en une seule commande

u2 = [6;8];//u2 est un signal avec trois zeros, puis une rampe qui descend de 5 jusqu'à zero
plot(u2,'r')

s = conv(u1,u2); //s est la convolution de u1 avec u2
s2 = calconv(u1,u2);
plot(s,'color',[0.5 0 0.5]); //On précise la couleur en RGB: 50// rouge, 50// bleu
test =cell2mat(s2)
plot(test,'color',[0.8 0.2 0.1]);

return
*/
// User defined function to find linear convolution
function y = linearconvolve(x,h)
m = length(x);
n = length(h);
y = cell(n+m-1,1);
//Method : Using Direct Convolution Sum Formula
for i = 1:n+m-1
//    disp(i)
    conv_sum = 0;
    for j = 1:i
        if (((i-j+1) <= n)&(j <= m))
            conv_sum = conv_sum + x(j)*h(i-j+1);
        end;
    end;    
    y{j} = conv_sum;
end;
//disp(y)
endfunction


//Démonstration principe de convolution (très visuelle car appliquée sur signal de 0 avec qlq 1)
/*
u1 = zeros(100,1); // Un vecteur avec que des zeros
u1([25;40]) = 1; // on fixe la valeur de u1 à 1 pour les indices 55,128,302 et 50
u1(60)=1.5; //u1 vaut 1.5 pour l'indice 60 
u1(80) = -1; //u1 vaut -1 en 80

plot(u1,'.') // on regarde parce que c'est joli
//axis([0 100 -8 8]) // fixe la zone de traçage (un peu comme xlim, et ylim en une seule commande

u2 = [0;0;0;5;5;5;5;4;3;2;1;0];//u2 est un signal avec trois zeros, puis une rampe qui descend de 5 jusqu'à zero
plot(u2,'r')

s = conv(u1,u2); //s est la convolution de u1 avec u2
plot(s,'color',[0.5 0 0.5]); //On précise la couleur en RGB: 50// rouge, 50// bleu

figure;
clf
u1 = zeros(100,1); // Un vecteur avec que des zeros
u1([25;35;40]) = 1; // on fixe la valeur de u1 à 1 pour les indices 55,128,302 et 50
u1(60) = 1.5; //u1 vaut 1.5 pour l'indice 60 
u1(63) = -0.5;
u1(70) = -1;
u1(80) = -1; //u1 vaut -1 en 80
plot(u1,'.','DisplayName','u_1') // on regarde parceque c'est joli
u2 = [0;0;0;5;5;5;5;4;3;2;1;0];//u2 est un signal avec trois zeros, puis une rampe qui descend de 5 jusqu'à zero
plot(u2,'r','DisplayName','u_2')
s = conv(u1,u2);
plot(s,'color',[0.5 0 0.5],'DisplayName','u_1\ast u_2')
legend(gca,'show')
*/

//

//Lissage par moyenne et gauss
//test generation signal bruité puis lissage par convolution
//Avant de commencer, un peu de nettoyage
clear all; // efface toutes les variables déjà définies
clf; // ferme toutes les fenètres graphiques
N = 400;
t = linspace(-6,6,N); // créer un vecteur t avec N = 400 valeurs réparties uniforméement entre -6 et 6
u = sin(2*%pi*0.5*t); //u est un sinus de fréquence 0.5 hz
u = u + rand(1,N); // on rajoute à u une composante aléatoire (Gaussienne)

//ref = read('C:\devRoot\data\proto_data_1.dat',6124, 5);

ref = csvRead('C:\devRoot\data\tests_uniformes\bleu_compo_3_ident_lentille_base.csv',",");
u = ref(3000:20000,2);
N = length(u);
t = ref(3000:20000,1);
plot(t,u)

PetiteBoite = ones(1,11)/11; // on va moyenner sur une zone qui va de -5 à +5, soit 11 points en comptant celui du milieu.
u_m1 = conv(u,PetiteBoite); // l'argument 'same' assure que la taille du signal de sortie est la même que le signal d'entrée u
plot(u_m1); //line et plot fonctionnent un peu pareil, sauf que line évite d'avoir a utiliser "hold on' (plot efface tout par défaut), mais line a moins d'options que plot

GrosseBoite = ones(1,201)/201; //cette fois on va de -50 à +50 points.
u_m2 = conv(u,GrosseBoite,'same');
plot(t,u_m2,'color','k'); //line et plot fonctionnent un peu pareil, sauf que line évite d'avoir a utiliser "hold on', mais a moins d'options que plot

x = [-10:10];
gauss = exp(-(x/10).^2); // une forme de gaussienne d'épaisseur environ 10, soit a peu près la même chose que la petite boite
gauss = gauss / sum(gauss); // Normalisation, pour que la convolution ne change pas la valeur moyenne
u_lisse = conv(u, gauss,'same');
//plot(t,u_m1,'r');
plot(t,u_lisse, 'g');

//// -- test laplacian --
//
//// Define the size of the Laplacian matrix
//n = length(u);
//n = 50;
//// Initialize the Laplacian matrix
//L = zeros(n, n);
//
//// Set the main diagonal elements to 1
//L(1:n + 1:n^2) = -1;
//
//// Set the adjacent off-diagonal elements to -1
//L(2:n + 1:n^2 - 1) = 1;
//L(n + 1:n + 1:n^2 - n) = 1;
//// Print the Laplacian matrix
//y = zeros(n, 1);
//// Perform the convolution -> revoir https://math.stackexchange.com/questions/3878457/creating-the-1d-laplacian-matrix 
//for i = 1:n
//    y(i) = sum(L(i,:) * u(i)*1/length(u));
//end
//
//u_laplace = conv(u, y,'same');
//plot(t,u_laplace, "r");
//test = "Laplace"

// -- test Savitzky-Golay Filters -- 

u_sgolay = sgolayfilt(u, 3, 7); //sgolayfilt(u, 1, 17);
plot(t, u_sgolay, "br");
p = [3 0 0 0 0 0 0];
//y = horner(p,x);
y = sgolayfilt(x, 1, 17)/17;
test = "sgolay"


// -- test Hampel filter --

//function [data, indice] = hampel_filter_forloop(input_series, window_size, n_sigmas)
//    if(isempty(n_sigmas)) then
//    n_sigmas = 3;
//    end
//    n = length(input_series);
//    new_series = input_series;
//    k = 1.4826 // scale factor for Gaussian distribution
//    
//    indices = [0]
//    
//    for i=window_size:n-window_size
//        x0 = median(input_series((i - window_size+1):(i + window_size)))
//        S0 = k * median(abs(input_series((i - window_size+1):(i + window_size)) - x0))
//        if (abs(input_series(i) - x0) > n_sigmas * S0) then
//            new_series(i) = x0
//            cat(indices,i);
//            end
//    end
//    data= new_series;
//    indice = indices;
//endfunction
//[u_hampel,ind] = hampel_filter_forloop(u, 10, 3);
//plot(t, u_hampel, "r");
//y = ind;
//test = "Hampel"

legend("Original","Moyenne petite ouverture", "Moyenne grande ouverture", "Gauss petite ouverture", test);

//visualiser les filtres appliqués
figure;
title("Affichage des filtres")
plot(gauss, "r")
plot(PetiteBoite,"b")
plot(GrosseBoite)
plot(y,"y")

legend("Gauss","Petite boite", "Grande boite", test);


