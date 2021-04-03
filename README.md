# MEMS-FPGA-accelerometer

Self-oscillating MEMS accelerometer controlled by an FPGA device.

| Operation principle |
|------------|
| <img src="/images/Fig1.png" width="250"> |

The device operates in a self-oscillating mode. This means that the sensitive element (inertial mass) oscillates along its promary axis. Oscillations are supported and controlled by the power drive coils. Also, several inertial mass positions trigger an optocoupler connected to the feedback loop. Acceleration can be measured by measuring the feedback signal. The information is encoded in its duty cycle and frequency.

| Variant with a laser position sensor |
|------------|
| <img src="/images/Fig3.png" width="250"> |

| Test control boards and the sensor |
|------------|
| <img src="/images/Fig4.jpg" width="250"> |

## FPGA_control

A control program for the accelerometer (FPGA Altera Cyclone III, Verilog, VHDL).

| FPGA configuration in Quartus |
|------------|
| <img src="/images/FPGA_configuration.png" width="250"> |

## images

The images of the prototype.

| The prototype |
|------------|
| <img src="/images/Fig2.png" width="500"> |

## MCU_converter

Firmware for the remote sensor control (STM32, C).


## Terminal_app

Application for the remote sensor control (Qt, C++).

| The control application |
|------------|
| <img src="/images/FigX.png" width="500"> |

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
├── range_and_error/
│   └── range_and_error_calculation.m
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

| Frequency responce of the inertial mass (different damping)     | Frequency responce of the output acceleration (different damping) |
|------------|-------------|
| <img src="/MATLAB_simulation/scripts/frequency_response/frequency_response_tau_damping.png" width="250"> | <img src="/MATLAB_simulation/scripts/frequency_response/frequency_response_acceleration_damping.png" width="250"> |

- `frequency_response_simulation_damping.m`
Runs the frquency responce simulation of the sensor with the selected damping


| Analitical calculation of the frequency response |
|------------|
| <img src="/MATLAB_simulation/scripts/frequency_response/frequency_response_analitical.png" width="250"> |

- `frequency_response_analitical.m`
Runs the frquency responce calculation of the sensor using three aproaches

### Nonlinearity estimate

| Nonlinearity estimate |
|------------|
| <img src="/MATLAB_simulation/scripts/nonlinearity_estimate/nonlinearity_estimate.png" width="250"> |

- `nonlinearity_estimate.m`
Calculates and compares the nonlinearity for different settings

### Range and error

| Error of the sensor with the different models used | Ranges of the sensor with different models used |
|------------|-------------|
| <img src="/MATLAB_simulation/scripts/range_and_error/error.png" width="250"> | <img src="/MATLAB_simulation/scripts/range_and_error/range.png" width="250"> |

- `range_and_error_calculation.m'
Calculates the range and error for the sensor

## Simulink model

Simulates the sensor operation and applies external acceleration. Linear acceleration is applied ni this example.

- `sensor_simulation.slx`

| Model overview | Simulation results |
|------------|-------------|
| <img src="/MATLAB_simulation/Simulink model/model.PNG" width="250"> | <img src="/MATLAB_simulation/Simulink model/results.png" width="250"> |