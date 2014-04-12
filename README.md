
# 画像セットの差分閲覧

これは 2 つの画像セットの差分を閲覧するための sinatora アプリです。  

## 使い方

比較したい画像セットを次のように配置します。  
 
     public/resutls/capture-prev/**.png
     public/resutls/capture/**.png

 次の様にして、差分画像セット、サムネイル画像セットを作成します。  

    $ bundle install
    $ cd public/results
    $ source make.sh

準備ができたら、sinatra アプリを起動させmす。

    $ budle exec ruby app.rb

起動したら、http://localhost:4567 にアクセスすると、画像一覧を閲覧できます。
