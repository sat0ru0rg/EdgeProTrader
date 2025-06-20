#ifndef __CPANELSTATE__
#define __CPANELSTATE__

#include <00_Common/CommonDefs.mqh>  // PanelStateCode の定義を含む

class CPanelState
{
private:
    PanelStateCode m_enumValue;
    string         m_name;

    /// @brief プライベートコンストラクタ：外部からのインスタンス化を禁止
    CPanelState(PanelStateCode value, string name)
    {
        m_enumValue = value;
        m_name      = name;
    }

public:
    // --- アクセサ ---
    string GetName() { return m_name; }
    PanelStateCode GetCode() { return m_enumValue; }

    bool Equals(CPanelState* other)
    {
        return (m_enumValue == other.GetCode());
    }

    // --- 正常系状態 ---
    static CPanelState* GetIdle()
    {
        static CPanelState state(STATE_Idle, "Idle");
        return &state;
    }

    static CPanelState* GetReadyToEntry()
    {
        static CPanelState state(STATE_ReadyToEntry, "ReadyToEntry");
        return &state;
    }

    static CPanelState* GetPositionOpen()
    {
        static CPanelState state(STATE_PositionOpen, "PositionOpen");
        return &state;
    }

    static CPanelState* GetBEAvailable()
    {
        static CPanelState state(STATE_BEAvailable, "BEAvailable");
        return &state;
    }

    // --- 異常系状態 ---
    static CPanelState* GetInvalid_DependencyNull()
    {
        static CPanelState state(STATE_Invalid_DependencyNull, "Invalid_DependencyNull");
        return &state;
    }

    static CPanelState* GetInvalid_MissingSL()
    {
        static CPanelState state(STATE_Invalid_MissingSL, "Invalid_MissingSL");
        return &state;
    }

    static CPanelState* GetInvalid_BEWithNoPosition()
    {
        static CPanelState state(STATE_Invalid_BEWithNoPosition, "Invalid_BEWithNoPosition");
        return &state;
    }

    static CPanelState* GetInvalid()
    {
        return GetInvalid_DependencyNull();  // デフォルト
    }

    // --- 文字列から状態を取得（テストやUI用） ---
    static CPanelState* FromString(string name)
    {
        if (StringCompare(name, "Idle") == 0) return GetIdle();
        if (StringCompare(name, "ReadyToEntry") == 0) return GetReadyToEntry();
        if (StringCompare(name, "PositionOpen") == 0) return GetPositionOpen();
        if (StringCompare(name, "BEAvailable") == 0) return GetBEAvailable();
        if (StringCompare(name, "Invalid_DependencyNull") == 0) return GetInvalid_DependencyNull();
        if (StringCompare(name, "Invalid_MissingSL") == 0) return GetInvalid_MissingSL();
        if (StringCompare(name, "Invalid_BEWithNoPosition") == 0) return GetInvalid_BEWithNoPosition();
        return GetInvalid();
    }

    // --- enum値から状態を取得（状態コード → 状態名） ---
    static CPanelState* FromEnum(PanelStateCode code)
    {
        switch (code)
        {
            case STATE_Idle: return GetIdle();
            case STATE_ReadyToEntry: return GetReadyToEntry();
            case STATE_PositionOpen: return GetPositionOpen();
            case STATE_BEAvailable: return GetBEAvailable();
            case STATE_Invalid_DependencyNull: return GetInvalid_DependencyNull();
            case STATE_Invalid_MissingSL: return GetInvalid_MissingSL();
            case STATE_Invalid_BEWithNoPosition: return GetInvalid_BEWithNoPosition();
            default: return GetInvalid();
        }
    }
};

#endif // __CPANELSTATE__
