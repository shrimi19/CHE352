function J=TAC(x)
global  br_p bz_fr eb_p
br_p = x(1);
bz_fr = x(3);
eb_p = x(2);
Aspen = actxserver('Apwn.Document.40.0');
[stat,message] = fileattrib;
Aspen.invoke('InitFromArchive2',[message.Name '\221036_lab10_f.bkp']);
Aspen.Visible = 0;
Aspen.SuppressDialogs = 1;
Aspen.Application.Tree.FindNode("\Data\Blocks\C2\Subobjects\Design Specs\1\Input\VALUE\1").value = br_p;
Aspen.Application.Tree.FindNode("\Data\Blocks\C3\Subobjects\Design Specs\1\Input\VALUE\1").value = eb_p;
Aspen.Application.Tree.FindNode('\Data\Blocks\B1\Input\OUTMLFL').value = bz_fr;
Run2(Aspen.Engine);
status = Aspen.Application.Tree.FindNode('\Data\Results Summary\Run-Status\Output\PER_ERROR').value;
if status == 0
    % if all good + reboiler
    C1Q = Aspen.Application.Tree.FindNode("\Data\Blocks\C1\Output\REB_DUTY").value;
    C2Q = Aspen.Application.Tree.FindNode('\Data\Blocks\C2\Output\REB_DUTY').value;
    C3Q = Aspen.Application.Tree.FindNode('\Data\Blocks\C3\Output\REB_DUTY').value;
    hot = C2Q*0.0036*24*300*8.22 + C1Q*0.0036*24*300*9.8 + C3Q*0.0036*24*300*9.8;
   % if all good + condenser

    C1_CQ = Aspen.Application.Tree.FindNode("\Data\Blocks\C1\Output\COND_DUTY").value;
    C2_CQ = Aspen.Application.Tree.FindNode("\Data\Blocks\C2\Output\COND_DUTY").value;
    C3_CQ = Aspen.Application.Tree.FindNode("\Data\Blocks\C3\Output\COND_DUTY").value;
    cold = (C1_CQ + C2_CQ + C3_CQ)*0.0036*24*300*0.354;

    %operating cost
    opx = hot -  cold;

    C1_N = Aspen.Application.Tree.FindNode('\Data\Blocks\C1\Input\NSTAGE').value;
    C1_N = double(C1_N);
    C1_D = Aspen.Application.Tree.FindNode("\Data\Blocks\C1\Subobjects\Column Internals\INT-1\Output\CA_DIAM6\INT-1\CS-1").value;
    C1_TOP = Aspen.Application.Tree.FindNode('\Data\Streams\C1D\Output\TEMP_OUT\MIXED').value;
    C1_BOTT = Aspen.Application.Tree.FindNode('\Data\Streams\C1B\Output\TEMP_OUT\MIXED').value;

    C2_N = Aspen.Application.Tree.FindNode('\Data\Blocks\C2\Input\NSTAGE').value;
    C2_N = double(C2_N);
    C2_D = Aspen.Application.Tree.FindNode("\Data\Blocks\C2\Subobjects\Column Internals\INT-1\Output\CA_DIAM6\INT-1\CS-1").value;
    C2_TOP = Aspen.Application.Tree.FindNode('\Data\Streams\C2D\Output\TEMP_OUT\MIXED').value;
    C2_BOTT = Aspen.Application.Tree.FindNode('\Data\Streams\C2B\Output\TEMP_OUT\MIXED').value;

    C3_N = Aspen.Application.Tree.FindNode('\Data\Blocks\C3\Input\NSTAGE').value;
    C3_N = double(C3_N);
    C3_D = Aspen.Application.Tree.FindNode("\Data\Blocks\C3\Subobjects\Column Internals\INT-1\Output\CA_DIAM6\INT-1\CS-1").value;
    C3_TOP = Aspen.Application.Tree.FindNode('\Data\Streams\C3D\Output\TEMP_OUT\MIXED').value;
    C3_BOTT = Aspen.Application.Tree.FindNode('\Data\Streams\C3B\Output\TEMP_OUT\MIXED').value;

    %shape factor
    Fq1 = 10^(0.477+0.085*log10(C1_N)-0.347*(log10(C1_N))^2);
    %estimate tray cost
    A1 = pi*(C1_D^2)/4;
    CP1 = 10^(2.994+ 0.446*log10(A1) +0.396*(log10(A1))^2);
    TC_1 = CP1*C1_N*1.8*Fq1;

    %shape factor
    Fq2 = 1;
    %estimate tray cost
    A2 = pi*(C2_D^2)/4;
    CP2 = 10^(2.994+ 0.446*log10(A2) +0.396*(log10(A2))^2);
    TC_2 = CP2*C2_N*1.8*Fq2;

    %shape factor
    Fq3 = 1;
    %estimate tray cost
    A3 = pi*(C3_D^2)/4;
    CP3 = 10^(2.994+ 0.446*log10(A3) +0.396*(log10(A3))^2);
    TC_3 = CP3*C3_N*1.8*Fq3;

    C1_CC = 17640*((C1_D)^(1.066))*(((C1_N-2)*2*0.3048*1.2)^(0.802)) + 7296*((-1*C1_CQ/(0.568*(C1_TOP-298)))^0.65) + 7296*((C1Q/(0.852*(527-C1_BOTT)))^0.65)+TC_1;
    C2_CC = 17640*((C2_D)^(1.066))*(((C2_N-2)*2*0.3048*1.2)^(0.802)) + 7296*((-1*C2_CQ/(0.568*(C2_TOP-298)))^0.65) + 7296*((C1Q/(0.852*(527-C2_BOTT)))^0.65)+TC_2;
    C3_CC = 17640*((C3_D)^(1.066))*(((C3_N-2)*2*0.3048*1.2)^(0.802)) + 7296*((-1*C3_CQ/(0.568*(C3_TOP-298)))^0.65) + 7296*((C1Q/(0.852*(527-C3_BOTT)))^0.65)+TC_3;

    vol_CSTR = 200;
    D_CSTR = ((2* vol_CSTR)/pi)^0.333;
    L_CSTR = 2*D_CSTR;
    CSTR_C = 17640*(D_CSTR^1.066)*(L_CSTR^0.802);
    cpx = C1_CC + C2_CC + C3_CC + 2*CSTR_C;

    J = cpx/3+opx;
else
    J = 10e10;
end
end

