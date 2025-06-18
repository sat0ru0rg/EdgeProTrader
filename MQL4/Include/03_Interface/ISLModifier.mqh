//+------------------------------------------------------------------+
//| ISLModifier                                                      |
//| Interface Type : [ポリモーフィズム抽象I/F]                        |
//| Implemented by : CExitExecutor / CTrailSLExecutor                |
//| Used by        : EntryPanelController, SLManager                |
//| 概要             : SLラインの価格変更、トレーリング処理を担当するI/F    |
//+------------------------------------------------------------------+
#ifndef __ISL_MODIFIER_MQH__
#define __ISL_MODIFIER_MQH__

class ISLModifier
{
public:
   /// 指定ポジションのSLを新しい価格に変更
   virtual bool ModifySL(int ticket, double newSL) = 0;

   /// トレーリングSLを指定条件で実行（pips差 or ローソク条件）
   virtual bool ApplyTrailingSL(int ticket) = 0;

   /// 最後の実行結果エラー文字列を返す
   virtual string GetLastErrorMessage() = 0;
};

#endif
