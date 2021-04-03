# MEMS-FPGA-accelerometer

Self-oscillating MEMS accelerometer based on a FPGA device

## FPGA_control

A control program for the accelerometer (FPGA Altera Cyclone III, Verilog, VHDL).

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
├── noise_experiment/noise_experiment_results.m
├── frequency_response/
│   ├── frequency_response_simulation_damping.m
│   └── frequency_response_analitical.m
└── calculate_parameters_for_prototype.m
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

### Noise experiment results

| Spectrum of the current      |
|------------|
| <img src="/MATLAB_simulation/scripts/noise_experiment/Results.png" width="250"> |

- `noise_experiment_results.m`
Shows the results of the experimental noise measurement

### Frequency responce

| Frequency responce (raw data) of the inertial mass     | Frequency responce (raw data) of the output acceleration      |
|------------|-------------|
| <img src="/MATLAB_simulation/scripts/frequency_response/frequency_response_tau.png" width="250"> | <img src="/MATLAB_simulation/scripts/frequency_response/frequency_response_acceleration.png" width="250"> |

| Frequency responce of the inertial mass (different damping)     | Frequency responce of the output acceleration (different damping)      |
|------------|-------------|
| <img src="/MATLAB_simulation/scripts/frequency_response/frequency_response_tau_damping.png" width="250"> | <img src="/MATLAB_simulation/scripts/frequency_response/frequency_response_acceleration_damping.png" width="250"> |

- `frequency_response_simulation_damping.m`
Runs the frquency responce simulation of the sensor with the selected damping


| Analitical calculation of the frequency response     |
|------------|
| <img src="/MATLAB_simulation/scripts/frequency_response/frequency_response_analitical.png" width="250"> |

- `frequency_response_analitical.m`
Runs the frquency responce calculation of the sensor using three aproaches