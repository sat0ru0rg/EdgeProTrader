#include "..\..\Include\Trade\TradeExecutor.mqh"
#include "..\..\Include\Trade\PriceCalculator.mqh"  // ← SL/TP計算で使用

struct EntryRiskTestCase {
    string name;
    bool isBuy;
    double fixedLot;
    double riskPercent;
    double slPips;
    double tpPips;
    int magic;
};

EntryRiskTestCase cases[] = {
    {"Case3_SELL_SL100_TP100", false, 5.0, 2.0, 10, 10, 14003},
    {"Case4_SELL_SL200_TP200", false, 5.0, 2.0, 20, 20, 14004},
    {"Case1_BUY_SL100_TP100",  true, 5.0, 2.0, 10, 10, 14001},
    {"Case2_BUY_SL200_TP200",  true, 5.0, 2.0, 20, 20, 14002},
};

int OnInit()
{
    Print("== EdgePro EntryRisk テスト（PriceCalculator対応）開始 ==");

    double entryPrice = NormalizeDouble(Bid + Ask, Digits) / 2;  // 中間価格を仮エントリー値として使用
    double stopsLevel = MarketInfo(Symbol(), MODE_STOPLEVEL);

    for (int i = 0; i < ArraySize(cases); i++) {
        EntryRiskTestCase c = cases[i];
        Print("");
        Print(">> Running Test: ", c.name);

        double slPrice = CalculateSL(entryPrice, c.slPips, c.isBuy);
        double tpPrice = CalculateTP(entryPrice, c.tpPips, c.isBuy);
        double slDistance = MathAbs(entryPrice - slPrice) / MarketInfo(Symbol(), MODE_POINT);

        // StopsLevelチェック（必須）
        if (slDistance < stopsLevel) {
            PrintFormat("[SKIP] SL距離 %.1f < StopsLevel %.1f", slDistance, stopsLevel);
            continue;
        }

        TradeExecutor exec(c.fixedLot, c.riskPercent);

        PrintFormat("[DEBUG] Entry=%.5f SL=%.5f TP=%.5f (%.1f pips)", entryPrice, slPrice, tpPrice, c.slPips);

        bool result = c.isBuy ?
            exec.BuyAutoRisk(entryPrice, slPrice, tpPrice, Symbol(), 3, c.magic) :
            exec.SellAutoRisk(entryPrice, slPrice, tpPrice, Symbol(), 3, c.magic);

        Print(result ? "[PASS] 発注成功" : "[FAIL] 発注失敗");
    }

    Print("== EdgePro EntryRisk テスト終了 ==");
    return INIT_SUCCEEDED;
}
