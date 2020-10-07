extern TIM_HandleTypeDef htim9;
extern TIM_HandleTypeDef htim10;
extern DAC_HandleTypeDef hdac;

extern uint32_t t3, t2,cntL,cntH,D;
extern double tau,tau_old;
extern float tauarray[5000];
extern uint32_t timer9,tn,tnn;
extern uint8_t Fout;
extern uint8_t fr;

#define DAC_Align_12b_R                    ((uint32_t)0x00000000)
#define DAC_Align_12b_L                    ((uint32_t)0x00000004)
#define DAC_Align_8b_R                     ((uint32_t)0x00000008)

#define DAC_Channel_1                      ((uint32_t)0x00000000)
#define DHR12R1_OFFSET             ((uint32_t)0x00000008)

void DAC_SetChannel1Data(uint32_t DAC_Align, uint16_t Data);
void DAC_SetChannel2Data(uint32_t DAC_Align, uint16_t Data);