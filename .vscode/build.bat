@echo off
set FILE=%1
set LOG=%FILE:.mq4=.log%

rem コンパイルしてログ出力も保存
"C:\Program Files (x86)\Titan FX MetaTrader 4\metaeditor.exe" /compile:"%FILE%" /log:"%LOG%"

rem ログファイルの中身を表示（エラー確認用）
type "%LOG%"
