$(function() {

    function create_url(type) {

        path = ""

        if(type == "csv") {
            path = "/data_csv"
        } else if (type == "json") {
            path = "/data_json"
        }

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


        //data_csv?ids=290,291&start=20160208&end=20160220

        var chk_id_list = $('[class="target"]:checked').map(function(){return $(this).val();}).get();
        var ids = chk_id_list.join(',');

        if(type == "csv") {
            $("#csv_link").text("ダウンロード!");
            $("#csv_link").attr("href", path + "?ids=" + ids + "&" + "start=" + start + "&end=" + end );
        } else if (type == "json") {
            return path + "?ids=" + ids + "&" + "start=" + start + "&end=" + end
        }

    }


    $("#graph_button").click(function () {

        var url =  create_url("json");
        console.log(url);

        $.ajax({
            type: 'GET',
            url: url,
            dataType: 'json',
            success: function(json) {
                        draw(json);
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                console.log("ERROR");
                console.log(textStatus);
                console.log(errorThrown);
            }
        });

        function draw(series) {
            $('#container').highcharts({
                chart: {
                    type: 'spline'
                },
                title: {
                    text: 'pixiv 投稿増加数の日付別推移'
                },
                subtitle: {
                    text: "今期アニメ"
                },
                xAxis: {
                    type: 'category',
                    /*
                     dateTimeLabelFormats: {
                     day: '%e. %b'
                     },*/
                    title: {
                        text: '日付'
                    }
                },
                yAxis: {
                    title: {
                        text: '投稿数'
                    },
                    min: 0
                },
                tooltip: {
                    headerFormat: '<b>{series.name}</b><br>',
                },

                plotOptions: {
                    spline: {
                        marker: {
                            enabled: true
                        }
                    }
                },

                series: series
            });
        } //draw
    });
});
