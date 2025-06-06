#include "../Common/CommonDefs.mqh"  // PanelStateCode を参照

class CPanelState
{
private:
    PanelStateCode m_enumValue;
    string         m_name;

    CPanelState(PanelStateCode value, string name)
    {
        m_enumValue = value;
        m_name      = name;
    }

public:
    // --- アクセサ類 ---
    string getName()
    {
        return m_name;
    }

    PanelStateCode getCode()
    {
        return m_enumValue;
    }

    bool equals(CPanelState* other)
    {
        return (m_enumValue == other.getCode());
    }

    // --- 正常状態 ---
    static CPanelState* getIdle()
    {
        static CPanelState state(STATE_Idle, "Idle");
        return &state;
    }

    static CPanelState* getReadyToEntry()
    {
        static CPanelState state(STATE_ReadyToEntry, "ReadyToEntry");
        return &state;
    }

    static CPanelState* getPositionOpen()
    {
        static CPanelState state(STATE_PositionOpen, "PositionOpen");
        return &state;
    }

    static CPanelState* getBEAvailable()
    {
        static CPanelState state(STATE_BEAvailable, "BEAvailable");
        return &state;
    }

    // --- Invalid状態（原因別） ---
    static CPanelState* getInvalid_DependencyNull()
    {
        static CPanelState state(STATE_Invalid_DependencyNull, "Invalid_DependencyNull");
        return &state;
    }

    static CPanelState* getInvalid_MissingSL()
    {
        static CPanelState state(STATE_Invalid_MissingSL, "Invalid_MissingSL");
        return &state;
    }

    static CPanelState* getInvalid_BEWithNoPosition()
    {
        static CPanelState state(STATE_Invalid_BEWithNoPosition, "Invalid_BEWithNoPosition");
        return &state;
    }

    static CPanelState* getInvalid()
    {
        return getInvalid_DependencyNull();
    }

    // --- 補助：文字列から生成（テスト・ログ用） ---
    static CPanelState* fromString(string name)
    {
        if (StringCompare(name, "Idle") == 0) return getIdle();
        if (StringCompare(name, "ReadyToEntry") == 0) return getReadyToEntry();
        if (StringCompare(name, "PositionOpen") == 0) return getPositionOpen();
        if (StringCompare(name, "BEAvailable") == 0) return getBEAvailable();
        if (StringCompare(name, "Invalid_DependencyNull") == 0) return getInvalid_DependencyNull();
        if (StringCompare(name, "Invalid_MissingSL") == 0) return getInvalid_MissingSL();
        if (StringCompare(name, "Invalid_BEWithNoPosition") == 0) return getInvalid_BEWithNoPosition();
        return getInvalid();
    }

    // --- 補助：enum値から復元 ---
    static CPanelState* fromEnum(PanelStateCode value)
    {
        switch (value)
        {
            case STATE_Idle: return getIdle();
            case STATE_ReadyToEntry: return getReadyToEntry();
            case STATE_PositionOpen: return getPositionOpen();
            case STATE_BEAvailable: return getBEAvailable();
            case STATE_Invalid_DependencyNull: return getInvalid_DependencyNull();
            case STATE_Invalid_MissingSL: return getInvalid_MissingSL();
            case STATE_Invalid_BEWithNoPosition: return getInvalid_BEWithNoPosition();
            default: return getInvalid();
        }
    }
};
