clear all
clc
close all
% analog input to A0
comPort='COM7';
s=serial(comPort);
set(s,'DataBits',8);
set(s,'StopBits',1);
set(s,'BaudRate',1200);
set(s,'Parity','none');
fopen(s)
a=1;
storeTime =0;
numPeak = 0;
healthy = 1;

for l=1:10
    size = 0;
    clear storePeak;
    a=1;
    clear sig
c1=clock;
c1=fix(c1)    
while(a<=100)
    temp=str2num(fscanf(s));
 if temp>=0
    sig(a)=temp/1024*5;
    a=a+1;
 end
end
c2=clock;
c2=fix(c2)
tp=c2-c1;
tp=tp(5)*60+tp(6);
window = 3;
smoothSig = movmean(sig, window);
axis tight
plot((1:length(sig))*tp/100,smoothSig)
xlabel(['Time period = ' num2str(tp) 'seconds'])
if(l ~= 1)
    storeTime = storeTime + tp;
    storePeak = findpeaks(sig);
    size = length(storePeak);
    for i=1:size
       if(storePeak(i) < 0.6)
           size = size - 1;
       end
    end
    if (size<length(storePeak))
        disp('Weak Signal Detected')
    end
    numPeak = numPeak + size;
end
pause(0.01);
end
disp('Done')
heartRate = (numPeak/storeTime) * 60;
disp('Your heart rate is ')
disp(round(heartRate))
healthy = 1;
if(round(heartRate) < 60)
    healthy = 0;
    disp('Lower than average resting heartrate!')
    if(round(heartRate) == 0)
       disp('Check connection to device') 
    end
end
if(round(heartRate) > 100)
    healthy = 0;
    disp('Higher than average resting heartrate!')
end
fwrite(s,healthy);
fclose(s);
delete(s)