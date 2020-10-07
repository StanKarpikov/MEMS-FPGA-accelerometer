#include "comread.h"

COMRead::COMRead(QObject *parent) : QObject(parent){

}

void COMRead::process() {

}

void COMRead::open(){

COMport = CreateFile(L"COM2",GENERIC_READ | GENERIC_WRITE, 0,NULL, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, NULL);

            memset(&ComDCM,0,sizeof(ComDCM));
            ComDCM.DCBlength = sizeof(DCB);
            GetCommState(COMport, &ComDCM);
            ComDCM.BaudRate = DWORD(p.baudRate);
            ComDCM.ByteSize = p.dataBits;
            SetCommState(COMport, &ComDCM);

            COMSTAT comstat;							//Структура текущего состояния порта
            DWORD btr, temp, mask, signal;				//Переменные для потоков работы с портом
            OVERLAPPED overlappedR;
            char bufrd[255],bufwr[255];			//Буферы для приёма и передачи

            overlappedR.hEvent = CreateEvent(NULL, true, true, NULL);
            SetCommMask(COMport, EV_RXCHAR);       								//Устанавливается маска на срабатывание по событию приёма байта в порт

            while(1){
                WaitCommEvent(COMport, &mask, &overlappedR);					//Ожидание события приёма байта

                signal = WaitForSingleObject(overlappedR.hEvent, INFINITE);		//Приостановить поток до прихода байта.
                if(signal == WAIT_OBJECT_0){									//Если событие прихода байта произошло -
                  if(GetOverlappedResult(COMport, &overlappedR, &temp, true))	//проверяем, успешно ли завершилась WaitCommEvent.
                      if((mask & EV_RXCHAR)!=0){								//Если произошло именно событие прихода байта,

                        ClearCommError(COMport, &temp, &comstat);				//нужно заполнить структуру COMSTAT
                        btr = comstat.cbInQue;                          		//и получить из неё количество принятых байтов.
                        if(btr){                         						//Если действительно есть байты для чтения,
                            ReadFile(COMport, bufrd, btr, &temp, &overlappedR); //прочитать байты из порта в буфер программы.
                            for(BYTE j=0;j<(BYTE)btr;j++)
                                qDebug()<<bufrd[j];	//Обработать все байты

                        }
                      }
                }
            }
}
