close all;
clear all;

% r - reference signal
r = 'sp12.wav';
[y,Fs] = audioread(r);

% x - noisy signal
% Additive White Gaussian noise added to clean signal
x=awgn(y,10,'measured');

% Noise
v=x-y;
% n- number of segments with m samples each
m = 10;
n = round(length(x)/m);
r1=rem(length(x),m);

% variance of noise
varv = var(v);

% Mean of x
mx = mean(reshape(x(1:length(x)-r1),m,[]));
Mx = repelem(transpose(mx),m);

% replelem(mx,m) repeats each array element in mx 'm' times
varx = var(reshape(x(1:length(x)-r1),m,[]));
Varx = repelem(transpose(varx),m);
hn = zeros(length(mx),1); %Filter transfer function

for i = 1:1:length(mx)
  if varx(i) > varv
    hn(i) = (varx(i) - varv)/(varx(i));
    else if varv > varx(i)
    hn(i) = 0;
    end
    end
end

Hn = repelem(hn,m);

%Enhanced signal s
s = zeros(length(x),1);
for j =1:1:length(x)-r1
  s(j) = (Mx(j))+(Hn(j).*(x(j)-Mx(j)));
end

% Mean of noise
mv = mean(v)

% SNR of enhanced signal
SNR_f = snr(s,v)
figure(1);
plot(v);
title('Noise');
figure(2);

subplot(2,1,1)
plot(x,'b')
hold;
plot(y,'r');
title('Before Enhancement');
legend('Noisy signal' ,'Clean Signal');

subplot(2,1,2);
plot(s,'k');
hold;
plot(y,'m');
title('After Enhancement');
legend('Noisy signal', 'Clean Signal');

%sound of enhanced signal
sound(s);
