//+------------------------------------------------------------------+
//| IExitEvaluator                                                   |
//| Interface Type : [ポリモーフィズム抽象I/F]                        |
//| Implemented by : CExitExecutor（予定）                          |
//| Used by        : CEntryController, ExitPanelController（予定）   |
//| 概要             : 現在の相場状況において即時撤退すべきかを判定するI/F   |
//+------------------------------------------------------------------+
#ifndef __IEXIT_EVALUATOR_MQH__
#define __IEXIT_EVALUATOR_MQH__

class IExitEvaluator
{
public:
   /// 指定チケットが即時撤退対象かどうかを判定
   virtual bool ShouldExitNow(int ticket) = 0;

   /// ローソク足や指標をもとに撤退理由を説明（ログ／UI用）
   virtual string ExplainExitReason(int ticket) = 0;
};

#endif
