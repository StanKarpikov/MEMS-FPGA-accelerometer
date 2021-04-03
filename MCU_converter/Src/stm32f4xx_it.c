/**
 * @file stm32f4xx_it.c
 * @author Stanislav Karpikov
 * @brief Interrupt handler routine
 */

/*--------------------------------------------------------------
                       INCLUDES
--------------------------------------------------------------*/

#include "stm32f4xx_hal.h"
#include "stm32f4xx.h"
#include "stm32f4xx_it.h"
#include "def.h"
#include <stdio.h>

/*--------------------------------------------------------------
                    PUBLIC FUNCTIONS
--------------------------------------------------------------*/

/**
 * @brief This function handles System tick timer.
 */
void SysTick_Handler(void)
{
  HAL_IncTick();
  HAL_SYSTICK_IRQHandler();
}

/**
 * @brief Timer 1 and 10 interrupt
 */
void TIM1_UP_TIM10_IRQHandler(void){
  timer9++;
  HAL_TIM_IRQHandler(&htim10);
}

/**
 * @brief This function handles EXTI Line1 interrupt.
 */
void EXTI1_IRQHandler(void)
{
  if(HAL_GPIO_ReadPin(GPIOC,GPIO_PIN_1)==GPIO_PIN_SET){
        cntL=__HAL_TIM_GET_COUNTER(&htim10);
        cntH=timer9;
        
        t2=cntL+(cntH<<16);

        tau=(double)((double)t3-(double)t2-(double)t2)/(double)t3;
        if(tn>1)tauarray[tn++]=tau;
  }else{    
    cntL=__HAL_TIM_GET_COUNTER(&htim10);
    cntH=timer9;
    
    __HAL_TIM_SET_COUNTER( &htim10,0);
    timer9=0;
    
    t3=cntL+(cntH<<16);
    
    tau=(double)((double)t3-(double)t2-(double)t2)/(double)t3;   
    tauarray[tn++]=tau;
    
    if(tn>=2050){
      if(tnn>5){
        for(int i=1;i<2050;i++)printf("%f\n",tauarray[i]);
        tnn=0;
      }
      else tnn++;
      tn=0;
    }
  //  tau=0;
 //   D=2.0f/3.0f*4095.0f*(-tau+0.5f)*1000.0f;
    if(tau>0)D=(((int)(tau*1000000.0f))%4000)*1;
    else D=(((int)(-tau*1000000.0f))%4000)*1;
    DAC_SetChannel1Data(DAC_Align_12b_R, D);
  }

  fr=!fr;
  HAL_GPIO_EXTI_IRQHandler(GPIO_PIN_1);
}

/**
* @brief This function handles EXTI Line2 interrupt.
*/
void EXTI2_IRQHandler(void)
{
  HAL_GPIO_EXTI_IRQHandler(GPIO_PIN_2);
}
