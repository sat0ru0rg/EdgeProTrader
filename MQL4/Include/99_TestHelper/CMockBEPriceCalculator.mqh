//+------------------------------------------------------------------+
//| CMockBEPriceCalculator                                           |
//| Implements : IBEPriceCalculator                                  |
//| Purpose    : BEライン価格のダミー計算（固定オフセットで模擬）       |
//| ログ規約   : [ACTION] + ASSERT対応                                 |
//+------------------------------------------------------------------+
#ifndef __CMOCK_BEPRICE_CALCULATOR_MQH__
#define __CMOCK_BEPRICE_CALCULATOR_MQH__

#include <03_Interface/IBEPriceCalculator.mqh>
#include <01_Config/EPT_EnvConfig.mqh>  // ASSERT & LOGマクロ

#define __CLASS__ "CMockBEPriceCalculator"

class CMockBEPriceCalculator : public IBEPriceCalculator
{
private:
   double m_offsetPips;

public:
   CMockBEPriceCalculator()
   {
      m_offsetPips = 1.0; // 建値オフセットを+1.0pips固定で模擬
   }

   // 建値価格を計算（BUY）
   double CalculateBEPriceBuy(double entryPrice, double lot)
   {
      double offset = m_offsetPips * Point;
      double bePrice = entryPrice + offset;
      LOG_ACTION_INFO_C("CalculateBEPriceBuy called: entry=" + DoubleToString(entryPrice, Digits) +
                        ", lot=" + DoubleToString(lot, 2) +
                        ", BE=" + DoubleToString(bePrice, Digits));
      return bePrice;
   }

   // 建値価格を計算（SELL）
   double CalculateBEPriceSell(double entryPrice, double lot)
   {
      double offset = m_offsetPips * Point;
      double bePrice = entryPrice - offset;
      LOG_ACTION_INFO_C("CalculateBEPriceSell called: entry=" + DoubleToString(entryPrice, Digits) +
                        ", lot=" + DoubleToString(lot, 2) +
                        ", BE=" + DoubleToString(bePrice, Digits));
      return bePrice;
   }
};

#endif
