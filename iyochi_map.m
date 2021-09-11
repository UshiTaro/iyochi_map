x_range = 100;
y_range = 100;
step = 5;

area = combvec([0:step:x_range], [0:step:y_range]);
S21 = zeros(x_range/step+1, y_range/step+1);

p = surf(S21);
p.ZDataSource = "S21";

cnc = serialport("COM6", 115200);
vna = serialport("COM7", 9600);
configureTerminator(vna,"CR");

for pos = area
    y = pos(2);
    if mod(y, 2) == 1
        x = 100-pos(1);
    else
        x = pos(1);
    end
    writeline(cnc, "G90G00X"+x+"Y"+y);
    "x="+x+" y="+y
    pause(1);
    writeline(vna, "scan 6780000 6780000 1");
    readline(vna);
    writeline(vna, "data 1");
    readline(vna);
    res = str2num(readline(vna));
    S21(y/step+1,x/step+1) = 20*log10(sqrt(res(1)^2 + res(2)^2));
    refreshdata;
    drawnow;
    for n = 1:100
        readline(vna);
    end
end