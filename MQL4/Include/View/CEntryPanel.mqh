/*
CEntryPanelクラス設計版：一斉移動型ドラッグ可能パネル（MQL4）
オフセット補正関連コードは完全に削除
*/

#property strict

#include <stdlib.mqh>

class CEntryPanel
  {
private:
   string m_panelName;
   string m_dragAreaName;
   string m_buttonBuyName;
   string m_buttonSellName;

public:
   void Create(const string panelName, int x, int y)
     {
      m_panelName    = panelName;
      m_dragAreaName = panelName + "_Drag";
      m_buttonBuyName = panelName + "_Buy";
      m_buttonSellName = panelName + "_Sell";

      CreatePanel(x, y);
      CreateButtons(x, y);
     }

   void Delete()
     {
      ObjectDelete(0, m_dragAreaName);
      ObjectDelete(0, m_panelName);
      ObjectDelete(0, m_buttonBuyName);
      ObjectDelete(0, m_buttonSellName);
     }

   void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
     {
      if (id == CHARTEVENT_OBJECT_DRAG && sparam == m_dragAreaName)
        {
         // ここでドラッグエリア自体の新しい位置を読む
         int newX = ObjectGetInteger(0, m_dragAreaName, OBJPROP_XDISTANCE);
         int newY = ObjectGetInteger(0, m_dragAreaName, OBJPROP_YDISTANCE);
   
         // そこを基準にパネル・ボタンを移動
         MovePanel(newX, newY);
        }
     }
   


private:
   void CreatePanel(int x, int y)
     {
      ObjectCreate(0, m_dragAreaName, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, m_dragAreaName, OBJPROP_CORNER, 0);
      ObjectSetInteger(0, m_dragAreaName, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, m_dragAreaName, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, m_dragAreaName, OBJPROP_XSIZE, 200);
      ObjectSetInteger(0, m_dragAreaName, OBJPROP_YSIZE, 20);
      ObjectSetInteger(0, m_dragAreaName, OBJPROP_COLOR, clrSlateGray);
      ObjectSetInteger(0, m_dragAreaName, OBJPROP_SELECTABLE, true);
      ObjectSetInteger(0, m_dragAreaName, OBJPROP_HIDDEN, false);

      ObjectCreate(0, m_panelName, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, m_panelName, OBJPROP_CORNER, 0);
      ObjectSetInteger(0, m_panelName, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, m_panelName, OBJPROP_YDISTANCE, y + 20);
      ObjectSetInteger(0, m_panelName, OBJPROP_XSIZE, 200);
      ObjectSetInteger(0, m_panelName, OBJPROP_YSIZE, 150);
      ObjectSetInteger(0, m_panelName, OBJPROP_COLOR, clrDimGray);
     }

   void CreateButtons(int x, int y)
     {
      ObjectCreate(0, m_buttonBuyName, OBJ_BUTTON, 0, 0, 0);
      ObjectSetInteger(0, m_buttonBuyName, OBJPROP_CORNER, 0);
      ObjectSetInteger(0, m_buttonBuyName, OBJPROP_XDISTANCE, x + 10);
      ObjectSetInteger(0, m_buttonBuyName, OBJPROP_YDISTANCE, y + 30);
      ObjectSetInteger(0, m_buttonBuyName, OBJPROP_XSIZE, 80);
      ObjectSetInteger(0, m_buttonBuyName, OBJPROP_YSIZE, 30);
      ObjectSetString(0, m_buttonBuyName, OBJPROP_TEXT, "BUY TP");

      ObjectCreate(0, m_buttonSellName, OBJ_BUTTON, 0, 0, 0);
      ObjectSetInteger(0, m_buttonSellName, OBJPROP_CORNER, 0);
      ObjectSetInteger(0, m_buttonSellName, OBJPROP_XDISTANCE, x + 100);
      ObjectSetInteger(0, m_buttonSellName, OBJPROP_YDISTANCE, y + 30);
      ObjectSetInteger(0, m_buttonSellName, OBJPROP_XSIZE, 80);
      ObjectSetInteger(0, m_buttonSellName, OBJPROP_YSIZE, 30);
      ObjectSetString(0, m_buttonSellName, OBJPROP_TEXT, "SELL TP");
     }

   void MovePanel(int newX, int newY)
     {
      ObjectSetInteger(0, m_dragAreaName, OBJPROP_XDISTANCE, newX);
      ObjectSetInteger(0, m_dragAreaName, OBJPROP_YDISTANCE, newY);

      ObjectSetInteger(0, m_panelName, OBJPROP_XDISTANCE, newX);
      ObjectSetInteger(0, m_panelName, OBJPROP_YDISTANCE, newY + 20);

      ObjectSetInteger(0, m_buttonBuyName, OBJPROP_XDISTANCE, newX + 10);
      ObjectSetInteger(0, m_buttonBuyName, OBJPROP_YDISTANCE, newY + 30);

      ObjectSetInteger(0, m_buttonSellName, OBJPROP_XDISTANCE, newX + 100);
      ObjectSetInteger(0, m_buttonSellName, OBJPROP_YDISTANCE, newY + 30);
     }
  };



/*
// --- 使用例 ---
CEntryPanel entryPanel;

int OnInit()
  {
   entryPanel.Create("SamplePanel", 50, 50);
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   entryPanel.Delete();
  }

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   entryPanel.OnChartEvent(id, lparam, dparam, sparam);
  }
*/