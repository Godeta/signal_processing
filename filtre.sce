clf();
clear;

fcoup=10; //fréquence de coupure
ordre=2;  // modifier l ordre et observez l evolution du gain et de la phase

filtre=  analpf(ordre, "butt", [0 0], fcoup*2*%pi);  // 2*pi*f -> omega, pulsation/s
[fr, hf]= repfreq(filtre, 0, fcoup*5);
[db, phi]= dbphi(hf); //séparer amplitude et phase en prenant module et argument

//affichage des réponses du filtre
subplot(3,1,1);
plot("ln", fr(45:length(fr)-1),db(45:length(db)-1),'r');
xtitle("Réponse du module (amplitude)");

subplot(3,1,2);
plot("ln",fr(45:length(fr)-1), phi(45:length(phi)-1), 'g');
xtitle("Réponse de l argument (phase)");

//  analogique  ->  temps
Te=1/(fcoup*50);  // temps d échantillonnage pour creer des pseudos signaux continus
temps = Te*(0:511);  // vecteur temps, axe horizontal -> fréquence echantillonage * nombre de points

// les coef 1 servent à modifier le signal total
// utilisez plusieurs valeurs

sa= 1*sin(2*%pi*(fcoup/2)*temps); //  sa = A sin(wt)  avec w = 2 pi f
sb= 1*sin(2*%pi*(fcoup)*temps);
sc= 1*sin(2*%pi*(fcoup*2)*temps);

s = sa + sb ;

y = csim(sb, temps, filtre);  // simulation temporelle

subplot(3,1,3);
plot(temps, [sb' y']); // affichage d'un des signaux et de l'autre filtré
xtitle("Réponse complète avec echantillonage");
