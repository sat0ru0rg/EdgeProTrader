#ifndef __TEST_BOOTSTRAP__
#define __TEST_BOOTSTRAP__

#include <Logic/CPositionModel.mqh>
#include <Logic/CEntryValidator.mqh>
#include <Logic/CBEPriceCalculator.mqh>

//+------------------------------------------------------------------+
//| 状態判定系モック構成（CPanelStateManagerの依存先を制御）              |
//+------------------------------------------------------------------+
struct MockConfig
{
    bool hasPosition;   // 現在ポジションを保有しているか
    bool isSpreadOK;    // スプレッドが許容範囲か
    bool isTradable;    // 時間帯がトレード可能か
    double bePrice;     // BE価格（>0で成立とみなす）
};

// グローバルに保持（必要であればstaticにも変更可）
MockConfig globalMockConfig;

// モック設定関数（上書き）
void SetMockConfig(MockConfig &cfg)
{
    globalMockConfig = cfg;
}

// モック取得関数（任意）
MockConfig GetMockConfig()
{
    return globalMockConfig;
}

//+------------------------------------------------------------------+
//| 依存クラスにモック状態を一括反映                                 |
//+------------------------------------------------------------------+
int OnInit_TestBootstrap(CPositionModel &positionModel,
                         CEntryValidator &validator,
                         CBEPriceCalculator &beCalculator,
                         bool isTestMode,
                         MockConfig &cfg)
{
    if (isTestMode)
    {
        positionModel.enableMock();
        validator.enableMock();
        beCalculator.enableMock();

        positionModel.setMock_HasOpenPosition(cfg.hasPosition);
        validator.setMock_IsSpreadAcceptable(cfg.isSpreadOK);
        validator.setMock_IsTradableTime(cfg.isTradable);
        beCalculator.setMock_BEPrice(cfg.bePrice);
    }

    return INIT_SUCCEEDED;
}

#endif // __TEST_BOOTSTRAP__
