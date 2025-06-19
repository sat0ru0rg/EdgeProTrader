//+------------------------------------------------------------------+
//| Test_CMockEntryOrderService.mq4                                 |
//| Purpose : CMockEntryOrderService の動作検証（ASSERT付き）         |
//+------------------------------------------------------------------+

#include <01_Config/EPT_EnvConfig.mqh>  // ASSERTマクロ定義元をインクルード
#include <99_TestHelper/CMockEntryOrderService.mqh>

#define __CLASS__ "Test_CMockEntryOrderService"

void OnStart()
{
   Print("===== Test Start: CMockEntryOrderService =====");

   CMockEntryOrderService mock;

   // --- ① 正常系：SendOrder
   bool result = mock.SendOrder(OP_BUY, 1.2345, 0.10, 3, 1.2300, 1.2400, "MOCK_ORDER", 12345);
   ASSERT_TRUE(result, "SendOrder should return true");

   // --- ② 異常系：0.0ロット
   result = mock.ClosePartial(10001, 0.0, 3);
   ASSERT_FALSE(result, "ClosePartial should fail on 0.0 lot");

   // --- ③ 異常系：負のロット
   result = mock.ClosePartial(10002, -0.05, 3);
   ASSERT_FALSE(result, "ClosePartial should fail on negative lot");

   // --- ④ 疑似部分決済
   result = mock.ClosePartial(10003, 0.5, 3);
   ASSERT_TRUE(result, "ClosePartial (partial lot) should fallback to full close");

   // --- ⑤ ロット超過 → 補正
   result = mock.ClosePartial(10004, 3.0, 3);
   ASSERT_TRUE(result, "ClosePartial (over-lot) should fallback to full close");

   // --- ⑥ 完全決済（正常系）
   result = mock.ClosePartial(10005, 1.00, 3);
   ASSERT_TRUE(result, "ClosePartial (full lot) should succeed");

   Print("===== Test End: CMockEntryOrderService =====");
}
