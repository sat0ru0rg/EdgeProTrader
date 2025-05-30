#ifndef __CENTRYVALIDATOR__
#define __CENTRYVALIDATOR__

#include "../Common/CommonDefs.mqh"

//+------------------------------------------------------------------+
//| エントリー可否の条件判定を行うクラス（スプレッド・時間帯など）          |
//| - モック機能によりテスト時に強制的な制御が可能                         |
//+------------------------------------------------------------------+
class CEntryValidator
{
private:
    bool useMock;
    bool mockIsSpreadOK;
    bool mockIsTradable;

public:
    CEntryValidator()
    {
        useMock = false;
        mockIsSpreadOK = true;
        mockIsTradable = true;
    }

    // --- モック切替ON/OFF
    void enableMock(bool enable = true)
    {
        useMock = enable;
    }

    // --- モック用の状態設定
    void setMock_IsSpreadAcceptable(bool val) { mockIsSpreadOK = val; }
    void setMock_IsTradableTime(bool val)     { mockIsTradable = val; }

    // --- 外部公開関数：スプレッド条件判定
    bool isSpreadAcceptable()
    {
        if (useMock)
        {
            LOG_TEST_DEBUG("Mock isSpreadAcceptable → " + (mockIsSpreadOK ? "true" : "false"));
            return mockIsSpreadOK;
        }

        // 通常のスプレッド条件ロジック（本実装省略）
        return true;
    }

    // --- 外部公開関数：トレード時間帯条件判定
    bool isTradableTime()
    {
        if (useMock)
        {
            LOG_TEST_DEBUG("Mock isTradableTime → " + (mockIsTradable ? "true" : "false"));
            return mockIsTradable;
        }

        // 通常の時間帯判定ロジック（本実装省略）
        return true;
    }
};

#endif // __CENTRYVALIDATOR__
