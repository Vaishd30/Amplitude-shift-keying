clc;
clear all;
close all;
%GENERATE CARRIER SIGNAL
Tb=1; fc=10;
t=0:Tb/100:1;
c=sqrt(2/Tb)*sin(2*pi*fc*t);
%generate message signal
N=8;

m=rand(1,N);
t1=0;t2=Tb
for i=1:N
if m(i)>0.5
 m(i)=1;
 m_s=ones(1,length(t));
 else
 m(i)=0;
 m_s=zeros(1,length(t));
 end
 message(i,:)=m_s;
 %product of carrier and message
 ask_sig(i,:)=c.*m_s;
 t1=t1+(Tb+.01);
 t2=t2+(Tb+.01);
 %plot the message and ASK signal
 subplot(24,2,1:4);
 axis([0 N -2 2]);
 plot(t,message(i,:),'r');
 title('message signal');
 xlabel('t--->');
 ylabel('m(t)');
 grid on
 hold on
 subplot(24,2,19:22);
 plot(t,ask_sig(i,:));
 title('ASK signal');
 xlabel('t--->');
 ylabel('s(t)');
 grid on
 hold on
 end
hold off
%Plot the carrier signal and input binary data
subplot(24,2,7:10);
plot(t,c);
title('carrier signal');
xlabel('t--->');
ylabel('c(t)');
grid on
subplot(24,2,13:16);
stem(m);
title('binary data bits');
xlabel('n--->');
ylabel('b(n)');
grid on
t1=0;
t2=Tb;
 for i=1:N
 t=[t1:Tb/100:t2]
 %correlator
 x=sum(c.*ask_sig(i,:));
 %decision device
 if x>0
 demod(i)=1;
 else
 demod(i)=0;
 end
 t1=t1+(Tb+.01);
 t2=t2+(Tb+.01);
 end
%plot demodulated binary data bits
 subplot(24,2,29:32);
 stem(demod);
 title('ASK demodulated signal'); 
 xlabel('n--->');
 ylabel('b(n)')
 ;grid on 
 SNRdB=0:10;
SNR=10.^(SNRdB/10);
k=log2(N);
 y1=awgn(complex(m),SNRdB(k));
demod_noise=conv(demod,y1);
for i=1:N
mod_noise=conv(ask_sig(i,:),y1);
subplot(24,2,23:26)
title('ASK mod with noise');
plot(mod_noise)
end
for(k=1:length(SNRdB))
    y=awgn(complex(m),SNRdB(k));
    error=0;
    R=0;
    M=[];
    for(c=1:1:N)
        if (y(c)>.5&&m(c)==0)||(y(c)<.5&&m(c)==1)
            error=error+1;
            M=[M ~m(c)];
        else
            M=[M m(c)];
    end
    end
error=error/N;
    p(k)=error;
end
semilogy(SNRdB,p,'o','linewidth',2.5),grid on,hold on;
BER_th=(1/2)*erfc(.5*sqrt(SNR));
subplot(24,2,41:48);
semilogy(SNRdB,BER_th,'r','linewidth',2.5),grid on,hold on;
title('curve for bit erroe rate verses SNR for binary ASK modulation');
xlabel('SNR(dB)');
ylabel('BER');
legend('simulation','theorytical')
axis([0 10 10^-5 1]);