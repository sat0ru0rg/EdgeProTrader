//===========================
// ChartRenderer.mqh
//===========================
// このモジュールはチャート上への描画機能を集約します。
// - ボタン、ラベル、ラインなど視覚的なUI部品の表示に対応。
// - 操作系（BUY/SELLボタン）と情報表示（Pipsラベルなど）を一元管理。
// - 表示位置は左上、チャート価格表示パネルに重なるように設計（Y位置調整可能）。
#ifndef __CHARTRENDERER_MQH__
#define __CHARTRENDERER_MQH__

#include <Common/CommonDefs.mqh>

// チャート左上にBUY/SELLのエントリーボタンを表示（MQL4対応）
void DrawEntryButtons()
{
    // BUYボタン
    if (!ObjectFind("BtnBuy")) {
        ObjectCreate("BtnBuy", OBJ_BUTTON, 0, 0, 0);
        ObjectSet("BtnBuy", OBJPROP_XDISTANCE, 10);
        ObjectSet("BtnBuy", OBJPROP_YDISTANCE, 20);
        ObjectSet("BtnBuy", OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSet("BtnBuy", OBJPROP_WIDTH, 60);
        ObjectSet("BtnBuy", OBJPROP_BGCOLOR, clrLimeGreen);
        ObjectSet("BtnBuy", OBJPROP_COLOR, clrWhite);
        ObjectSetText("BtnBuy", "BUY", 10, "Arial", clrWhite);
    }

    // SELLボタン
    if (!ObjectFind("BtnSell")) {
        ObjectCreate("BtnSell", OBJ_BUTTON, 0, 0, 0);
        ObjectSet("BtnSell", OBJPROP_XDISTANCE, 75);
        ObjectSet("BtnSell", OBJPROP_YDISTANCE, 20);
        ObjectSet("BtnSell", OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSet("BtnSell", OBJPROP_WIDTH, 60);
        ObjectSet("BtnSell", OBJPROP_BGCOLOR, clrRed);
        ObjectSet("BtnSell", OBJPROP_COLOR, clrWhite);
        ObjectSetText("BtnSell", "SELL", 10, "Arial", clrWhite);
    }
}

#endif