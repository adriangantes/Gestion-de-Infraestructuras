%%%%%%           SISTEMA DE TRANSMISION BANDA BASE         %%%%%%


clear all;
close all;

%=================== Parametros ==================================
N=20;		 % Periodo de simbolo
L=6;		 % Numero de bits a transmitir
tipopulso=5; %1: pulso rectangular
EbNodB = 5;  %Eb/N0


%=================== Generacion del pulso =========================

if tipopulso == 1  %pulso rectangular
  n=0:N-1;
  pulso=ones(1,N);
  % p(n) = u(n) − u(n − N)
elseif tipopulso == 2 %escriba un elseif por cada tipo
  n=0:N-1;
  pulso = [ones(1,N/2) zeros(1, N/2)]
  % p(n) = u(n) − u(n − N/2)
elseif tipopulso == 3
  n=0:N-1;
  pulso = [ones(1, N/2) ((-1) * ones(1,N/2))]
  % p(n) = u(n) − 2u(n − N/2) + u(n − N)
elseif tipopulso == 4
  n=0:N-1;
  pulso = [ones(1, N/4) zeros(1, N/2) ((-1) * ones(1,N/4))]
  % p(n) = u(n) - u(n - N/4) - u(u - 3N/4) + u(n - N)
elseif tipopulso == 5
  n=0:N-1;
  pulso = [ones(1, N/4) zeros(1, 3*N/4)]
  % 𝑝(𝑛) = 𝑢(𝑛) – 𝑢(𝑛 − 𝑁/4) + 𝑢(𝑛 − 𝑁/2) − 𝑢(𝑛 − 𝑁)
end;


%=================== Calculo de la energia del pulso =============

Ep = sum(pulso.^2);

%=================== Generacion de la senal (modulacion) =========

bits=rand(1,L) < 0.5; %genera 0 y 1 a partir de un vector de numeros
                      %aleatorios con distribucion uniforme

%%%%% PUEDO METER LAS FIGURAS AQUI %%%%%

bits = [0 1 0 1 0 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Escriba un bucle que asocie un pulso con amplitud positiva a un bit 0 y
%un pulso con amplitud negativa a un bit 1

senal = [];
for b = 1:L
    if bits(b) == 0
        a = pulso;
    else
        a = -pulso;
    end
    senal = [senal a]; 
end

%=================== Generación de señal recibida  =============
%Escriba el codigo para obtener la señal recibida (transmitida + ruido)

Eb = Ep;

EbNo= 10^(EbNodB/10);
No=Eb/EbNo;
ruido=sqrt(No/2)*randn(1,N*L);

senal_rec = senal + ruido;


%=================== Calculo de la probabilidad de error ===========
%Escriba el codigo para calcular la probabilidad de error teórica y rea

s_rec = senal_rec;

pulsoinv = pulso(N:-1:1);
ind = 1;
for k = 1:N:L*N-1
    s_conv = conv(s_rec(k:k+N-1),pulsoinv);
    s_muest = s_conv(N);
    bits_rec(ind) = s_muest <= 0;
    ind = ind + 1;
end;

pe_real = mean(bits_rec ~= bits);

pe_teo = erfc(sqrt(EbNo))/2;

%=================== Representacion grafica ===================
figure(1)
plot(n,pulso);
axis([0 N -2 2])
xlabel('t(s)')
ylabel('Valor')
title('Pulso transmitido: p(n)');
grid;

figure(2)
stem(n,pulso);
axis([0 N -2 2])
xlabel('t(s)')
ylabel('Valor')
title('Pulso transmitido: p(n)');
grid;

%Escriba el codigo para representar la senal transmitida sin ruido
figure(3)
subplot(211)
plot(senal, 'LineWidth', 2); % Representa todos los puntos
title('Señal Modulada');
xlabel('Bits');
ylabel('Amplitud');
axis([0 N*L -2 2]);

%Escriba el codigo para representar la senal recibida
subplot(212)
plot(senal_rec, 'LineWidth', 2); % Representa todos los puntos
title('Señal Recibida');
xlabel('Bits');
ylabel('Amplitud');
axis([0 N*L -2 2]);

