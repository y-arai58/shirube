# Penji

iPad と Apple Pencil 向けのペン字練習アプリです。SwiftUI、PencilKit、SwiftData を使用し、ひらがな46文字の練習、記録、比較、履歴確認を行えます。

## 開き方

Xcode で `Penji.xcodeproj` を開き、iPad を接続するか iPad シミュレータを選択して実行します。対応OSは iOS 17 以降です。

## 実装済みの内容

- Apple Pencil による描画（シミュレータでは指／マウス入力も可能）
- なぞり書き／見て書くモード、十字ガイド、濃さ調整
- Undo、Redo、Clear、空の記録を保存しない制御
- SwiftData による筆跡データの保存と履歴
- ひらがな46文字、次の文字、進捗、お手本との比較
- 横長 iPad では「見て書く」を2カラム表示

お手本画像が未提供のため、現時点では文字を画面上に描画しています。見本には無料の **Klee One SemiBold**（SIL Open Font License 1.1）を同梱して使用しています。画像素材が用意できたら `ExemplarOverlayView` と教材詳細の `Text` をアセット画像へ置き換えられます。
