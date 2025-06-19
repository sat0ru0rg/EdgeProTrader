//+------------------------------------------------------------------+
//| IBEPriceSimulator                                                |
//| Interface Type : [Mock切替対応]                                  |
//| Used by        : EntryUI, Visualizer                             |
//| Purpose        : Entry + Offset + Direction に基づく BE 位置算出 |
//+------------------------------------------------------------------+
#ifndef __IBE_PRICE_SIMULATOR_MQH__
#define __IBE_PRICE_SIMULATOR_MQH__

enum TradeDirection
{
   BUY = 0,
   SELL = 1
};

class IBEPriceSimulator
{
public:
   virtual double CalculateBEPrice(double entryPrice, double offsetPips, TradeDirection direction) = 0;
};

#endif
