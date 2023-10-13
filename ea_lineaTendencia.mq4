//+------------------------------------------------------------------+
//|                                            ea_lineaTendencia.mq4 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern double Magic = 123; //Identificador del Bot
extern double Lot = 0.01; //Lotaje
extern int TakeProfit = 5; // Tomar Ganancia
extern int StopLoss = 3; // Detener Operacion por perdida

extern int periodotmp = 12; //periodo ema temporal
extern int periodoRapido = 12; // periodo ema rapido
extern int periodoLento = 30; //periodo ema lento

double compra, venta;
int tiket;

bool Openbuy, OpenSell;

double pips;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Openbuy = false;
   OpenSell = false;

   if(Digits == 5 || Digits == 3)
     {
      pips= Point * 10;
     }
   else
     {
      pips = Point;
     }

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---       iCustom = indicador personalizado
   compra = iCustom(NULL,0,"lineaTendencia",periodotmp,periodoRapido,periodoLento,0,1);
   venta = iCustom(NULL,0,"lineaTendencia",periodotmp,periodoRapido,periodoLento,1,1);

   if(compra > 0 && venta == EMPTY_VALUE && Openbuy == false)
     {
      DelOrder(OP_SELL);
      //tiket = OrderSend(NULL,OP_BUY,Lot,Ask,5,Ask-StopLoss*pips,Ask+TakeProfit*pips,"Experto LineaTendencia",Magic,clrGreenYellow);
      tiket = OrderSend(NULL,OP_BUY,Lot,Ask,5,Ask-StopLoss*pips,0,"Experto LineaTendencia",Magic,clrGreenYellow);
      if(tiket < 0)
        {
         Print("ORDEN NO EJECUTADA, ERROR",GetLastError());
        }
      else
        {
         //Print("Orden generada correctamente ");
         Openbuy = true;
         OpenSell = false;
        }
     }

   if(venta > 0 && compra == EMPTY_VALUE && OpenSell == false)
     {
      DelOrder(OP_BUY);
      //tiket = OrderSend(NULL,OP_SELL,Lot,Bid,5,Bid+StopLoss*pips,Bid-TakeProfit*pips,"Experto LineaTendencia",Magic,clrRed);
      tiket = OrderSend(NULL,OP_SELL,Lot,Bid,5,Bid+StopLoss*pips,0,"Experto LineaTendencia",Magic,clrRed);

      if(tiket < 0)
        {
         Print("ORDEN NO EJECUTADA, ERROR",GetLastError());
        }
      else
        {
         // Print("Orden generada correctamente ");
         Openbuy = false;
         OpenSell = true;

        }
     }

  }
//+------------------------------------------------------------------+
void DelOrder(int type = -1)
  {
   bool del;
   for(int i=OrdersTotal() -1; i >= 0; i--)
     {

      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == Magic)
           {
            if(OrderType() == type || type == -1)
              {
               if(OrderType()==OP_BUY)
                 {OrderClose(OrderTicket(),OrderLots(),Bid,5);}
               if(OrderType()==OP_SELL)
                 {OrderClose(OrderTicket(),OrderLots(),Ask,5);}
              }
           }
        }

     }

  }
//+------------------------------------------------------------------+
