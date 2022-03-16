% Matlab Script to interact with Simulink model.
clear
clc
close all

% Model Parameters.

%load MotorStep1.mat;
%load output_reboilerdata_25000.mat;

%data = xlsread('Motor_Step_1.xlsx'); 
filename = 'matInput.dat';
data = csvread(filename);
time = data(:,1);
tFinal = time(end,:);
tFinal          = 0.1;
MotorStep      = data;


% Open Simulink File.
% open('Electrical_Model.slx')

% Run Simulink model using 'sim' command
  sim('Electrical_Model.slx')

%Extract the data generated by the Simulink Model
 LoadPSignal                 = LoadP.signals.values;
 LoadQSignal                 = LoadQ.signals.values;
 t                           = LoadP.time;
 [LoadPmax, indexMax]        = max(LoadPSignal);
 tMax                        = t(indexMax);
 LoadPosSeqISignal           = LoadPosSeqI.signals.values;
 [LoadPosSeqImax, indexMax1] = max(LoadPosSeqISignal);
 tMax1                       = t(indexMax1);
 LoadPosSeqVSignal           = LoadPosSeqVoltage.signals.values;
 LoadVoltage                 = LoadV.signals.values;
 LoadCurrent                 = LoadI.signals.values;
 LoadPhaseCurrent            = LoadPhCurrenta.signals.values;
 FSignal                     = Frequency.signals.values;
 Ftime                       = Frequency.time;
 
 thd_db                      = thd(LoadPosSeqISignal);
 thd_phase_db                = thd(LoadPhaseCurrent);

 % write the values back to the excel file
  csvwrite('threephase.csv',[t(:),LoadPSignal(:),LoadQSignal(:),LoadPosSeqVSignal(:),LoadPhaseCurrent(:)]);
  csvwrite('freq.csv',[Ftime(:),FSignal(:)]);
  disp('Writing Data to CSV file.');
  
  
%   s = size(LoadPSignal);
%   s = s(1,1);
%  Apparent_Power = zeros(s,1);
%  
%  for i = 1:s 
%      clc
%      Apparent_Power(i)     =  sqrt((LoadPSignal(i))^2+(LoadQSignal(i))^2);
%      Load_PF(i)            =  (LoadPSignal(i))/(Apparent_Power(i));
%      disp('Power Factor')
%      disp(Load_PF(i));
%      i=i+1;
%  end
%  
%  
%  disp('THD of Positive Sequence Current in dB.');
%  disp(thd_db);
%  
%  disp('THD of Load phase current in dB.');
%  disp(thd_phase_db); 

%Plotting the Signals
 
 figure 
 subplot(3,1,1)
 hold on
 plot(t,LoadPSignal)
 plot(tMax,LoadPmax, 'rx', 'LineWidth', 2, 'MarkerSize',14)
 xlabel('t (Seconds)')
 ylabel('Power (Watts)')
 title('Reboiler Power')
 legend('Load Power','Max Load Power')
 grid on
 
 subplot(3,1,2)
 hold on
 plot(t,LoadPosSeqISignal)
 plot(tMax1,LoadPosSeqImax, 'rx', 'LineWidth', 2, 'MarkerSize',14)
 xlabel('t (Seconds)')
 ylabel('Current (A)')
 title('Load Positive Sequence Current')
 legend('Load Positive Sequence Current','Max Load Positive Sequence Current')
 grid on
 
 subplot(3,1,3)
 hold on
 plot(t,LoadPosSeqVSignal)
 xlabel('t (Seconds)')
 ylabel('Voltage (p.u.)')
 title('Load Positive Sequence Voltage (p.u.)')
 grid on
 
 figure
 
 subplot(4,1,1)
 hold on
 plot(t,LoadVoltage)
 xlabel('t (Seconds)')
 ylabel('Voltage (Volt)')
 title('Three Phase Load Voltage')
 grid on
 
 subplot(4,1,2)
 hold on
 plot(t,LoadCurrent)
 xlabel('t (Seconds)')
 ylabel('Current (Ampere)')
 title('Three Phase Load Current')
 grid on
 
 subplot(4,1,3)
 hold on
 plot(t,LoadPhaseCurrent)
 xlabel('t (Seconds)')
 ylabel('Current (Ampere)')
 title('Load Phase Current')
 grid on
 

 
% LoadP                       = LoadActivePowerSignal.Values.Data;
% LoadReactiveSignal          = yout.getElement('LoadQ');
% LoadQ                       = LoadReactiveSignal.Values.Data;
% LoadVoltageSignal           = yout.getElement('3PhLoadVoltage');
% LoadV                       = LoadVoltageSignal.Values.Data;
% LoadCurrentSignal           = yout.getElement('3PhLoadCurrent');
% LoadI                       = LoadCurrentSignal.Values.Data;
% LPhase_a_ISignal            = yout.getElement('LoadCurrenta');
% LoadPhaseAI                 = LPhase_a_ISignal.Values.Data;
% LPhase_b_ISignal            = yout.getElement('LoadCurrentb');
% LoadPhaseBI                 = LPhase_b_ISignal.Values.Data;
% LPhase_c_ISignal            = yout.getElement('LoadCurrentc');
% LoadPhaseCI                 = LPhase_c_ISignal.Values.Data;
% PosSeqVoltSignal            =yout.getElement('<Positive-sequence voltage V (pu)>');
% PosSeqVolt                  = PosSeqVoltSignal.Values.Data;
% LPosSeqISignal              = yout.getElement('LoadPosSeq');
% LoadPosSeqI                 = LPosSeqISignal.Values.Data;
% 
% 
% SourceActivePowerSignal     = yout.getElement('SourceP');
% SourceP                     = SourceActivePowerSignal.Values.Data;
% SourceReactivePowerSignal   = yout.getElement('SourceQ');
% SourceQ                     = SourceReactivePowerSignal.Values.Data;
% SourceVoltageSignal         = yout.getElement('3PhSourceVoltage');
% SourceV                     = SourceVoltageSignal.Values.Data;
% SourceCurrentSignal         = yout.getElement('3PhSourceCurrent');
% SourceI                     = SourceCurrentSignal.Values.Data;
% SPhase_a_ISignal            = yout.getElement('SourceCurrenta');
% SourcePhaseAI               = SPhase_a_ISignal.Values.Data;
% SPhase_b_ISignal            = yout.getElement('SourceCurrentb');
% SourcePhaseBI               = SPhase_b_ISignal.Values.Data;
% SPhase_c_ISignal            = yout.getElement('SourceCurrentc');
% SourcePhaseCI               = SPhase_c_ISignal.Values.Data;
% SPosSeqISignal              = yout.getElement('SourcePosSeq');
% SourcePosSeqI               = SPosSeqISignal.Values.Data;
% 
% %Plotting the Results.
% 
% figure
% plot(t,LoadP)
% xlabel('t (Seconds)')
% ylabel('Power (Watts)')
% title('Reboiler Power')
% grid on



disp('Done.');








