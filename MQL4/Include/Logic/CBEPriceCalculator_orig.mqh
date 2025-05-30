#ifndef __CBEPRICECALCULATOR__
#define __CBEPRICECALCULATOR__

#include "../Common/CommonDefs.mqh"

//------------------------------------------------------------------
// 建値（Break-Even）価格を計算するクラス（モック内蔵）
// - 手数料、スプレッド、スワップ考慮
// - モック時は固定価格返却に切替可能
//------------------------------------------------------------------
class CBEPriceCalculator
{
private:
    bool useMock;
    double mockBEPrice;

public:
    CBEPriceCalculator()
    {
        useMock = false;
        mockBEPrice = 0.0;
    }

    // --- モック制御 ---
    void enableMock(bool enable) { useMock = enable; }
    void setMockBEPrice(double price) { mockBEPrice = price; }

    // --- 外部向け：±0円損益となるBE価格を返す（モードにより切替）
    double CalculateTrueBEPrice(int ticket)
    {
        if (useMock)
        {
            LOG_TEST_DEBUG("Mock BEPrice = " + DoubleToString(mockBEPrice, Digits));
            return mockBEPrice;
        }

        if (!OrderSelect(ticket, SELECT_BY_TICKET))
        {
            LOG_LOGIC_ERROR("OrderSelect failed in CalculateTrueBEPrice()");
            return 0.0;
        }

        double slippagePips = SL_BE_SlippagePips;
        return CalculateTrueBEPriceWithSlippage(ticket, slippagePips);
    }

private:
    // --- 内部：スリッページ等を含めた実BE価格計算
    double CalculateTrueBEPriceWithSlippage(int ticket, double slippagePips)
    {
        if (!OrderSelect(ticket, SELECT_BY_TICKET))
        {
            LOG_LOGIC_ERROR("OrderSelect failed in CalculateTrueBEPriceWithSlippage()");
            return 0.0;
        }

        double entryPrice = OrderOpenPrice();
        double lotSize    = OrderLots();

        double tickValue = MarketInfo(OrderSymbol(), MODE_TICKVALUE);
        double tickSize  = MarketInfo(OrderSymbol(), MODE_POINT);
        double pipSize   = GetPipSize(OrderSymbol());
        double pipValue  = tickValue * (pipSize / tickSize);  // ✅ pipValue補正！

        if (lotSize <= 0.0 || pipValue <= 0.0)
        {
            LOG_LOGIC_ERROR("Invalid lotSize or pipValue");
            return entryPrice;
        }

        double commissionJPY = OrderCommission();
        double swapJPY       = OrderSwap();
        double totalJPY      = commissionJPY + swapJPY;

        double offsetPips  = MathAbs(totalJPY / pipValue);
        double offsetPrice = MathAbs(PipsToPrice(offsetPips, OrderSymbol()));

        int type = OrderType();
        double bePrice;

        if (type == OP_BUY)
            bePrice = entryPrice + offsetPrice;
        else if (type == OP_SELL)
            bePrice = entryPrice - offsetPrice;
        else
        {
            LOG_LOGIC_ERROR("Unsupported OrderType: " + IntegerToString(type));
            return entryPrice;
        }

        if (MathAbs(bePrice) < 1.0 || MathAbs(bePrice) > 1000.0)
        {
            LOG_LOGIC_ERROR("Abnormal BE price detected");
            return entryPrice;
        }

        return bePrice;
    }
};

#endif // __CBEPRICECALCULATOR__
