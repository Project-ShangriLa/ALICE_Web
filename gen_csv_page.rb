require 'shangrila'


master = Shangrila::Sora.new().get_master_data(ARGV[0], ARGV[1])

start_date =  Time.now

start_date = Date.strptime(ARGV[2], '%Y%m%d') if ARGV.length == 3

start_year = start_date.year
start_month = start_date.month
start_day = start_date.day

@master_map = {}

head = <<"EOS"
<html>
<meta charset="utf-8">
<meta name="format-detection" content="telephone=no">

<meta content="pixiv 今期アニメ タグ件数ランキング" name="title">
<meta content="pixiv 今期アニメ タグ件数ランキングです。毎日数回更新。制作：秋葉原IT戦略研究所" name="description">
<meta content='pixivランキング,アニメランキング,pixiv タグランキング,アニメ' name='keywords'>

<meta property="og:type" content="website"/>
<meta property="og:title" content="pixiv 今期アニメ タグ件数ランキング"/>
<meta property="og:description" content="pixiv 今期アニメ タグ件数ランキングです。毎日数回更新。毎日数回更新。制作：秋葉原IT戦略研究所" />
<meta property="og:image" content="http://pix.akiba-net.com/og_image.png" />
<meta property="og:url" content="http://pix.akiba-net.com/index.html" />
<meta property="og:site_name" content="pixiv 今期アニメ タグ件数ランキング"/>

<meta name="twitter:card" content="summary" />
<meta name="twitter:site" content="@anime_follower" />
<meta name="twitter:title" content="pixiv 今期アニメ タグ件数ランキング" />
<meta name="twitter:description" content="pixiv 今期アニメ タグ件数ランキングです。毎日数回更新。毎日数回更新。制作：秋葉原IT戦略研究所" />
<meta name="twitter:image" content="http://pix.akiba-net.com/og_image.png" />

<head>
<title>pixiv 今期アニメ タグ件数ランキング</title>
<link href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet" integrity="sha256-7s5uDGW3AHqw6xtJmNNtr+OBRJUlgkNJEo78P4b0yRw= sha512-nNo+yCHEyn0smMxSswnf/OnX6/KwJuZTlNZBjauKhTK0c+zT+q5JOCx0UFhXQ6rJR9jg6Es8gPuD2uZcYDLqSw==" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-2.2.0.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha256-KXn5puMvxCw+dAYznun+drMdG1IFl3agK0p/pqT9KAo= sha512-2e8qq0ETcfWRI4HJBzQiA3UoyFk6tbNyG+qSaIBZLyW9Xf3sWZHN/lxe9fTh1U45DpPf07yj94KsUHHWe4Yk1A==" crossorigin="anonymous"></script>
<script src="http://code.highcharts.com/highcharts.js"></script>
<script src="http://code.highcharts.com/modules/exporting.js"></script>
<script src="./js/ex.js"></script>
<script>
    $(function(){
        $("#csv_button").click(function () {

            var year = $('[name=year]').val();
            var month = $('[name=month]').val();
            var day = $('[name=day]').val();

            month = ("0"+month).slice(-2);
            day = ("0"+day).slice(-2);

            var start = year + month + day

            var _year = $('[name=_year]').val();
            var _month = $('[name=_month]').val();
            var _day = $('[name=_day]').val();

            _month = ("0"+_month).slice(-2);
            _day = ("0"+_day).slice(-2);

            var end = _year + _month + _day;

            console.log(start);
            console.log(end);

         $("#csv_link").text("ダウンロード!");
         //data_csv?ids=290,291&start=20160208&end=20160220

         var chk_id_list = $('[class="target"]:checked').map(function(){return $(this).val();}).get();
         var ids = chk_id_list.join(',');

         $("#csv_link").attr("href", "/data_csv?ids=" + ids + "&" + "start=" + start + "&end=" + end );
    });
 });
</script>

</head>
<body>
<div style="float:left;">
EOS

body = ""

footer = <<"EOS"
</body>
</html>
EOS

body += '<form action="" method="post">'
master.each do |m|
  body += "<div><input type=\"checkbox\" name=\"checktite\" class=\"target\" id=\"#{m['id']}\" value=\"#{m['id']}\">#{m['title']}</div>"
end
body += '</form>'

body += <<"EOS"
    <div>
 <div> 開始日
        <input type="number" name="year" value="#{start_year}" size="4" min="2016" max="2017"> 年
        <input type="number" name="month" value="#{start_month}" size="2" min="1" max="12"> 月
        <input type="number" name="day" value="#{start_day}" size="2" min="1" max="31"> 日
</div>
 <div> 終了日
        <input type="number" name="_year"  id="_year" value="2016" size="4" min="2016" max="2017"> 年
        <input type="number" name="_month"  id="_month"  value="02" size="2" min="1" max="12"> 月
        <input type="number" name="_day" id="_day" value="09" size="2" min="1" max="31"> 日
</div>
<div>
        <button id="csv_button">CSVリンク生成</button><a href="" id="csv_link"></a>
</div>
<div>
        <button id="graph_button">グラフ生成</button>
        <p>#{start_year}年#{start_month}月#{start_day}日ぐらいからのデータがあります。</p>
    </div>

<div>
<button id="all_check">全選択</button>
</div>
</div>


</div>
<div id="container" style="min-width: 1000px; height: 600px; margin: 0 auto; float:left;"></div>

EOS


puts head
puts body
puts footer