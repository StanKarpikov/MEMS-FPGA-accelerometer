/**
 * @file stm32f4xx_hal_msp.c
 * @author Stanislav Karpikov
 * @brief HAL MSP supplementary functions
 */

/*--------------------------------------------------------------
                       INCLUDES
--------------------------------------------------------------*/

#include "stm32f4xx_hal.h"

/*--------------------------------------------------------------
                    PUBLIC FUNCTIONS
--------------------------------------------------------------*/

/**
 * Initializes the Global MSP.
 */
void HAL_MspInit(void)
{
  HAL_NVIC_SetPriorityGrouping(NVIC_PRIORITYGROUP_0);

  /* System interrupt init*/
/* SysTick_IRQn interrupt configuration */
  HAL_NVIC_SetPriority(SysTick_IRQn, 0, 1);
}

/**
 * Initializes the DAC
 */
void HAL_DAC_MspInit(DAC_HandleTypeDef* hdac)
{

  GPIO_InitTypeDef GPIO_InitStruct;
  if(hdac->Instance==DAC)
  {
    /* Peripheral clock enable */
    __DAC_CLK_ENABLE();
  
    /**DAC GPIO Configuration    
    PA5     ------> DAC_OUT2 
    */
    GPIO_InitStruct.Pin = GPIO_PIN_5;
    GPIO_InitStruct.Mode = GPIO_MODE_ANALOG;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);
  }

}

/**
 * De-initializes the DAC
 */
void HAL_DAC_MspDeInit(DAC_HandleTypeDef* hdac)
{

  if(hdac->Instance==DAC)
  {
    /* Peripheral clock disable */
    __DAC_CLK_DISABLE();
  
    /**DAC GPIO Configuration    
    PA5     ------> DAC_OUT2 
    */
    HAL_GPIO_DeInit(GPIOA, GPIO_PIN_5);

  }
}

/**
 * Initializes the timer
 */
void HAL_TIM_Base_MspInit(TIM_HandleTypeDef* htim_base)
{

  if(htim_base->Instance==TIM9)
  {
    /* Peripheral clock enable */
    __TIM9_CLK_ENABLE();
  }
  else if(htim_base->Instance==TIM10)
  {
    /* Peripheral clock enable */
    __TIM10_CLK_ENABLE();
  }

}

/**
 * De-initializes the timer
 */
void HAL_TIM_Base_MspDeInit(TIM_HandleTypeDef* htim_base)
{

  if(htim_base->Instance==TIM9)
  {
    /* Peripheral clock disable */
    __TIM9_CLK_DISABLE();
  }
  else if(htim_base->Instance==TIM10)
  {
    /* Peripheral clock disable */
    __TIM10_CLK_DISABLE();
  }

}
