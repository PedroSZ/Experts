//+------------------------------------------------------------------+
//|                                               lineaTendencia.mq4 |
//|                             Copyright 2023, Pedro Solano Zepeda. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Pedro Solano Zepeda."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   3
//--- plot Compra
#property indicator_label1  "Compra"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrLime
#property indicator_style1  STYLE_SOLID
#property indicator_width1  3
//--- plot Venta
#property indicator_label2  "Venta"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  3
//--- plot tmp
#property indicator_label3  "tmp"
#property indicator_type3   DRAW_LINE
#property indicator_style3  STYLE_SOLID
#property indicator_width3  3

extern int periodotmp = 12; //extern hace lo mismo que input pero con la posibilidad de cambiar el valor designado
extern int periodoRapido = 12;
extern int periodoLento = 30;


//--- indicator buffers
double         CompraBuffer[];
double         VentaBuffer[];
double         tmpBuffer[];
double precio1, precio2;

int limit;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,CompraBuffer);
   SetIndexBuffer(1,VentaBuffer);
   SetIndexBuffer(2,tmpBuffer);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
      limit = 1000;
      
      for(int i = limit; i>= 0;i--)
        {
            tmpBuffer[i]= iMA(NULL,0,periodotmp,0,MODE_SMA,PRICE_CLOSE,i);
            
            precio1= iMA(NULL,0,periodoRapido,0,MODE_SMA,PRICE_CLOSE,i);
            precio2= iMA(NULL,0,periodoLento,0,MODE_SMA,PRICE_CLOSE,i);
            
               if(precio1 > precio2)
                 {
                     CompraBuffer[i] = tmpBuffer[i];
                     CompraBuffer[i+1] = tmpBuffer[i+1];
                     VentaBuffer[i] = EMPTY_VALUE;
                 }
                 
                 if(precio1 < precio2)
                   {
                     VentaBuffer[i]= tmpBuffer[i];
                      VentaBuffer[i+1]= tmpBuffer[i+1];
                      VentaBuffer[i] = EMPTY_VALUE;
                   }
            
        }
      
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
