//+------------------------------------------------------------------+
//| CMockBEPriceSimulator                                            |
//| Implements : IBEPriceSimulator                                   |
//| Purpose    : 方向を含めたBEライン位置の簡易模擬計算               |
//+------------------------------------------------------------------+
#ifndef __CMOCK_BEPRICE_SIMULATOR_MQH__
#define __CMOCK_BEPRICE_SIMULATOR_MQH__

#include <03_Interface/IBEPriceSimulator.mqh>
#include <01_Config/EPT_EnvConfig.mqh>

#define __CLASS__ "CMockBEPriceSimulator"

class CMockBEPriceSimulator : public IBEPriceSimulator
{
public:
   double CalculateBEPrice(double entryPrice, double offsetPips, TradeDirection direction)
   {
      double result = (direction == BUY)
                      ? entryPrice + offsetPips * Point
                      : entryPrice - offsetPips * Point;

      LOG_ACTION_INFO_C("CalculateBEPrice: direction=" + (direction == BUY ? "BUY" : "SELL") +
                        ", entry=" + DoubleToString(entryPrice, Digits) +
                        ", offset=" + DoubleToString(offsetPips, 1) +
                        ", result=" + DoubleToString(result, Digits));

      return result;
   }
};

#endif