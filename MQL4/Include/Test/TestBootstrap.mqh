//+------------------------------------------------------------------+
//| TestBootstrap.mqh                                                |
//| モック有効化＆状態構成を一括制御する共通ヘッダー                |
//+------------------------------------------------------------------+

#ifndef __TEST_BOOTSTRAP__
#define __TEST_BOOTSTRAP__

#include <Logic/CPositionModel.mqh>
#include <Logic/CEntryValidator.mqh>
#include <Logic/CBEPriceCalculator.mqh>

// 状態判定系のモック構成
struct MockConfig
{
    bool hasPosition;
    bool isSpreadOK;
    bool isTradable;
    double bePrice;
};

// 発注ロジック系のモック構成（仮想発注価格など）
struct OrderMockConfig
{
    double entryPrice;
    double stopLoss;
    double takeProfit;
    double lotSize;
    int slippage;
};

// 状態判定用モックの初期化関数
int OnInit_TestBootstrap(CPositionModel &positionModel,
                         CEntryValidator &validator,
                         CBEPriceCalculator &beCalculator,
                         bool isTestMode,
                         MockConfig cfg)
{
    if (isTestMode)
    {
        // 各クラスのモック有効化
        positionModel.enableMock();
        validator.enableMock();
        beCalculator.enableMock();

        // モック値を引数から設定
        positionModel.setMock_HasOpenPosition(cfg.hasPosition);
        validator.setMock_IsSpreadAcceptable(cfg.isSpreadOK);
        validator.setMock_IsTradableTime(cfg.isTradable);
        beCalculator.setMock_BEPrice(cfg.bePrice);
    }
    return INIT_SUCCEEDED;
}

#endif
