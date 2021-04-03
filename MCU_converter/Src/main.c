/**
 * @file main.c
 * @author Stanislav Karpikov
 * @brief Application entry point
 */

/*--------------------------------------------------------------
                       INCLUDES
--------------------------------------------------------------*/

#include "stm32f4xx_hal.h"
#include "def.h"
#include <stdio.h>

/*--------------------------------------------------------------
                    PRIVATE DEFINES
--------------------------------------------------------------*/

#define MCU_LEVEL_COUNTER (0) /**< Set to 1 to use the counter on the MCU. Otherwise FPGA counter is used */
#define USE_DAC_OUTPUT (0) /**< Set to 1 to output acceleration data to the DAC */
#define PRINT_DAC_OUTPUT (0) /**< Set to 1 to print acceleration data to the terminal */

/** DAC init function */
#define DAC_Trigger_None                   ((uint32_t)0x00000000)
#define DAC_WaveGeneration_None            ((uint32_t)0x00000000)
#define DAC_OutputBuffer_Enable   ((uint32_t)0x00000000)
#define DAC_Channel_2             ((uint32_t)0x00000010)

#define RCC_APB1Periph_DAC               ((uint32_t)0x20000000)
#define DHR12R2_OFFSET             ((uint32_t)0x00000014)

/** ADC CCR register Mask */
#define CR_CLEAR_MASK             ((uint32_t)0xFFFC30E0)  

/*--------------------------------------------------------------
                    PRIVATE TYPES
--------------------------------------------------------------*/

/** DAC initialisation structure */
typedef struct
{
  uint32_t DAC_Trigger;                      /*!< Specifies the external trigger for the selected DAC channel.
                                                  This parameter can be a value of @ref DAC_trigger_selection */

  uint32_t DAC_WaveGeneration;               /*!< Specifies whether DAC channel noise waves or triangle waves
                                                  are generated, or whether no wave is generated.
                                                  This parameter can be a value of @ref DAC_wave_generation */

  uint32_t DAC_LFSRUnmask_TriangleAmplitude; /*!< Specifies the LFSR mask for noise wave generation or
                                                  the maximum amplitude triangle generation for the DAC channel. 
                                                  This parameter can be a value of @ref DAC_lfsrunmask_triangleamplitude */

  uint32_t DAC_OutputBuffer;                 /*!< Specifies whether the DAC channel output buffer is enabled or disabled.
                                                  This parameter can be a value of @ref DAC_output_buffer */
}DAC_InitTypeDef;


/*--------------------------------------------------------------
                     PRIVATE DATA
--------------------------------------------------------------*/

 DAC_HandleTypeDef hdac;
 TIM_HandleTypeDef htim9;
 TIM_HandleTypeDef htim10;
 uint32_t t3, t2,cntL,cntH,D;
 double tau,tau_old;
 float tauarray[5000];
 uint32_t timer9,tn,tnn;
 uint8_t Fout;
 uint8_t fr;

/*--------------------------------------------------------------
              PRIVATE FUNCTIONS PROTOTYPES
--------------------------------------------------------------*/

void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_DAC_Init(void);
static void MX_TIM9_Init(void);
static void MX_TIM10_Init(void);

/*--------------------------------------------------------------
                       PUBLIC FUNCTIONS
--------------------------------------------------------------*/

/**
 * @brief Application entry point
 */
int main(void)
{
  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();
  
  /* Configure the system clock */
  SystemClock_Config();
  
  /* Initialize all configured peripherals */
  MX_DAC_Init();
  for(int i=1;i<1000000;i++);
  MX_GPIO_Init();
#if MCU_LEVEL_COUNTER==1
  MX_TIM9_Init();
#endif
  MX_TIM10_Init(); 
  timer9=0;
  fr=0;
  HAL_TIM_Base_Start(&htim10);  
  
  Fout=0;
  tn=0;
  HAL_GPIO_WritePin(GPIOC,GPIO_PIN_0,GPIO_PIN_SET);  
  HAL_GPIO_WritePin(GPIOC,GPIO_PIN_1,GPIO_PIN_RESET); 
    
  HAL_GPIO_WritePin(GPIOD,GPIO_PIN_12,GPIO_PIN_SET); 
  HAL_GPIO_WritePin(GPIOD,GPIO_PIN_13,GPIO_PIN_SET);        
  HAL_GPIO_WritePin(GPIOD,GPIO_PIN_14,GPIO_PIN_SET); 
  HAL_GPIO_WritePin(GPIOD,GPIO_PIN_15,GPIO_PIN_SET);
 
  //        - Leds:
  //            - LED_GREEN      on PD12
  //            - LED_ORANGE     on PD13
  //            - LED_RED        on PD14
  //            - LED_BLUE       on PD15
  while (1)
  {
#if MCU_LEVEL_COUNTER==1
    if(HAL_GPIO_ReadPin(GPIOC,GPIO_PIN_1)==GPIO_PIN_SET && fr==GPIO_PIN_RESET){
        fr=GPIO_PIN_SET;
        cntL=__HAL_TIM_GET_COUNTER(&htim10);
        cntH=timer9;
        
        t2=cntL+(cntH<<16);  
    }else if(HAL_GPIO_ReadPin(GPIOC,GPIO_PIN_1)==GPIO_PIN_RESET && fr==GPIO_PIN_SET){  
        fr=GPIO_PIN_RESET;
        cntL=__HAL_TIM_GET_COUNTER(&htim10);
        cntH=timer9;
    
        __HAL_TIM_SET_COUNTER( &htim10,0);
        timer9=0;
    
        t3=cntL+(cntH<<16);
    
        tau=(double)((double)t3-(double)t2-(double)t2)/(double)t3;   
        tauarray[tn++]=t3;
        if(tn>=5000){
          for(int i=0;i<5000;i++)printf("%i\n",tauarray[i]);
          tn=0;
        }
        D=(double)2.0f/3.0f*4095.0f*(tau+0.5f);
    }
#if USE_DAC_OUTPUT==1
    HAL_DAC_SetValue(&hdac,DAC_ALIGN_12B_R,DAC_CHANNEL_2, D); 
#endif
#if PRINT_DAC_OUTPUT=1
    printf("%f\n",tauarray[tn-1]);
#endif
#endif
  }
}

/** 
 * @brief System Clock Configuration
 */
void SystemClock_Config(void)
{
  
  RCC_OscInitTypeDef RCC_OscInitStruct;
  RCC_ClkInitTypeDef RCC_ClkInitStruct;
  
  __PWR_CLK_ENABLE();
  
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);
  
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLM = 8;
  RCC_OscInitStruct.PLL.PLLN = 336;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = 7;
  HAL_RCC_OscConfig(&RCC_OscInitStruct);
  
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_SYSCLK|RCC_CLOCKTYPE_PCLK1
    |RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV8;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV2;
  HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_5);
  
  HAL_SYSTICK_Config(HAL_RCC_GetHCLKFreq()/1000);
  
  HAL_SYSTICK_CLKSourceConfig(SYSTICK_CLKSOURCE_HCLK);
  
}

/**
 * @brief Execute DAC command
 *
 * @param DAC_Channel 
 * @param NewState
 */
void DAC_Cmd(uint32_t DAC_Channel, FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_DAC_CHANNEL(DAC_Channel));
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    /* Enable the selected DAC channel */
    DAC->CR |= (DAC_CR_EN1 << DAC_Channel);
  }
  else
  {
    /* Disable the selected DAC channel */
    DAC->CR &= (~(DAC_CR_EN1 << DAC_Channel));
  }
}


/**
 * @brief Initialise the DAC module
 *
 * @param DAC_Channel 
 * @param DAC_InitStruct
 */
void DAC_Init(uint32_t DAC_Channel, DAC_InitTypeDef* DAC_InitStruct)
{
  uint32_t tmpreg1 = 0, tmpreg2 = 0;

  /* Check the DAC parameters */
  assert_param(IS_DAC_TRIGGER(DAC_InitStruct->DAC_Trigger));
  assert_param(IS_DAC_GENERATE_WAVE(DAC_InitStruct->DAC_WaveGeneration));
  assert_param(IS_DAC_LFSR_UNMASK_TRIANGLE_AMPLITUDE(DAC_InitStruct->DAC_LFSRUnmask_TriangleAmplitude));
  assert_param(IS_DAC_OUTPUT_BUFFER_STATE(DAC_InitStruct->DAC_OutputBuffer));

/*---------------------------- DAC CR Configuration --------------------------*/
  /* Get the DAC CR value */
  tmpreg1 = DAC->CR;
  /* Clear BOFFx, TENx, TSELx, WAVEx and MAMPx bits */
  tmpreg1 &= ~(CR_CLEAR_MASK << DAC_Channel);
  /* Configure for the selected DAC channel: buffer output, trigger, 
     wave generation, mask/amplitude for wave generation */
  /* Set TSELx and TENx bits according to DAC_Trigger value */
  /* Set WAVEx bits according to DAC_WaveGeneration value */
  /* Set MAMPx bits according to DAC_LFSRUnmask_TriangleAmplitude value */ 
  /* Set BOFFx bit according to DAC_OutputBuffer value */   
  tmpreg2 = (DAC_InitStruct->DAC_Trigger | DAC_InitStruct->DAC_WaveGeneration |
             DAC_InitStruct->DAC_LFSRUnmask_TriangleAmplitude | \
             DAC_InitStruct->DAC_OutputBuffer);
  /* Calculate CR register value depending on DAC_Channel */
  tmpreg1 |= tmpreg2 << DAC_Channel;
  /* Write to DAC CR */
  DAC->CR = tmpreg1;
}


/**
 * @brief Configure DAC clock
 *
 * @param RCC_APB1Periph 
 * @param NewState
 */
void RCC_APB1PeriphClockCmd(uint32_t RCC_APB1Periph, FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_RCC_APB1_PERIPH(RCC_APB1Periph));  
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    RCC->APB1ENR |= RCC_APB1Periph;
  }
  else
  {
    RCC->APB1ENR &= ~RCC_APB1Periph;
  }
}


/**
 * @brief DAC data putput, channel 2
 *
 * @param DAC_Align 
 * @param Data Data to output
 */
void DAC_SetChannel2Data(uint32_t DAC_Align, uint16_t Data)
{
  __IO uint32_t tmp = 0;

  /* Check the parameters */
  assert_param(IS_DAC_ALIGN(DAC_Align));
  assert_param(IS_DAC_DATA(Data));
  
  tmp = (uint32_t)DAC_BASE;
  tmp += DHR12R2_OFFSET + DAC_Align;

  /* Set the DAC channel2 selected data holding register */
  *(__IO uint32_t *)tmp = Data;
}


/**
 * @brief DAC data putput, channel 1
 *
 * @param DAC_Align 
 * @param Data Data to output
 */
void DAC_SetChannel1Data(uint32_t DAC_Align, uint16_t Data)
{  
  __IO uint32_t tmp = 0;
  
  /* Check the parameters */
  assert_param(IS_DAC_ALIGN(DAC_Align));
  assert_param(IS_DAC_DATA(Data));
  
  tmp = (uint32_t)DAC_BASE; 
  tmp += DHR12R1_OFFSET + DAC_Align;

  /* Set the DAC channel1 selected data holding register */
  *(__IO uint32_t *) tmp = Data;
}

/**
 * @brief DAC init function
 */
void MX_DAC_Init(void)
{
  __GPIOA_CLK_ENABLE();
   GPIO_InitTypeDef GPIO_InitStruct;
    
  /*Configure GPIO pin : PA5 */
  GPIO_InitStruct.Pin = GPIO_PIN_4;
  GPIO_InitStruct.Mode = GPIO_MODE_ANALOG;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

DAC_InitTypeDef DAC_InitStructure;

  /* DAC channel2 Configuration */
  DAC_InitStructure.DAC_Trigger = DAC_Trigger_None;
  DAC_InitStructure.DAC_WaveGeneration = DAC_WaveGeneration_None;
  DAC_InitStructure.DAC_OutputBuffer = DAC_OutputBuffer_Enable; //
  DAC_Init(DAC_Channel_1, &DAC_InitStructure);
  
/* Enable DAC clock */
RCC_APB1PeriphClockCmd(RCC_APB1Periph_DAC, ENABLE);

DAC_Cmd(DAC_Channel_1, ENABLE);  

/* Used to test the DAC */
 DAC_SetChannel1Data(DAC_Align_12b_R, 0);
 DAC_SetChannel1Data(DAC_Align_12b_R, 100);
 DAC_SetChannel1Data(DAC_Align_12b_R, 200);
 DAC_SetChannel1Data(DAC_Align_12b_R, 1500);
}

/**
 * @brief TIM9 init function
 */
void MX_TIM9_Init(void)
{  
  TIM_SlaveConfigTypeDef sSlaveConfig;
  TIM_ClockConfigTypeDef sClockSourceConfig;
    
  htim9.Instance = TIM9;
  htim9.Init.Prescaler = 0;
  htim9.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim9.Init.Period = 0xFFFF;
  htim9.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  HAL_TIM_Base_Init(&htim9);
  
  sSlaveConfig.SlaveMode = TIM_SLAVEMODE_TRIGGER;
  sSlaveConfig.InputTrigger = TIM_TS_ITR2;
//  sSlaveConfig.TriggerPolarity = TIM_TRIGGERPOLARITY_RISING;
//  sSlaveConfig.TriggerPrescaler = TIM_TRIGGERPRESCALER_DIV1;
//  sSlaveConfig.TriggerFilter = 0;
  HAL_TIM_SlaveConfigSynchronization(&htim9, &sSlaveConfig);
  
  sClockSourceConfig.ClockSource = TIM_CLOCKSOURCE_ITR2;
  HAL_TIM_ConfigClockSource(&htim9, &sClockSourceConfig);
}

/**
 * @brief TIM10 init function 
 */
void MX_TIM10_Init(void)
{
  TIM_MasterConfigTypeDef sMasterConfig;
  
  htim10.Instance = TIM10;
  htim10.Init.Prescaler = 0;
  htim10.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim10.Init.Period = 0xFFFF;
  htim10.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  HAL_TIM_Base_Init(&htim10);
  
  sMasterConfig.MasterOutputTrigger = TIM_TRGO_OC1;
  sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_ENABLE;  
//  HAL_TIMEx_MasterConfigSynchronization(&htim10, &sMasterConfig);
  
  __HAL_TIM_SET_COMPARE(&htim10,TIM_CHANNEL_1,0xFFFF);
  HAL_TIM_OC_Init(&htim10);
  HAL_TIM_OC_Start(&htim10,TIM_CHANNEL_1);
  
  __HAL_TIM_ENABLE_IT(&htim10, TIM_IT_CC1);
  
  HAL_NVIC_SetPriority(TIM1_UP_TIM10_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(TIM1_UP_TIM10_IRQn);  
}

/** 
 * @brief Configuration of the pins. Callback from HAL
 */
void MX_GPIO_Init(void)
{
  
  GPIO_InitTypeDef GPIO_InitStruct;
  
  /* GPIO Ports Clock Enable */
  __GPIOC_CLK_ENABLE();
  __GPIOH_CLK_ENABLE();
  
  __GPIOB_CLK_ENABLE();
  __GPIOD_CLK_ENABLE();
  
#if USE_GPIO_INTERRUPT_ON_SECOND_CHANNEL==1
  /*Configure GPIO pins : PC0 PC1 */
  GPIO_InitStruct.Pin = GPIO_PIN_0|GPIO_PIN_1;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_HIGH;
  HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);
#endif 
  /*Configure GPIO pins : PC1 */
    GPIO_InitStruct.Pin = GPIO_PIN_1;
    GPIO_InitStruct.Mode = GPIO_MODE_IT_RISING_FALLING;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);
  
  /*Configure GPIO pin : PB2 */
  GPIO_InitStruct.Pin = GPIO_PIN_2;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_PULLUP;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);
  
  /*Configure GPIO pins : PD12 PD13 PD14 PD15 
  PD4 */
  GPIO_InitStruct.Pin = GPIO_PIN_12|GPIO_PIN_13|GPIO_PIN_14|GPIO_PIN_15 
    |GPIO_PIN_4;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_LOW;
  HAL_GPIO_Init(GPIOD, &GPIO_InitStruct);
  
  /* EXTI interrupt init*/
  HAL_NVIC_SetPriority(EXTI1_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(EXTI1_IRQn);
  
#if USE_GPIO_INTERRUPT_ON_SECOND_CHANNEL==1
 HAL_NVIC_SetPriority(EXTI2_IRQn, 0, 0);
 HAL_NVIC_EnableIRQ(EXTI2_IRQn);
#endif  
}


#ifdef USE_FULL_ASSERT

/**
* @brief Reports the name of the source file and the source line number
* where the assert_param error has occurred.
* @param file: pointer to the source file name
* @param line: assert_param error line source number
* @retval None
*/
void assert_failed(uint8_t* file, uint32_t line)
{

}

#endif
