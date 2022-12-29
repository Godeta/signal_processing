//clc
/*
clear all
close all
//infos : https://www.mathworks.com/help/signal/ug/signal-smoothing.html
//Moving average filter:
t=0:0.11:20;
x=sin(t);
n=rand(1,length(t));
x=x+n;
a=input('Enter the no.:');
t2=ones(1,a);
num=(1/a)*t2;
den=[1];
y=filter(num,den,x);
plot(x,'b');
plot(y,'r','linewidth',2);
legend('Noisy signal','Filtered signal');
*/

/*
//Median filter:-
//signal bruité
t=0:0.01:20;
x=sin(t);
n=rand(1,length(t));
noise=[];
for i=1:length(t)
    if(n(i)>=0.95)
        noise=[noise -1.5];
    else
        noise=[noise 0];
    end
end
x=x+noise;
//filtre
z=[];
z(1) = median([0 0 x(1) x(2) x(3)]);
z(2) = median([0 x(1) x(2) x(3) x(4)]);
for i=3:length(t)-2
    z(i)=median([x(i-2) x(i- 1) x(i) x(i + 1) x(i + 2)]);
end
plot(x,'b');
plot(z,'r','linewidth',2);
legend('Noisy signal','Filtered signal');
*/

/*
//make signal and filter
//signal
t=1:200;
x1=sin(2*%pi*t/20);
x2=sin(2*%pi*t/3);
x=x1+x2;
//filter
[h,hm,fr]=wfir('lp',33,[.2 0],'hm',[0 0]);
z=poly(0,'z');
hz=syslin('d',poly(h,'z','c')./z**33);
yhz=flts(x,hz);

subplot(1,2,1)
plot(x);
subplot(1,2,2)
plot(yhz);
*/

//Radar signal processing 
/*
    Utilisation de la correlation pour de la détection d'objet
    Dans le cas d'un radar : R[n]=Alpha*X[n-D]+Noise 
    Alpha est le facteur d'atténuation = 1, D est le délais de transmission
    En présence d'un objet le signal reçu est la réflection de l'onde sur l'objet R(n) = X(n-D)+Noise. Si on trouve une corrélation entre le signal reçu et transmis alors la valeur de corrélation sera plus élevée à l'index du délais 
    En absence d'un objet R(n)=noise, la corrélation n'est pas plus forte à l'index du délais
*/
x =[0 1 2 3 2 1 0]; // T r i a n g l e p u l s e t r a n s m i t t e d by r a d a r
n =[ -3 -2 -1 0 1 2 3]; // I n d e x of T r i a n g u l a r P ul s e
D =10; // Dela y amount
nd = n+ D ; // I n d e x of D ela y e d S i g n a l
y = x ; // D ela y e d S i g n a l
scf () ;
subplot (2 ,1 ,1) ;
bar (n ,x ,0.1 , 'red') ;
title('OriginalTransmittedSignal','color','red','fontsize',4);
xlabel("Index","fontsize",2,"color","blue");
ylabel("Amplitude","fontsize",2,"color","blue");

subplot (2 ,1 ,2) ;
bar ( nd ,y ,0.1 , 'yellow') ;
title('DelayedSignal','color','red','fontsize',4);
xlabel ("I n d e x ", "f o n t s i z e ", 2 ,"c o l o r ", "blue") ;
ylabel ("Ampli tude ", "f o n t s i z e ", 2 , "c o l o r ", "blue") ;

w = rand (1 , length (x ) ) ; // Noise G e n e r a ti o n
nw = nd ;
scf () ;
bar ( nw ,w ,0.1 ,'red' ) ;
title('NoisySignal','color','red','fontsize',4);
xlabel("Index","fontsize",2,"color","blue");
ylabel("Amplitude","fontsize",2,"color","blue");

// I f o b j e c t i s p r e s e n t we r e c e i v e t h e s i g n a l R( n ) =x ( n−D) + Noise
R = y + w; // O r i g i n a l S i g n a l+Noise
nr = nw ; // I n d e x of r e c e i v e d s i g n a l a t RADAR

nr_fold = mtlb_fliplr ( nr ) ;
R_fold = mtlb_fliplr (R ) ;
nmin =min( n ) + min ( nr_fold ) ; // Lowe s t i n d e x of y ( n )
nmax =max( n ) + max ( nr_fold ) ; // Hi g h e s t i n d e x of y ( n )
n_received = nmin : nmax ;
Received_Presence = conv (x , R_fold ) ; // C o n v ol u ti o n of O r i g i n a l s i g n a l and R e c ei v e d S i g n a l i n t h e P r e s e n c e of O bj e c t ( E q u val e n t to C o r r e l a t i o n ) //

scf () ;
subplot (2 ,1 ,1) ;
bar(n_received,Received_Presence,0.1,'red');
title('CorrelationinthePresenceofObject','color','red','fontsize',4);
xlabel("Index","fontsize",2,"color","blue");
ylabel("CorrelationValue","fontsize",2,"color","blue");

// I f o b j e c t i s no t p r e s e n t we r e c e i v e t h e s i g n a l R(n ) = Noise
R = w ; // o nl y Noise S i g n a l
nr = nw ;

nr_fold = mtlb_fliplr ( nr ) ;
R_fold = mtlb_fliplr (R ) ;
nmin =min( n ) + min ( nr_fold ) ; // Lowe s t i n d e x of y( n )
nmax =max( n ) + max ( nr_fold ) ; // Hi g h e s t i n d e x of y ( n )
n_received = nmin : nmax ;
Received_Absence = conv (x , R_fold ) ; // C o n v ol u ti o n of O r i g i n a l t r a n s m i t t e d s i g n a l and R e c ei v e d S i g n a l i n t h e Ab sence of O bj e c t ( E q u val e n t to C o r r e l a t i o n ) //

subplot (2 ,1 ,2) ;
bar(n_received,Received_Absence,0.1,'Green');
title('CorrelationintheAbsenceofObject','color','red','fontsize',4);
xlabel("Index","fontsize",2,"color","blue");
ylabel("CorrelationValue","fontsize",2,"color","blue");

/**
moyenne glissante
x = randn(5,1);   % A random vector of length 5
h = [1 1 1 1]/4;  % Length 4 averaging filter
y = conv(h,x);

**/
