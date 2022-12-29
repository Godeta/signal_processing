clc;
clear;

//Acquisition des données audio
PATH = get_absolute_file_path("recons_signal.sce");
dataPath = PATH+"violin.wav";
/*
[SonStereo Fe] = wavread(dataPath); //Fe est la fréquence d'échantillonnage (44100 Hz est une fréquence souvent utilisée pour les fichiers sonores)
[y,Fs,bits]=wavread(dataPath);Fs,bits
subplot(2,1,1)
plot2d(y(1,:)) // first channel
subplot(2,1,2)
plot2d(y(2,:)) // second channel
*/
[SonStereo, Fe, bits] = wavread(dataPath);
SonMono = SonStereo(1,:); // SonStereo a deux colonnes car le son a été enregistré sur deux voies. Ne prenez que la première voie.
N = length(SonMono); // le nombre de points du signal
Te = 1 / Fe; // durée entre deux échantillons
// définition de la phase (vecteur colonne)

t = [0:Te:(N-1)*Te]; // temps (part de 0, avance de Te en Te, et contient N points
plot(t,SonMono); //tracé de l'amplitude du HP en fonction du temps
figure;
Freq = [0:N-1]/(N*Te); //l'espace des fréquences

tf = fft(SonMono);
theta=atan(tf);
//limit = 50000;
lim = 10000
a=0; i=0;
while a < 1
    i=i+1;
    if(Freq(i)>lim) then
        limit = i;
        a = 1
        end
end
//représentation fréquentielle
subplot(211)
title("Graphique amplitude : ");
plot(Freq(1,1:limit), abs(tf(1,1:limit)),'k') // tracé de l'amplitude en fonction de la fréquence
subplot(212)
title("Graphique phase : ");
plot(Freq(1,1:limit), theta(1,1:limit),'r') // tracé de la phase en fonction de la fréquence

//Modification du spectre
tf2 = tf;// On commence par copier la tf originale
A_modifier = (abs(tf) < 50); // A_modifier est un tableau de 0(non) ou 1(oui) qui indique les indices à modifier dans le tableau tf
tf2(A_modifier) = 0; // On met à zero les composantes de faible amplitude.
// On représente notre modification

//figure();
/*
clf; //Nettoyage de la figure courante
plot(Freq,abs(tf),'k') // L'originale

plot(Freq,abs(tf2),'r') // La copie modifiée
*/
//Reconstitution du signal temporel
son2 = ifft(tf2); //TF inverse: retour dans l'espace temporel
clf; //Netttoyage de la figure courante
plot2d(t,SonMono,13, rect=[0 -1 1 1])

plot2d(t,son2,12, rect=[0 -1 1 1])
//xlim([0 1]) // on ne regarde que ce qui se passe pendant la première seconde.
xlabel('temps (s)')
ylabel('amplitude')

sound(son2,Fe);
