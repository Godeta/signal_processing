// Exp−5 Pe rfo rm C o n v ol u ti o n O p e r a ti o n on Two
// V e r s i o n : S c i l a b 5 . 4 . 1
// O p e r a ti n g Syatem : Window−xp , Window−7
//clc ;
clear ;
xdel ( winsid () ) ;

//x1 = input (" E n t e r t h e S e q u e n c e 1 : ") ; // [ 1 2 3 4] ;
//x2 = input (" E n t e r t h e S e q u e n c e 2 : ") ; // [ 5 4 8 ] ;
x1 = [ 1 2 3 4] ;
x2 = [ 5 4 8 ] ;
m = length ( x1 ) ;
n = length ( x2 ) ;

//convolution

for k = 1:( n +m -1)
    w ( k ) = 0;
    for j = max (1 , k +1 - n ) : min(k , m )
        w ( k ) = w ( k ) +( x1 ( j ) * x2 ( k +1 - j ) ) ;
    end
end

//correlation
/*
for k =1: m +n -1
    w ( k ) =0;
    for j= max (1 , k +1 - n ) : min (k , m)
        w ( k ) =w ( k ) +( x1 ( j ) *x2 (n - k + j ) ) ;
    end
end
*/

scf();
subplot(3,1,1);
bar(x1,0.1,'red');
title('Sequence1','color','red','fontsize',4);
xlabel("Index","fontsize",2,"color","blue",'position',[0.60.3]);
ylabel("Amplitude","fontsize",2,"color","blue");
subplot(3,1,2);
bar(x2,0.1,'yellow');
title('Sequence2','color','red','fontsize',4);
xlabel("Index","fontsize",2,"color","blue",'position',[0.60.3]);
ylabel("Amplitude","fontsize",2,"color","blue");
subplot(3,1,3);
bar(w,0.1,'green');
title('ConvoledSequence','color','green','fontsize',4);
xlabel("Index","fontsize",2,"color","blue",'position',[0.30.3]);
ylabel("Amplitude","fontsize",2,"color","blue");
