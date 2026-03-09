function y_l = interpolar(x, L)

% Generar función de Matlab para interpolar dado un facto L

% x = la entrada que se va a interpolar 
% L = factor de interpolación
% y_l = salida de la función, señal interpolada

% Generamos la nueva frecuencia de muestreo, partiendo de la Fs obtenida 
% con nuestra señal de audio, la cual es fs = 96000

% En primer lugar, descartamos aquellas L que no sean válidas:

if ((L<1) || (floor(L) ~= L)) % Verifico que L sea entero y >=1
    error('El factor L debe ser un entero mayor o igual a 1')
end

% Garantizado que la L con la que trabajamos  es válida...

% Un interpolador inserta ceros cada L muestras, ahora hemos de añadir
    
y_l = zeros(1, L*length(x));
y_l(1:L:end) = x;


end