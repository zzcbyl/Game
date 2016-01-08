<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="jquery.min.js"></script>
    <link href="jplayer.blue.monday.min.css" rel="stylesheet" />
    <script src="jquery.jplayer.js"></script>
    <link href="style.css" rel="stylesheet" />
</head>
<body>
    <ul class="feed_file_list" style="margin:10px;">
        <li>
        <div id="jquery_jplayer_1" class="jp-jplayer"></div>
        <div style="background:url(images/jplayerleft.png); width: 6px; height: 36px; float: left; position: absolute;"></div>
        <div id="jp_container_1" class="jp-audio" role="application" aria-label="media player" onclick='changePlay("1");'>
        <a id="a_jp_play_1" class="jp-play" role="button" tabindex="0">
            <span class="jplay_play"></span>
        </a>
        <a id="a_jp_stop_1" class="jp-stop" style="display: none;" role="button" tabindex="0">
            <span class="jplay_stop"></span>
        </a>
        <div class="jp-duration" role="timer" aria-label="duration" style="display: none;"></div>
        </div>
        
        <script type="text/javascript">

            $("#jquery_jplayer_1").jPlayer({
                ready: function () {
                    $(this).jPlayer("setMedia", {
                        mp3: "http://192.168.1.38:8002/test/hYGE3rnG0yIo1o0anVd16sQR94suRldUILlgdFNM3gjHRs-pIZPBQoBSmYIO5p9l.amr"
                    });
                },
                play: function () {
                    $(this).jPlayer("stopOthers");
                },
                ended: function () {
                    //alert('end');
                    changePlay("1");
                    changePlay("2");
                    $("#jquery_jplayer_2").jPlayer("play");
                },
                swfPath: "__THEME__/js",
                supplied: "mp3",
                cssSelectorAncestor: "#jp_container_1",
                wmode: "window",
                globalVolume: true,
                useStateClassSkin: true,
                autoBlur: false,
                smoothPlayBar: true,
                keyEnabled: true
            });

        </script>
    </li>
    


    </ul>

    <div>
        <input type="button" value="下一条" onclick="nextAudio();" />
        
    </div>
    <script type="text/javascript">

        function nextAudio() {
            var newjplay = '<li><div id="jquery_jplayer_2" class="jp-jplayer"></div><div style="background:url(images/jplayerleft.png); width: 6px; height: 36px; float: left; position: absolute;"></div><div id="jp_container_2" class="jp-audio" role="application" aria-label="media player" onclick=\'changePlay("2");\'><a id="a_jp_play_2" class="jp-play" role="button" tabindex="0"><span class="jplay_play"></span></a><a id="a_jp_stop_2" class="jp-stop" style="display: none;" role="button" tabindex="0"><span class="jplay_stop"></span></a><div class="jp-duration" role="timer" aria-label="duration" style="display: none;"></div></div></li>';
            $('.feed_file_list li:last').after(newjplay);

            $("#jquery_jplayer_2").jPlayer({
                ready: function () {
                    $(this).jPlayer("setMedia", {
                        mp3: "http://192.168.1.38:8002/test/2222.mp3"
                    });
                },
                play: function () {
                    $(this).jPlayer("stopOthers");
                },
                ended: function () {
                    alert('end');
                },
                swfPath: "__THEME__/js",
                supplied: "mp3",
                cssSelectorAncestor: "#jp_container_2",
                wmode: "window",
                globalVolume: true,
                useStateClassSkin: true,
                autoBlur: false,
                smoothPlayBar: true,
                keyEnabled: true
            });

        }




        var ssset = 0;
        var stopindex = 1;
        function changePlay(id) {
            
            if ($('#a_jp_stop_' + id).css('display') == 'none') {
                stopindex = 1;
                playA();
                clearInterval(ssset)
                ssset = setInterval("playA()", 500);
                $('.jp-stop').hide();
                $('.jp-play').show();
                $('#a_jp_stop_' + id).show();
                $('#a_jp_play_' + id).hide();

            }
            else {
                $('#a_jp_play_' + id).show();
                $('#a_jp_stop_' + id).hide();
                clearInterval(ssset)
            }
        }

        function playA() {
            if (stopindex == 4) stopindex = 1;
            $(".jplay_stop").attr("class", "jplay_stop jp-stop_" + stopindex);
            stopindex++;
        }

        function autojplayerWidth() {
            $(".jp-audio").each(function () {
                var currdt = $(this).find('div:last').html();
                var dtarr = currdt.split(':');
                var secondnum = (parseInt(dtarr[0]) * 60) + parseInt(dtarr[1]);
                secondnum = parseInt(secondnum * 0.6);
                if (secondnum >= 200)
                    secondnum = 200;
                if (secondnum < 60)
                    secondnum = 60;
                $(this).css('width', secondnum.toString());
            });
        }
    </script>
</body>
    
</html>
