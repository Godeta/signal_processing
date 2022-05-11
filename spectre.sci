//signal sinus de 100 hz
clear; clf();

//paramètres signal temporel
f=100; //fréquence
T=1/f; //période 
pas = T/100;
t=0:pas:4*%pi;
s=sin(2*%pi*f*t)+sin(2*%pi*130*t);

//signal temporel
subplot(211)
plot(t(1:300),s(1:300)) //ajustement du temps
xtitle("Signal temporel")

//Composantes fréquentielles d'un signal contenant une fréquence pures à 100Hz
N = size(t,'*'); // nombre d'échantillons

y = 1/N*fft(s);
// y est symétrique, on ne garde que  N/2 points
f = 1/pas*(0:N-1)/N;  // vecteur de fréquences associé
n = size(f,'*')

//spectre en fréquence
subplot(212)
zoom = 16
plot2d('nl',f(1:n/zoom), 2*abs(y(1:n/zoom))); //nl affichage logarithmique
xtitle("Spectre en fréquences")

//wfir_gui
