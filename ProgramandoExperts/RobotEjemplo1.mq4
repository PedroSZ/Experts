//+------------------------------------------------------------------+
//|                                                RobotEjemplo1.mq4 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

int Magic = 1; //Id del robot
double SL = 00.10; //VARIABLE STOP LOSS
double TP = 00.30; //VARIABLE TAKE PROFIT
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
  // Print("Nuestro Robot se ha cargado a la grafica");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  // Print("Nuestro robot se ha eliminado de la grafica");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
if(OperaconesAbiertas()==0)
  {
   if( Comprar()== true && FiltroCompra()== true )
  {
  //OrederSend para comprar
  // 0(PARAMETROS)entre los parentesis van los paramentros 
  // 1 Primer parametro "simbolo" por ejemplo USD/CAD o USD/JYP en este caso NULL para cualquiera 'NULL'
  // 2 Tipo de orden "OP_BUY" realiza una compra 
  // 3 Volumen "00.1" un microlote de volumen de compra
  // 4 Precio, "Ask" compra a orden de mercado "Bid" para ventas
  // 5 no estoy seguro pero creo "slippage" que es el spread o comision queda en '1'
  /* 6 stoploss indica en este caso por debajo del precio de cierre menos un cantidad de ATR "Close[1]-(iATR(NULL,0,23,1))
      es decir un SL por volatilidad,el ATR Recibe como parametros "NULL" que es el simbolo, ejemplo USD/CAD
      el siguiente parametro es el TimeFrame que en este caso es "0" y el period que es "23" y el shift seria "1"
      
      7 el Close[1] indica que cerrara por debajo de la vela 1 recuerda que se inicia desde la 0 como una cadena
  */
      OrderSend(NULL,OP_BUY,00.1,Ask,1,Close[1]-(iATR(NULL,0,23,1)*SL),Close[1]+(iATR(NULL,0,23,1)*TP),"COMPRA DE ROBOT EJEMPLO1",Magic);
   
  }
  }
  else
    {
     //HAY OPERACIONES ABIERTAS
    }
   

  }
//+------------------------------------------------------------------+

bool Comprar()
{
/*
Las velas se marcan con[0] y el numero en el interior corresponde al numero de vela
la vela actual o la ultima es 0 la anterior a la ultima es 1 y asi sucesivamente
*/
  if(High[1]>= iHigh(NULL, PERIOD_D1,0 ))
 //SI ALTO[1] >= ALTO DEL DIA(NULL, PERIODO, VELA DEL ALTO DEL DIA)
    {
 //Aqui se ejecutara todo el codigo cuando el alto de la vela anterior sea mayor al maximo del dia actual   
 return true;  //realizar compra
    }
    else
       return false;  //no comprar
      

}

bool FiltroCompra()
{
if(Hour()==6)
  {
   return true;
  }
  else
      return false;
}

int OperaconesAbiertas()
   {
      int NumOrdenes = 0;
      for(int i = 0; i < OrdersTotal(); i++)
      {
      //SELECT_BY_POST = orden actual
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)== true)
         {
            if(OrderType() == OP_BUY && OrderMagicNumber()== Magic)
            {
               NumOrdenes ++;
                break;
            }
         }
      }
      return NumOrdenes;
   }