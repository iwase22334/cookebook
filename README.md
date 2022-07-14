# 自炊用スクリプト

スマホで撮影した画像群を一括で電子本化するためのスクリプト

## 機能

 - pdf-jpg変換
 - ピンぼけ探し補助
 - 一括OCR

## 環境構築

 - convert (ImageMagick)
   ```
   sudo apt-get install imagemagick
   ```
 
 - tesseract
   ```
   sudo apt install tesseract-ocr
   sudo apt install tesseract-ocr-jpn tesseract-ocr-jpn-vert
   ```

 - gs
   ```
   sudo apt-get install gs
   ```

## 使い方

### 1. jpeg画像の準備

データを用意する
   - (例 title/1.jpg title/2.jpg title/3.jpg ...
   - ファイル名は`sort -V`でソート可能な名前なら何でもよい

 - "vFlat Scan - PDF Scanner -"で撮影し画像でexportする方法が良い
   - https://windowsapp.tokyo/app/1540238220/vflat-scan-pdf-scanner

#### (Optional) 1.1. pdfからjpgへ変換する

 - 以下のコマンドでpdfをjpgに変換可能。入力ファイルと同名のディレクトリが生成される。
   ```
   pdftojpg.sh <title-raw.pdf>
   ```

#### (Optional) 1.2. ピンぼけの除去(手動)

 - 以下のコマンドは、ぼけている可能性が高い物上位のみ表示する。
 - 評価値が低いファイルを目視で確認しぼけている場合は差し替える。出力形式は"<ファイル名>:<評価値>"。
    ```
    unforcus.sh <title>
    ```

    ```
    title/276.png:0.256535
    title/334.png:0.321035
    title/248.png:0.353155
    title/290.png:0.362951
    ...
    ```

### 2. 変換

 - 準備したディレクトリを指定し変換する。
    - 縦書きの文章の場合は`-v`オプションを指定する。
    ```
    jpgtoebook.sh [-v] [-e ext] <title>
    ```

 - <title>.pdfが生成される
