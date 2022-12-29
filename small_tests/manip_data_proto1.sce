clf(); clear;

//Importation des données
data = read('C:\devRoot\data\proto_data_1.dat',6124, 5);
//La première colonne correspond au temps
t = data(:,1);
//La deuxième colonne correspond aux distances brutes
distB = data(:,2);
//La troisième colonne correspond aux distances moyennes
distM = data(:,3);

//La 5ème colonne correspond à détection ou non
detec = data(:,5);
subplot(211);
title("Graphique données prototype");
//Tracé de la distance brute en fonction du temps , option 'k+' pour avoir des marqueurs noirs en forme de croix verticale.
plot(t,detec,'b');
//Nom des axes
xlabel('temps (unix)');
ylabel('Distance brute (mm)');

//Importation des données
capteurRef = read('C:\devRoot\data\capteurs_data.dat',4303, 3);
//La première colonne correspond au temps
t = capteurRef(:,1);
//La deuxième colonne correspond aux Volt Sick
sick = capteurRef(:,2);
//La troisième colonne correspond aux Volt Antenne
antenne = capteurRef(:,3);
subplot(212);
title("Graphique données oscilloscope");
plot(t,sick,'b',t,antenne,'r');
//Nom des axes
xlabel('temps (unix)');
ylabel('Tension (V)');
