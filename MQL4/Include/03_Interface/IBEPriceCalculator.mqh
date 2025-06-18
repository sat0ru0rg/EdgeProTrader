//+------------------------------------------------------------------+
//| IBEPriceCalculator                                               |
//| Interface Type : [Mock切替専用]                                  |
//| Implemented by : CBEPriceCalculator / CMockBEPriceCalculator     |
//| Used by        : CBEExecutor, SLManager                          |
//| 概要             : 建値（±0損益）となる価格を計算するための共通I/F      |
//+------------------------------------------------------------------+
#ifndef __IBE_PRICE_CALCULATOR_MQH__
#define __IBE_PRICE_CALCULATOR_MQH__

class IBEPriceCalculator
{
public:
   /// 建値（±0円）価格を返す（手数料／スプレッド考慮あり）
   virtual double CalculateTrueBEPrice(int ticket) = 0;

   /// スリッページ考慮の建値価格（指定pips分を補正）
   virtual double CalculateTrueBEPriceWithSlippage(int ticket, double slippagePips) = 0;
};

#endif
