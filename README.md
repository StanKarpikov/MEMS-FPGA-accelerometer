# MEMS-FPGA-accelerometer

Self-oscillating MEMS accelerometer based on a FPGA device

## FPGA_control

A control program for the accelerometer (FPGA Altera Cyclone III, Verilog).

## images

The images of the prototype.

## MCU_converter

Firmware for the remote sensor control (STM32, C).


## Terminal_app

Application for the remote sensor control (Qt, C++).

## MATLAB_simulation

The folder contains Matlab model for sensor parameters simulation.
Modules structure:

```
MATLAB_simulation/scripts/
├── noise_calculation/noise_simulation.m
│   ├── compute_sensing_element_position.m
│   └── compute_accurate_time.m
│       └── nl_system_for_t.m
```

Modules description:

### Noise simulation

Example results:

| Tau 1 mV noise      | Spectrum of the current      |
|------------|-------------|
| <img src="/MATLAB_simulation/scripts/noise_calculation/Results/tau_all_1mV.png" width="250"> | <img src="/MATLAB_simulation/scripts/noise_calculation/Results/spectr_I.png" width="250"> |

- `noise_simulation.m` 
Runs the simulation of the sensor noise
    
- `compute_sensing_element_position.m` 
Returns the calculated position of the sensing element
    
- `compute_accurate_time.m` 
Returns the precise timer value for zero-line intersection
    
- `nl_system_for_t.m` 
Supplementary function for non-linear solver (timer value for zero-line intersection)