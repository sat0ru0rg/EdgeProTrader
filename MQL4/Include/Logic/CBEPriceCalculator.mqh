#ifndef __CBEPRICECALCULATOR__
#define __CBEPRICECALCULATOR__

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

    void enableMock() { useMock = true; }

    void setMock_BEPrice(double price) { mockBEPrice = price; }

    double CalculateTrueBEPrice(int ticket = -1)
    {
        if (useMock) return mockBEPrice;
        return 0.0; // 実装未定
    }
};

#endif // __CBEPRICECALCULATOR__
