#http://www.bootstrapcdn.com/
require 'sequel'
require 'optparse'
require 'uri'
require 'pry'

amazon_widget = <<EOS
  <script type="text/javascript"><!--
amazon_ad_tag = "voiceactor-akiba-22"; amazon_ad_width = "728"; amazon_ad_height = "90";//--></script>
<script type="text/javascript" src="http://ir-jp.amazon-adsystem.com/s/ads.js"></script>
EOS

amazon_widget2= <<EOS
  <iframe src="http://rcm-fe.amazon-adsystem.com/e/cm?t=voiceactor-akiba-22&o=9&p=48&l=bn1&mode=dvd-jp&browse=562020&fc1=000000&lt1=_blank&lc1=3366FF&bg1=FFFFFF&f=ifr" marginwidth="0" marginheight="0" width="728" height="90" border="0" frameborder="0" style="border:none;" scrolling="no"></iframe>
EOS

rakuten_widget = <<EOS
<!-- Rakuten Widget FROM HERE --><script type="text/javascript">rakuten_design="slide";rakuten_affiliateId="138ddf20.b83089f9.138ddf21.36568b5e";rakuten_items="ranking";rakuten_genreId="553575";rakuten_size="468x160";rakuten_target="_blank";rakuten_theme="gray";rakuten_border="off";rakuten_auto_mode="off";rakuten_genre_title="off";rakuten_recommend="off";</script><script type="text/javascript" src="http://xml.affiliate.rakuten.co.jp/widget/js/rakuten_widget.js"></script><!-- Rakuten Widget TO HERE -->
EOS

def body()

  table_start = <<EOS
<table class="table table-striped alt-table-responsive">
<thead>
<tr>
<th class="col-md-1">順位</th>
<th class="col-md-2">画像</th>
<th class="col-md-2">タグ検索結果数</th>
<th class="col-md-2">今日の増加数</th>
<th class="col-md-5">検索ワード</th>
</tr>
</thead>
<tbody>
EOS

  table_end = '</tbody></table>'

  body_string = <<"EOS"
<h1>Pixiv 今期アニメ タグ件数ランキング</h1>
<div>
制作:
  <a href="#" onclick="javascript:window.open('http://akibalab.info/');">
    <img src="https://objectstore-r1nd1001.cnode.jp/v1/93a6500c0a1e4c68b976e5e46527145c/data/aisl_logo.png">
  </a>
</div>
<p class="text-info lead">データ更新日時 #{Time.now.strftime("%Y-%m-%d %H時%M分%S秒")}</p>
#{table_start}
EOS

  @db = Sequel.mysql2('anime_admin_development', :host=>'localhost', :user=>'root', :password=>'', :port=>'3306')

  ranking = @db[:pixiv_tag_status].reverse(:total).select_all
  daily_ranking = @db[:pixiv_tag_daily].select_hash(:bases_id, [:total, :search_word])

  #http://www.pixiv.net/search.php?s_mode=s_tag&word=%E6%9A%97%E6%AE%BA%E6%95%99%E5%AE%A4(%E7%AC%AC2%E6%9C%9F)%20or%20%E6%9A%97%E6%AE%BA%E6%95%99%E5%AE%A4&abt=y
  ranking.each_with_index do |rank, i|

    link = URI.escape('http://www.pixiv.net/search.php?s_mode=s_tag&word=' + rank[:search_word])

    diff = '検索ワード変更によりデータなし'

    if daily_ranking[rank[:bases_id]][1] == rank[:search_word]
     diff = rank[:total] - daily_ranking[rank[:bases_id]][0]
    end

    body_string += <<EOS
    <tr>
     <th class="col-md-1"><p class="lead">#{i + 1}</p></th>
     <td class="col-md-2">#{rank[:image]}</td>
     <td class="col-md-2"><p class="lead">#{rank[:total]}</p></td>
     <td class="col-md-2"><p class="lead">#{diff}</p></td>
     <td class="col-md-5"><p class="lead"><a href="#" onclick="javascript:window.open('#{link}');">#{rank[:search_word]}</a></p></td>
    </tr>
EOS
    body_string += table_end + rakuten_widget + table_start if i == 100
    #body_string += table_end + amazon_widget2 + table_start if i == 200
  end

  body_string += table_end
  #og:title等 SEO http://qiita.com/taiyop/items/050c6749fb693dae8f82
  #TODO 上位をグラフ保存化
  #TODO ランキングコピー化
  #TODO 最新のコメントをマウスオーバー表示
  #TODO シェアボタン
  #TODO Google-GA
  #TODO DMM AA
  body_string
end

head = <<"EOS"
<html>
<meta charset="utf-8">
<meta name="format-detection" content="telephone=no">

<meta content="Pixiv 今期アニメ タグ件数ランキング" name="title">
<meta content="Pixiv 今期アニメ タグ件数ランキングです。毎日数回更新。制作：秋葉原IT戦略研究所" name="description">
<meta content='Pixivランキング,アニメランキング,Pixiv タグランキング,アニメ' name='keywords'>

<meta property="og:type" content="website"/>
<meta property="og:title" content="Pixiv 今期アニメ タグ件数ランキング"/>
<meta property="og:description" content="Pixiv 今期アニメ タグ件数ランキングです。毎日数回更新。毎日数回更新。制作：秋葉原IT戦略研究所" />
<meta property="og:image" content="http://data.akiba-net.com/va_og_image.png" />
<meta property="og:url" content="http://data.akiba-net.com/va.html" />
<meta property="og:site_name" content="Pixiv 今期アニメ タグ件数ランキング"/>

<meta name="twitter:card" content="summary" />
<meta name="twitter:site" content="@428dev" />
<meta name="twitter:title" content="Pixiv 今期アニメ タグ件数ランキング" />
<meta name="twitter:description" content="Pixiv 今期アニメ タグ件数ランキングです。毎日数回更新。毎日数回更新。制作：秋葉原IT戦略研究所" />
<meta name="twitter:image" content="http://data.akiba-net.com/va_og_image.png" />

<head>
<title>pixiv 今期アニメ タグ件数ランキング</title>
<link href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet" integrity="sha256-7s5uDGW3AHqw6xtJmNNtr+OBRJUlgkNJEo78P4b0yRw= sha512-nNo+yCHEyn0smMxSswnf/OnX6/KwJuZTlNZBjauKhTK0c+zT+q5JOCx0UFhXQ6rJR9jg6Es8gPuD2uZcYDLqSw==" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-2.2.0.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha256-KXn5puMvxCw+dAYznun+drMdG1IFl3agK0p/pqT9KAo= sha512-2e8qq0ETcfWRI4HJBzQiA3UoyFk6tbNyG+qSaIBZLyW9Xf3sWZHN/lxe9fTh1U45DpPf07yj94KsUHHWe4Yk1A==" crossorigin="anonymous"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/layzr.js/1.4.3/layzr.min.js"></script>

  <script>
  $(document).ready(function(){
    var layzr = new Layzr({});
  });
  </script>
</head>
<body>
EOS

footer = <<"EOS"
#{amazon_widget2}
</body>
</html>
EOS


output_filename = nil
opt = OptionParser.new
Version = '1.0.0'
opt.on('-o OUTPUT FILENAME', 'output filename') {|v| output_filename = v }
opt.parse!(ARGV)

if output_filename.nil?
  puts head
  puts body
  puts footer
else
  File.open(output_filename, 'w') do |file|
    file.puts head
    file.puts body
    file.puts footer
  end
end
