//+------------------------------------------------------------------+
//| CMockBEPriceCalculator                                           |
//| Implements : IBEPriceCalculator                                  |
//| Purpose    : BE価格計算をダミー実装（+1.0pips固定）                  |
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
      m_offsetPips = 1.0;
   }

   // --- モック定義：常に entry + offset を返す
   double CalculateTrueBEPrice(int ticket)
   {
      double entry = 1.2345; // ダミー
      double result = entry + m_offsetPips * Point;

      LOG_ACTION_INFO_C("CalculateTrueBEPrice called: ticket=" + IntegerToString(ticket) +
                        ", entry=" + DoubleToString(entry, Digits) +
                        ", result=" + DoubleToString(result, Digits));
      return result;
   }

   double CalculateTrueBEPriceWithSlippage(int ticket, double slippage)
   {
      double entry = 1.2345; // ダミー
      double result = entry + (m_offsetPips + slippage) * Point;

      LOG_ACTION_INFO_C("CalculateTrueBEPriceWithSlippage called: ticket=" + IntegerToString(ticket) +
                        ", entry=" + DoubleToString(entry, Digits) +
                        ", slippage=" + DoubleToString(slippage, 1) +
                        ", result=" + DoubleToString(result, Digits));
      return result;
   }
};

#endif
