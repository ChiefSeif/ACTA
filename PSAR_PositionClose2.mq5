#include<Trade/Trade.mqh>

CTrade trade;

void OnTick()
  {
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   
   double Balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double Equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double DynamicPositionSize = NormalizeDouble((Equity / 100000), 2);
   double LotSize = 0.10;
   
   MqlRates PriceArray[];
   ArraySetAsSeries(PriceArray, true);
   int Data = CopyRates(Symbol(), PERIOD_M1, 0, 3, PriceArray);
   double currentPrice = PriceArray[0].low;
   double lastPrice = PriceArray[1].high;
   /*
   double RSIArray[];
   int RSI_Def = iRSI(_Symbol, PERIOD_M1, 14, PRICE_CLOSE);
   ArraySetAsSeries(RSIArray, true);
   CopyBuffer(RSI_Def, 0, 0, 3, RSIArray);
   double currentRSI = NormalizeDouble(RSIArray[0], 2);
   double lastRSI = NormalizeDouble(RSIArray[1], 2);
   double RSIoverbought = 70;
   double RSIoversold = 30;
   */
   double SARArray[];
   int SAR_Def = iSAR(_Symbol, PERIOD_M1, 0.02, 0.2);
   ArraySetAsSeries(SARArray, true);
   CopyBuffer(SAR_Def, 0, 0, 3, SARArray);
   double currentSAR = NormalizeDouble(SARArray[0], 5);
   double lastSAR = NormalizeDouble(SARArray[1], 5);
   
      double thirdSignal = 0;
      double fourthSignal = 0;

   /*
   if((currentRSI > lastRSI) && (lastRSI < RSIoversold))
     {
      firstSignal = 1;
     }
   if((currentRSI > RSIoversold) && (lastRSI < RSIoversold))
     {
      secondSignal = 1;
     }
     */

   double BUY_StopLoss = (Ask - 500 * _Point);
   double BUY_TakeProfit = (Ask + (Ask * 0.005));
   
   double MaxPositions = 0;
   if(Equity < (Balance * 0.95))MaxPositions = 1;
     else(MaxPositions = 5);
   
   if((currentSAR < currentPrice) && (lastSAR > currentPrice))
     {
      if((PositionsTotal() < MaxPositions))
     {
      trade.Buy(LotSize, NULL, Ask, 0, BUY_TakeProfit, NULL);
     }
   }
   else
     {
   if((currentSAR > currentPrice))
     {
      CloseAllPositions();
     } 
     }
     
   Comment ("MaxPositions: ", MaxPositions);

   }
   
void CloseAllPositions()
   {
      for(int i = PositionsTotal(); i > 0; i--)
        {
         int ticket = PositionGetTicket(i);
         
         trade.PositionClose(i);
        }
   }