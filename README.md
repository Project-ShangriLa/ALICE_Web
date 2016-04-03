#ALICE Web

pixivのデータ統計システム - ALICE - のWebページ生成ソフト

ALICE Batch + ALICE APとペアで動作させてください。



## gen_csv_page.rb

```
ruby gen_csv_page.rb 2016 1 > ex.html

ruby gen_csv_page.rb 2016 1 20160208 > ex.html
```

## gen_pixiv_ranking.rb

```
bundle exe ruby gen_pixiv_ranking.rb -o ranking.html

bundle exe ruby gen_pixiv_ranking.rb -o ranking2016spring.html -y 2016 -c 1
```