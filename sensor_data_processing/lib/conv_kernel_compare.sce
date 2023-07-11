    clear;
    clc;
    close();

/*
    This program helps visualise different convolution kernels
*/
SIZE = 5;
for i=0:SIZE
    a(i+1) = 1+(SIZE/2)^2-(i-SIZE/2)^2;
     //printf("\n %d",1+(SIZE/2)^2-(i-SIZE/2)^2)
end

for i=0:SIZE
    b(i+1) = 1+(SIZE-1-i)*(SIZE-1-i);
     //printf("\n %d",1+(SIZE/2)^2-(i-SIZE/2)^2)
end


for i=0:SIZE
        c(i+1) = exp(-((i-SIZE/2)/(SIZE/2)).^2)*SIZE;
     //printf("\n %d",1+(SIZE/2)^2-(i-SIZE/2)^2)
end

plot(a, "r")
plot(b)
plot(c*SIZE/5,"g")
legend("Corentin test","Corentin actuel", "Gaussienne")
figure();
plot(c)
legend("Gaussienne seule")
return
