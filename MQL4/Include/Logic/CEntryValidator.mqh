#ifndef __CENTRYVALIDATOR__
#define __CENTRYVALIDATOR__

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

    void enableMock() { useMock = true; }

    void setMock_IsSpreadAcceptable(bool val) { mockIsSpreadOK = val; }
    void setMock_IsTradableTime(bool val) { mockIsTradable = val; }

    bool isSpreadAcceptable()
    {
        if (useMock) return mockIsSpreadOK;
        return true; // 実装未定
    }

    bool isTradableTime()
    {
        if (useMock) return mockIsTradable;
        return true; // 実装未定
    }
};

#endif // __CENTRYVALIDATOR__
