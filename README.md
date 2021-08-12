# CORLD
This repository is created for the paper entitled "CORLD: In-Stream Correlation Manipulation for Low-Discrepancy Stochastic Computing" published in ICCAD 2021 [[1]](#1). Inside this project, all codes are provided for assisting future co-workers working on Stochastic Computing (SC), particularly for those who are interested in correlation and decorrelation techniques used in bit-streams (most likely in stream based). 
Containing MATLAB and Verilog files of CORLD correlator and decorrelator
Inside MATLAB files the controlling parameters are provided to easily adapt based on user's requirements.
Verilog files are designed to be sythensized by DC. 

## Requirements
- MATLAB (for .m files, which are created to run and test the performance of the proposed approaches)
- Modelsim (for running and verifying verilog codes)
- Design Compiler (for sythesizing the hardware implementations to obtain different parameters)

## MATLAB Codes
The MATLAB files simulate the correlator and decorrelator techniques proposed in the paper. 
Both codes consist conrol parameter panel, and the parameter are defined as follows:
### Controlling section
- n : shows the bit-width of the system
- k : determines the number of cycles or length of bit-streams
- input-mode : There are defined three types of input bit-streams, Sobol-based and FSM-based [[2]](#2) both for determinstic techniques, LFSR-based for non-determinstic (conventional) approach.  If the input-mode is set to zero, it'll select the FSM-based input bit-streams, 1 => Sobol-based, 2 => LFSR-based. In the uploaded version, there are chosen three different LFSR's for n=6,7, and 8. They are maximum length LFSRs. There are some more maximum LFSRs in different bit-width that can be replaced by them.
- fix-size : this param, determines the size of the correlator or decorelator units (explained thoroughly in the paper). In decorrelator this param is seperated into two params to simply change the fixer size for each input to see the effect. 
- out_base_selector : An output bit-stream can be in different format in the proposed approach. they can be obtained based on Sobol-sequences, or other formats such as FSM based or even Unary. This is how proposed Correlator turn an arbitrary input bit-streams into seleceted format output (FSM-based, Sobol-based, or Unary format)
- SDS_input : if the input bit-streams are FSM-based or Sobol-based, this param (actually params, SDS_input1 and SDS_input2) determines the number of matlab built-in sobol sequences that input bit-streams are produced based on them. For Sobol-based, if both of them are set to the same number, the input bit-streams are correlated (good for decorrelator approach), otherwise, independent (good for correlator approach).
- SDS1_fix & SDS2_fix : these two shows the format of ouput bit-streams based on matlab built-in sobol numbers if output_base_selector is set to 1 or 2 (FSM-based or Sobol-based). Same as what mentioned earlier, for Sobol-based outputs, if both of them are set to the same number, the input bit-streams are correlated.  
- cm_depth : in order to compare the proposed method with the latest approach which is correlation manipulation technique (fully explained in the paper), it is added to the work and this param shows the depth of it.
- cm_after: it is just a test to see how the proposed method performs if combined with correlation manipulation technique. 

### Result:
There are some result for the purpose of accuracy and performance that we are looking for in Matlab code as follows:
![image](https://user-images.githubusercontent.com/46909403/129071346-7f2e5425-ceee-401c-ba28-6c32519a3738.png)

In this picture, the following params are defined:
- error_cm_max_mean : the MAE (mean absolute error rate) of maximum function using correlation manipulation technique
- error_cm_min_max : the maximum error rate of minimum function using correlation manipulation technique
- error_cm_min_mean : the MAE (mean absolute error rate) of minimum function using correlation manipulation technique
- error_cm_xor_mean : the MAE (mean absolute error rate) of XOR function using correlation manipulation technique
- error_max_mean : the MAE (mean absolute error rate) of maximum function using proposed CORLD technique
- error_min_max : the maximum error rate of minimum function using proposed CORLD technique
- error_min_mean : the MAE (mean absolute error rate) of minimum function using proposed CORLD technique
- error_mp_max : the maximum error rate of multiplication function using proposed CORLD technique
- error_mp_mean : the MAE (mean absolute error rate) of multiplication function using proposed CORLD technique
- error_xor_mean : the MAE (mean absolute error rate) of XOR function using proposed CORLD technique

![image](https://user-images.githubusercontent.com/46909403/129071943-c89ac507-0bbe-49f5-89cf-2bad3e3c669b.png)

In the above picture, the following params are defined:
- SCC_avg : the stochastic computing correlation rate of the proposed CORLD technique
- SCC_avg_cm : the stochastic computing correlation rate of the correlation manipulation technique
- SCC_avg_original : the stochastic computing correlation rate of the original input bit-streams

## Verilog Codes
Verilog files are responsible for hardware implementations of the mentioned methods.
They are pretty straighforward, however, there are two seperate files for each element (Correlator2.v and deCorrelator2.v). The reason is that the proposed architecture contains a statci part and input-dependent part (fully discussed in the paper), so, the main files (Correlator.v and deCorrelator.v) contains both parts of the design and the other files (Correlator2.v and deCorrelator2.v) include only the input-dependent part in order to see the area proportion of each part.

## References
- <a id="1">[1]</a> Asadi, Sina, M. Hassan Najafi, and Mohsen Imani. "CORLD: In-Stream Correlation Manipulation for Low-Discrepancy Stochastic Computing.", The 40th IEEE/ACM International Conference on Computer-Aided Design (ICCAD), 2021
- <a id="2">[2]</a> Asadi, Sina, M. Hassan Najafi, and Mohsen Imani. "A Low-Cost FSM-based Bit-Stream Generator for Low-Discrepancy Stochastic Computing.", 2021 Design, Automation & Test in Europe Conference & Exhibition (DATE), 2021.


Hope they will help our SC community and to expand the utilization of SC.

Please do not hesitate to contact me if you are inetersted in this work and need further instructions on how to run (or catch the result of) the code and work on it.
Please also keep in touch if I did anything wrong and you have a comment on the codes. I would appreciate any criticism to further improve the work. I am pretty much open to any cooperation, so feel free to contact me at:  
asadi.sina@gmail.com  
sina.asadi1@louisiana.edu

Best,
SinaC
