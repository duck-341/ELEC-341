%% q1
f1DSPlot(yourSN,3);  
info = step_help(3,1)

%%
zeta = info.zeta;
wn = info.ws;

Ga = get_sec_sys(info.final_value,wn,zeta)

Q1.Ga = Ga;
Q1

%% q2
k0 = 3e6;
p1 = snb * 25;
p2 = snc * 25;

h1 = 1/(s+p1);
h2 = 1/(s+p2);

hs = k0* feedback(h1*feedback(h2,1),h2^(-1));

ks = dcgain(hs);
ds = hs/ks;

Q2.Ds = ds;
Q2.Ks = ks;
Q2

%% q3
bm = sne * 2e-6;
jm = snd * 4e-4;
dp = sna * 0.01;
jp = snb * 2e-4;
mt = snc /2;
bp = snd *1e-5;
bw = sne+snf;
kt = sng /2;

n23 = 2/dp;

bj = bm + bp + bw/(n23^2);
jj = jp+jm+mt/(n23^2);
kj = kt/(n23^2);

Q3.Jj = jj;
Q3.Kj = kj;
Q3.Bj = bj;
Q3

%% q4
rw = sna/3;
lw = snb/5;
km = snc * 2e-2;

ye = 1/(rw + lw*s);
ym = 1/(bj + jj*s + kj/s);
gp = feedback(ye*km*ym,km)/s;
Q4.Ye = ye;
Q4.Ym = ym;
Q4.Gp = gp;
Q4

%% q5
A=[-rw/lw, -km/lw,0
   km/jj, -bj/jj, -1/jj
   0,kj,0];
B = [1/lw;0;0];
C = [0, bw/n23, 0
    0,0,n23];
D = [0;0];

Q5.A = A;
Q5.B = B;
Q5.C = C;
Q5.D = D;
Q5

%% q6 
cf = 20 * snd;
dc = sne + snf;
ghs = Ga * hs * gp;

filter_info = get_filter(ghs, dc, cf)
wd = filter_info.mdp_freq;
Nf = filter_info.Nf;
tau = filter_info.tau;
beta = filter_info.beta;

Q6.GHs = ghs;
Q6.wd = wd;
Q6.Nf = Nf;
Q6.tau = tau;
Q6.beta = beta;
Q6

%% q7
tau = round(Q6.tau,3);
Q7.num = filter_info.FIR_num;
Q7

%% 
N = filter_info.N;
Q8.N = N;
hc = cf/(N*s+cf)/dcgain(hs);
Q8.Hc = hc;
Q8

%% q9
G = Ga * gp;
H = hc * hs;
GH = G*H;
ktj = n23;
kjt = n23^(-1);
Q9.G = G;
Q9.H = H;
Q9.GH = GH;
Q9.Kjt = kjt;
Q9.Ktj = ktj;
Q9

%% q10
Dp_d = cf/((0.5+Nf)*s+cf);
Dp_i = 1/s;
Dp = Dp_d * Dp_i;
Gol_partial = Dp*G*H;
[k0, ~, wx0, ~] = margin(Gol_partial);

Q10.Dp = Dp;
Q10.K0 = k0;
Q10.wxo = wx0;
Q10

%% q11
info = get_opt_sec_zero(Gol_partial,wx0,0.1e-2,0.05)
%%
Dn = get_sec_sys(1, info.wn_opt, info.zeta_opt);
D = Dn^(-1)*Dp
Q11.Z = info.zeros;
Q11.PM = info.max_pm;
Q11.D = D;
Q11

%% q12
k_master = 0.2568440;
Gol = D * G * H * k_master;
[~, PM, ~, ~] = margin(Gol);
PM
Q12.K = k_master;
Q12

%% q13
info = get_pid_k(Dp, Q11.Z);
Kp = info.kp_n * k_master;
Ki = info.ki_n * k_master;
Kd = info.kd_n * k_master;
Q13.Kp = Kp;
Q13.Ki = Ki;
Q13.Kd = Kd;
Q13

%% q14
Gcl = feedback(k_master * D * G, H);
t = 0:0.001:100;
figure(1); hold on ; grid on;
plot(t, step(Gcl, t));
xlabel("Time(s)");
info = step_help(1)
%%
Q14.Tr = info.rise_time;
Q14.Tp = info.peak_time;
Q14.Ts = info.settle_time;
Q14.OSu = 100*(info.peak_value - 1);
Q14.OSy = 100*(info.peak_value - 1);
Q14.Ess = 0;
Q14

%% q15
standard.OSu = 0.7 * Q14.OSu;
standard.Ts = 0.5 * Q14.Ts;
standard.Tr = standard.Ts;
k_n = get_pid_k(Dp, Q11.Z);
pid_heuristic_gui(Dp,G,H,1,Q13.Kp,Q13.Ki, Q13.Kd);

%%
Q15.Kp = pid_export.Kp;
Q15.Ki = pid_export.Ki;
Q15.Kd = pid_export.Kd;
Q15

%% q16
Q16.Tr = pid_export.Tr;
Q16.Ts = pid_export.Ts;
Q16.Tp = pid_export.Tp;
Q16.OSu = pid_export.OSu;
Q16.OSy = pid_export.OSy;
Q16.Ess = 0;
Q16