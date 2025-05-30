//===========================
// TradeExecutor.mqh
//===========================
// 成行注文を実行するクラス（RiskManagerとの統合版）
// - Buy() / Sell(): 通常の固定ロット注文
// - BuyWithRisk() / SellWithRisk(): SLpips指定でロット自動計算
// - BuyAutoRisk() / SellAutoRisk(): entryPriceとSL価格指定でロット自動計算
// - MQL5移行を想定し、CTrade構造によるラッパー実装にも対応可能な設計
#ifndef __TRADEEXECUTOR_MQH__
#define __TRADEEXECUTOR_MQH__

#include <Common/CommonDefs.mqh>
#include <Logic/RiskManager.mqh>

#ifdef __MQL5__
#include <Trade\Trade.mqh>
CTrade trade;
#endif

class TradeExecutor
{
private:
    RiskManager risk;  // リスク管理クラス（固定ロット or リスク許容に応じた補正）

public:
    // --- コンストラクタ：ロットとリスク許容率をセット（初期化時に注入） ---
    TradeExecutor(double fixedLot, double riskPercent)
    : risk(fixedLot, riskPercent) {}

    // --- BUY（固定ロット発注） ---
    bool Buy(string symbol, double volume,
             double price = 0, double sl = 0, double tp = 0,
             int slippage = 3, int magic = 0, color clr = clrGreen)
    {
        if (symbol == NULL || symbol == "") symbol = Symbol();

        #ifdef __MQL5__
        if (price <= 0) SymbolInfoDouble(symbol, SYMBOL_ASK, price);
        trade.SetExpertMagicNumber(magic);
        bool result = trade.Buy(volume, symbol, price, sl, tp, clr);
        if (!result) DebugPrint("[BUY] trade.Buy失敗: " + IntegerToString(GetLastError()));
        return result;
        #else
        if (price <= 0) price = MarketInfo(symbol, MODE_ASK);
        int ticket = OrderSend(symbol, OP_BUY, volume, price, slippage, sl, tp, "EdgePro_Buy", magic, 0, clr);
        if (ticket < 0) {
            DebugPrint("[BUY] OrderSend失敗: " + IntegerToString(GetLastError()));
            return false;
        }
        return true;
        #endif
    }

    // --- SELL（固定ロット発注） ---
    bool Sell(string symbol, double volume,
              double price = 0, double sl = 0, double tp = 0,
              int slippage = 3, int magic = 0, color clr = clrRed)
    {
        if (symbol == NULL || symbol == "") symbol = Symbol();

        #ifdef __MQL5__
        if (price <= 0) SymbolInfoDouble(symbol, SYMBOL_BID, price);
        trade.SetExpertMagicNumber(magic);
        bool result = trade.Sell(volume, symbol, price, sl, tp, clr);
        if (!result) DebugPrint("[SELL] trade.Sell失敗: " + IntegerToString(GetLastError()));
        return result;
        #else
        if (price <= 0) price = MarketInfo(symbol, MODE_BID);
        int ticket = OrderSend(symbol, OP_SELL, volume, price, slippage, sl, tp, "EdgePro_Sell", magic, 0, clr);
        if (ticket < 0) {
            DebugPrint("[SELL] OrderSend失敗: " + IntegerToString(GetLastError()));
            return false;
        }
        return true;
        #endif
    }

    // --- BUY（SL幅からロットを自動計算し発注） ---
    bool BuyWithRisk(double slPips,
                     string symbol = NULL,
                     double price = 0, double sl = 0, double tp = 0,
                     int slippage = 3, int magic = 0, color clr = clrGreen)
    {
        double lot = risk.Calculate(slPips);
        return Buy(symbol, lot, price, sl, tp, slippage, magic, clr);
    }

    // --- SELL（SL幅からロットを自動計算し発注） ---
    bool SellWithRisk(double slPips,
                      string symbol = NULL,
                      double price = 0, double sl = 0, double tp = 0,
                      int slippage = 3, int magic = 0, color clr = clrRed)
    {
        double lot = risk.Calculate(slPips);
        return Sell(symbol, lot, price, sl, tp, slippage, magic, clr);
    }

    // --- BUY（エントリー価格とSL価格を指定しロットを自動算出） ---
    bool BuyAutoRisk(double entryPrice, double slPrice,
                     double tpPrice = 0, string symbol = NULL,
                     int slippage = 3, int magic = 0, color clr = clrGreen)
    {
        double lot = risk.CalcAdjustedLotByPrice(true, entryPrice, slPrice);
        return Buy(symbol, lot, entryPrice, slPrice, tpPrice, slippage, magic, clr);
    }

    // --- SELL（エントリー価格とSL価格を指定しロットを自動算出） ---
    bool SellAutoRisk(double entryPrice, double slPrice,
                      double tpPrice = 0, string symbol = NULL,
                      int slippage = 3, int magic = 0, color clr = clrRed)
    {
        double lot = risk.CalcAdjustedLotByPrice(false, entryPrice, slPrice);
        return Sell(symbol, lot, entryPrice, slPrice, tpPrice, slippage, magic, clr);
    }
};

#endif
