% ================== PRÁCTICA 2 ==================

% Realizada por: Ana Mei Li Ramos, Vicente Pérez y Martina Ortiz

% ~~~~~~~~~~~~~~ DIEZMADO POR UN FACTOR ENTERO ~~~~~~~~~~~~~~ 

% a) Lea el archivo facilitado e indique frecuencia de muestreo:

[x, fs1] = audioread("PDS_P2_3B_LE2_G4.wav");
sound(x,fs1);
disp(fs1); % 96000

% b) Representar x(t) a partir de las muestras de x[n] (apartado anterior)

% x, fs1 ya cargados
N = size(x,1);
t = (0:N-1)'/fs1;          % vector tiempo empezando en 0 (columnas)

% Representación
figure; plot(t, x);
xlabel('t (s)'); ylabel('Amplitude');
title('Representación temporal x(t)'); grid on;

% c) Calcule la señal y[n] como la parte de x[n] que contiene sonido. 
% Ignore de x[n] las muestras (|x[n]| < 0,01 V) anteriores y posteriores a la voz grabada.

thr = 0.01; % Umbral en voltios (según enunciado)

% Si x tiene dos canales, usar la envolvente (max absoluto entre canales)
if size(x,2) > 1
    env = max(abs(x), [], 2);
else
    env = abs(x);
end

% Encontrar índices activos (|x| >= thr)
active = find(env >= thr);

if isempty(active)
    error('No se encuentran muestras por encima del umbral.');
end

% Primer y último índice con sonido
i0 = active(1);
i1 = active(end);

% Extraer y[n]
y = x(i0:i1, :);   % conserva canales si existen
n_y = (0:size(y,1)-1)';  % índice n empezando en 0 para y[n]
t_y = n_y / fs1;         % vector tiempo empezando en t=0

% PLOT - graficamos la señal limpia
figure;
plot(t_y, y); xlabel('t (s)'); ylabel('Amplitude'); title('y(t)'); grid on;


% d) Genere una función en la que se diezme una señal muestreada, por un factor M dado.

    % Realizado en un archivo aparte (Diezmador.m)

% e) Realice el diezmado de y[n] con un coeficiente 𝑀 = 2. La señal resultante será g[n].

% y es la señal extraída anteriormente (y[n])
M = 2;
g = Diezmador(y, M);      % g es y[n] diezmada
fs_g = fs1 / M;           % nueva frecuencia de muestreo


% f) Calcule la nueva frecuencia de muestreo (𝑓𝑠2) de la señal y[n], con la que da lugar a g[n]. 
% ¿Cuál será la nueva frecuencia de muestreo de x[n]?

fs2 = fs1 / M;
% x[n] no se ha diezmado, por lo tanto su frecuencia de muestreo no cambia.


% g) Justifique gráficamente, en el dominio del tiempo, que el proceso de diezmado realizado 
% es correcto.

t_g = (0:length(g)-1).' / fs2;

figure;                                        
plot(t_y, y, 'b-o'); hold on;                     % Original en azul con círculos
plot(t_g, g, 'r*');                               % Diezmada en rojo con asteriscos
xlim([0.5, 0.505]);                              % Zoom para apreciar las muestras
xlabel('Tiempo (s)'); ylabel('Amplitud');      
title('Justificación Tiempo: y[n] vs g[n]');   
legend('Original y[n]', 'Diezmada g[n]');      
grid on;

% h) Justifique gráficamente, en el dominio de la frecuencia, que el proceso de diezmado 
% realizado es correcto. 

Ny = length(y); Ng = length(g);
Nfft = 4096;

% --- FFT centrada de y[n] ---
Y = fftshift(fft(y, Nfft));
f_y = (-Nfft/2:Nfft/2-1) * (fs1 / Nfft);

% --- FFT centrada de g[n] ---
G = fftshift(fft(g, Nfft));
f_g = (-Nfft/2:Nfft/2-1) * (fs2 / Nfft);

figure;
plot(f_y, abs(Y), 'b', 'LineWidth', 1.2); hold on;
plot(f_g, abs(G), 'r', 'LineWidth', 1.2); % Reducida por un factor 1/M

xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
title('Justificación en Frecuencia: y[n] vs g[n]');
legend('y[n] (fs1)', 'g[n] (fs2)');
grid on;

xlim([-fs2 fs2]);   % solo la banda común


% i) En el dominio de la frecuencia, ¿qué pasaría al diezmar y[n] si su espectro tuviese energía 
% entre 𝑓𝑠1/2 y 𝑓𝑠2/2? ¿Qué habría que hacer para evitarlo? 

% Si la señal tuviese energía en ese rango, se produciría el fenómeno de aliasing (solapamiento espectral). 
% Las componentes de alta frecuencia se "doblarían" sobre la banda de interés, distorsionando la señal resultante y perdiendo la de interés.
% Para evitarlo, es necesario aplicar un filtro digital paso bajo (antialiasing) antes del proceso de diezmado. 
% Este filtro debe tener una frecuencia de corte de fc = fs2/2 para asegurar que se elimine toda la energía que queda fuera 
% de la nueva franja de Nyquist antes de descartar las muestras.

% ~~~~~~~~~~~~~~ INTERPOLACIÓN POR UN FACTOR ENTERO ~~~~~~~~~~~~~~

clear all

% a) Genere una función de Matlab en la que se interpole una señal
% muestreada por un factor dado. 
    % Realizado en una función aparte.

% b) Realice la interpolación de y[n] con un coeficiente 𝐿 = 2. La señal resultante será h[n].

% >>>>> Teniendo lo realizado anteriormente para llegar a y[n]:

[x, fs1] = audioread("PDS_P2_3B_LE2_G4.wav");
sound(x,fs1);
disp(fs1);

% x, fs1 ya cargados
N = size(x,1);
t = (0:N-1)'/fs1;          % vector tiempo empezando en 0 (columnas)

% Representación
figure; plot(t, x);
xlabel('t (s)'); ylabel('Amplitude');
title('Representación temporal x_n'); grid on;

% x, fs1 ya cargados
thr = 0.01; % Umbral en voltios (según enunciado)

% Si x tiene dos canales, usar la envolvente (max absoluto entre canales)
if size(x,2) > 1
    env = max(abs(x), [], 2);
else
    env = abs(x);
end

% Encontrar índices activos (|x| >= thr)
active = find(env >= thr);

if isempty(active)
    error('No se encuentran muestras por encima del umbral.');
end

% Primer y último índice con sonido
i0 = active(1);
i1 = active(end);

% Extraer y[n]
y = x(i0:i1, :);   % conserva canales si existen
n_y = (0:size(y,1)-1)';  % índice n empezando en 0 para y[n]
t_y = n_y / fs1;         % vector tiempo empezando en t=0

% >>>>> Teniendo la señal y[n]
L = 2;
h_n = interpolar(y, L); % Obtengo la nueva señal interpolada


% c) Calcule la nueva frecuencia de muestreo de la señal y[n], con la que da lugar a h[n].

% Teniendo en cuenta que la señal y[n] es un fragmento de x[n] 
% (aquel que nos interesaba y que cumplía con el umbral marcado), 
% la frecuencia de muestreo es la misma tanto para y[n] como para x[n].


% d) Filtre la señal h[n] con el filtro facilitado por el profesor. La señal resultante será k[n].

% Filtramos la señal h[n] con el filtro que nos han dado, obetniendo k:
k = Filtro(h_n, fs1*L, L, fs1/2); % fs1/2 es la de corte en analógico
% Lo que tenemos que cuidar es el eje X, el de amplitudes no es tan
% importante

% e) Indique cuánto debe valer la ganancia del filtro en la banda de paso. 

% La ganancia del filtro en la banda de paso debe ser L para restaurar la energía 
% que se perdió al insertar ceros, visible en cómo la amplitud de cada réplica tras interpolar baja a 1/L. 
% Al insertar ceros, no pierdes energía total (pues esta se conserva), pero sí "densidad de energía", 
% porque ahora la señal ocupa más muestras; será el filtro el encargado de compensar eso multiplicando por L.

% f) Justifique la frecuencia de corte del filtro empleado. 

% La frecuencia de corte tiene que ser del 1/(2*L) para evitar que las réplicas (originalmente centradas en 1 en frecuencia digital) se cuelen en la franja de Nyquist al comprimir el espectro 1/L. 
% Hemos de seguir respetando la periodicidad entre +-1/2.


% g) Justifique gráficamente, en el dominio del tiempo, que los procesos de interpolación y 
% filtrado realizados son correctos. 

disp(length(y));
disp(length(h_n));

% Longitudes
Nh = length(h_n); % Señal interpolada antes del filtrado
%disp(Nh)
Nk = length(k); % Señal interpolada tras el filtrado
%disp(Nk)

% Vector de tiempo (ambas tienen la misma fs2)
th = (0:Nh-1)'/(fs1*L); % Señal interpolada antes del filtrado
tk = (0:Nk-1)'/(fs1*L); % Señal interpolada tras el filtrado

% Para ver antes del filtrado al añadir la interpolación:
figure;
subplot(2,1,1);
plot(t_y, y);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('y[n] (original)');
grid on;

subplot(2,1,2);
plot(th, h_n);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('h[n] (interpolada con ceros)');
grid on;

% Para ver el efecto del filtro:
figure;
subplot(2,1,1);
plot(th, h_n);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('h[n] (antes del filtrado)');
grid on;

subplot(2,1,2);
plot(tk, k);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('k[n] (después del filtrado)');
grid on;


% Todo en la misma gráfica:

% Longitudes
Ny = length(y);
Nh = length(h_n);
Nk = length(k);
% Frecuencia de muestreo tras interpolación
fs_interp = fs1 * L;
% Vectores de tiempo
t_y = (0:Ny-1)'/fs1;
th  = (0:Nh-1)'/fs_interp;
tk  = (0:Nk-1)'/fs_interp;
figure;
hold on;
% Señal original
plot(t_y, y, 'b-o', 'LineWidth', 1.2, 'MarkerSize', 4);
% Señal interpolada con ceros
plot(th, h_n, 'r*', 'LineWidth', 1.2, 'MarkerSize', 5);
% Señal filtrada
plot(tk, k, 'gs', 'LineWidth', 1.2, 'MarkerSize', 5);

xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Comparación temporal: y[n], h[n] y k[n]');
legend('y[n] (original)', 'h[n] (interpolada con ceros)', 'k[n] (filtrada)');
grid on;
% Zoom para ver los ceros y la reconstrucción
xlim([0.01 0.015]);


% h) Justifique gráficamente, en el dominio de la frecuencia, que los procesos realizados son correctos. 

Nfft = 4096;  % o una potencia de 2 mayor que length(y)

Y = fftshift(fft(y, Nfft));          % FFT
Hn = fftshift(fft(h_n, Nfft));
K  = fftshift(fft(k,  Nfft));

% Eje de frecuencias centrado (No normalizadas)

f_y  = (-Nfft/2:Nfft/2-1) * (fs1 / Nfft);      % y[n] → fs1
f_hn = (-Nfft/2:Nfft/2-1) * (fs1*L / Nfft);    % h[n] → fs1*L
f_k  = (-Nfft/2:Nfft/2-1) * (fs1*L / Nfft);    % k[n] → fs1*L

% Representación del módulo
figure;

hold on;

plot(f_y,  abs(Y),  'LineWidth', 1.2, 'Color', [0 0.447 0.741]);   % azul
plot(f_hn, abs(Hn), 'LineWidth', 1.2, 'Color', [0.85 0.325 0.098]); % naranja
plot(f_k,  abs(K),  'LineWidth', 1.2, 'Color', [0.466 0.674 0.188]); % verde

xlabel('Frecuencia (Hz)');
ylabel('Módulo del espectro');
title('Comparación de espectros centrados: y[n], h[n] y k[n]');
legend('y[n] (original)', 'h[n] (interpolada con ceros)', 'k[n] (interpolada + filtrada)');
grid on;
hold off;

% i) ¿De qué otra forma se puede obtener el mismo resultado sin emplear un filtro? 
% ¿Cómo se llama a esta técnica? 

% Si no quisieramos usar un filtro paso bajo, la otra forma de hacerlo sería mediante el uso de una sinc. 
% Es decir, podemos aplicar 'Interpolación ideal banda limitada' (interpolación sinc), que es la alternativa teórica al filtro digital.