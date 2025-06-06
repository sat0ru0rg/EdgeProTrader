// エントリー系ボタン設計と実装【MQL4一斉移動パネル版：ドラッグエリア拡張版・背景色表示版】
// --- ボタン高さ統一、GAP調整、ドラッグエリアをパネル上部の空きスペース全体に拡張し、背景をボタンと同じ色で表示、パネル高さ自動調整版 ---

// テスト用コメント（2025/05/03）

#property strict
#include <stdlib.mqh>

#include <EdgeProLib.mqh>

// --- 定数定義
#define PANEL_NAME   "EntryButtonPanel"
#define DRAG_AREA    "DragAnchor"
#define PANEL_X      50
#define PANEL_Y      50
#define PANEL_W      200

#define BUTTON_H     30
#define BUTTON_HALF_W   90
#define BUTTON_FULL_W   190
#define GAP             6

// --- グローバル変数
int panelX = PANEL_X;
int panelY = PANEL_Y;
int panelH = 0;

// --- ボタン名定義
string ButtonNames[] = {
   "SELL TP", "BUY TP",
   "SELL SL", "BUY SL",
   "SHORT",   "LONG",
   "BE",       "Close All",
   "Toggle Panel"
};


CPriceCalculator priceCalc;  

// --- 関数プロトタイプ
void CreatePanel();
void CreateButtons();
void UpdateButtonPositions();
void DeletePanelAndButtons();
void MovePanel(int newX, int newY);

int OnInit()
  {
   CreatePanel();
   CreateButtons();
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   DeletePanelAndButtons();
  }

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   if(id == CHARTEVENT_OBJECT_DRAG && sparam == DRAG_AREA)
     {
      int newX = ObjectGetInteger(0, DRAG_AREA, OBJPROP_XDISTANCE);
      int newY = ObjectGetInteger(0, DRAG_AREA, OBJPROP_YDISTANCE);
      MovePanel(newX, newY);
     }
        else if(id == CHARTEVENT_OBJECT_CLICK)
     {
      OnButtonClick(sparam);
     }
  }
     
// --- ボタンクリック処理
void OnButtonClick(const string buttonName)
  {
   // クリックされたボタンに応じて処理を振り分け
   if(buttonName == "Button_1") // SELL TP
     {
      Print("SELL TPボタン押下");
      
     }
   else if(buttonName == "Button_2") // BUY TP
     {
      Print("BUY TPボタン押下");
      // ここにBUY TP設定処理を書く
     }
   else if(buttonName == "Button_3") // SELL SL
     {
      Print("SELL SLボタン押下");
      DrawSellSLLine();
     }
   else if(buttonName == "Button_4") // BUY SL
     {
      Print("BUY SLボタン押下");
      DrawBuySLLine();
     }
   else if(buttonName == "Button_5") // SHORT
     {
      Print("SHORTボタン押下");
      // ここにSELL成行エントリー処理を書く
     }
   else if(buttonName == "Button_6") // LONG
     {
      Print("LONGボタン押下");
      // ここにBUY成行エントリー処理を書く
     }
   else if(buttonName == "Button_7") // BE
     {
      Print("BEボタン押下");
      // ここに建値ストップ移動処理を書く
     }
   else if(buttonName == "Button_8") // Close All
     {
      Print("Close Allボタン押下");
      // ここに全ポジション決済処理を書く
     }
   else if(buttonName == "Button_9") // Toggle Panel
     {
      Print("Toggle Panelボタン押下");
      // ここにパネル最小化・展開切り替え処理を書く
     }
   }
   
// --- SELL SLラインを引く関数
void DrawSellSLLine()
  {
   string lineName = "SELL_SL_LINE";
   
   // 既存ラインがあれば削除
   if(ObjectFind(0, lineName) >= 0)
      ObjectDelete(0, lineName);

   double sl_pips = 20; // pips指定
   double price = priceCalc.CalculateSLPrice(OP_SELL, Bid, sl_pips);
   
   ObjectCreate(0, lineName, OBJ_HLINE, 0, 0, price);
   ObjectSetInteger(0, lineName, OBJPROP_COLOR, clrRed);
   ObjectSetInteger(0, lineName, OBJPROP_STYLE, STYLE_DASH);
   ObjectSetInteger(0, lineName, OBJPROP_WIDTH, 2);
   
   Print("SELL用SLラインを描画しました: ", price);
  }

// --- BUY SLラインを引く関数
void DrawBuySLLine()
  {
   string lineName = "BUY_SL_LINE";
   
   // 既存ラインがあれば削除
   if(ObjectFind(0, lineName) >= 0)
      ObjectDelete(0, lineName);

   double sl_pips = 20; // ここも外部変数化予定
   double price = priceCalc.CalculateSLPrice(OP_BUY, Ask, sl_pips);
   
   ObjectCreate(0, lineName, OBJ_HLINE, 0, 0, price);
   ObjectSetInteger(0, lineName, OBJPROP_COLOR, clrBlue);
   ObjectSetInteger(0, lineName, OBJPROP_STYLE, STYLE_DASH);
   ObjectSetInteger(0, lineName, OBJPROP_WIDTH, 2);
   
   Print("BUY用SLラインを描画しました: ", price);
  }


void CreatePanel()
  {
   if(ObjectFind(0, PANEL_NAME) < 0)
     {
      ObjectCreate(0, PANEL_NAME, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, PANEL_NAME, OBJPROP_CORNER, 0);
      ObjectSetInteger(0, PANEL_NAME, OBJPROP_XDISTANCE, panelX);
      ObjectSetInteger(0, PANEL_NAME, OBJPROP_YDISTANCE, panelY);
      ObjectSetInteger(0, PANEL_NAME, OBJPROP_XSIZE, PANEL_W);
      ObjectSetInteger(0, PANEL_NAME, OBJPROP_YSIZE, 400); // 仮設定、後で調整
      ObjectSetInteger(0, PANEL_NAME, OBJPROP_COLOR, clrDimGray);
      ObjectSetInteger(0, PANEL_NAME, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetInteger(0, PANEL_NAME, OBJPROP_WIDTH, 2);
      ObjectSetInteger(0, PANEL_NAME, OBJPROP_BACK, true);
     }

   if(ObjectFind(0, DRAG_AREA) < 0)
     {
      ObjectCreate(0, DRAG_AREA, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, DRAG_AREA, OBJPROP_CORNER, 0);
      ObjectSetInteger(0, DRAG_AREA, OBJPROP_XDISTANCE, panelX);
      ObjectSetInteger(0, DRAG_AREA, OBJPROP_YDISTANCE, panelY);
      ObjectSetInteger(0, DRAG_AREA, OBJPROP_XSIZE, PANEL_W);
      ObjectSetInteger(0, DRAG_AREA, OBJPROP_YSIZE, 400);
      ObjectSetInteger(0, DRAG_AREA, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetInteger(0, DRAG_AREA, OBJPROP_COLOR, clrSilver);
      ObjectSetInteger(0, DRAG_AREA, OBJPROP_WIDTH, 1);
      ObjectSetInteger(0, DRAG_AREA, OBJPROP_BACK, true);
      ObjectSetInteger(0, DRAG_AREA, OBJPROP_SELECTABLE, true);
      ObjectSetInteger(0, DRAG_AREA, OBJPROP_SELECTED, false);
      ObjectSetString(0, DRAG_AREA, OBJPROP_TEXT, "");
     }
  }

void CreateButtons()
  {
   for(int i = 0; i < ArraySize(ButtonNames); i++)
     {
      string buttonName = StringFormat("Button_%d", i+1);
      ObjectCreate(0, buttonName, OBJ_BUTTON, 0, 0, 0);
      ObjectSetInteger(0, buttonName, OBJPROP_CORNER, 0);
      ObjectSetInteger(0, buttonName, OBJPROP_FONTSIZE, 10);
      ObjectSetInteger(0, buttonName, OBJPROP_BORDER_TYPE, BORDER_RAISED);
      ObjectSetString(0, buttonName, OBJPROP_TEXT, ButtonNames[i]);
      ObjectSetInteger(0, buttonName, OBJPROP_BGCOLOR, clrSilver);
     }
   UpdateButtonPositions();
  }

void UpdateButtonPositions()
  {
   ObjectSetInteger(0, PANEL_NAME, OBJPROP_XDISTANCE, panelX);
   ObjectSetInteger(0, PANEL_NAME, OBJPROP_YDISTANCE, panelY);

   int xLeft = panelX + GAP;
   int xRight = panelX + PANEL_W/2 + GAP/2;
   int y = panelY + GAP + BUTTON_H;

   for(int i=0; i<6; i++) // 最初の3段 × 2列
     {
      string buttonName = StringFormat("Button_%d", i+1);
      int x = (i%2==0) ? xLeft : xRight;
      int row = i/2;
      int yOffset = y + row * (BUTTON_H + GAP);
      ObjectSetInteger(0, buttonName, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, buttonName, OBJPROP_YDISTANCE, yOffset);
      ObjectSetInteger(0, buttonName, OBJPROP_XSIZE, PANEL_W/2 - GAP*1.5);
      ObjectSetInteger(0, buttonName, OBJPROP_YSIZE, BUTTON_H);
     }

   int yFullStart = y + 3 * (BUTTON_H + GAP);
   for(int i=6; i<9; i++)
     {
      string buttonName = StringFormat("Button_%d", i+1);
      int yOffset = yFullStart + (i - 6) * (BUTTON_H + GAP);
      ObjectSetInteger(0, buttonName, OBJPROP_XDISTANCE, panelX + GAP);
      ObjectSetInteger(0, buttonName, OBJPROP_YDISTANCE, yOffset);
      ObjectSetInteger(0, buttonName, OBJPROP_XSIZE, PANEL_W - GAP*2);
      ObjectSetInteger(0, buttonName, OBJPROP_YSIZE, BUTTON_H);
     }

   // パネルとドラッグエリアの高さを一番下のボタン位置にGAP分追加して調整
   int lastButtonBottom = yFullStart + 3 * (BUTTON_H + GAP) - GAP;
   panelH = (lastButtonBottom - panelY) + GAP;

   ObjectSetInteger(0, PANEL_NAME, OBJPROP_YSIZE, panelH);
   ObjectSetInteger(0, DRAG_AREA, OBJPROP_YSIZE, y - panelY);
  }

void MovePanel(int newX, int newY)
  {
   panelX = newX;
   panelY = newY;
   UpdateButtonPositions();
  }

void DeletePanelAndButtons()
  {
   ObjectDelete(0, PANEL_NAME);
   ObjectDelete(0, DRAG_AREA);
   for(int i = 0; i < ArraySize(ButtonNames); i++)
     {
      string buttonName = StringFormat("Button_%d", i+1);
      ObjectDelete(0, buttonName);
     }
  }
