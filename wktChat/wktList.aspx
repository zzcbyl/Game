<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<script runat="server">
    public string timeStamp = "";
    public string nonceStr = "3y2wsafsda11fqf2ad0bfswf90fqs6cw7fb";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid_dingyue"];
    
    protected void Page_Load(object sender, EventArgs e)
    {
        timeStamp = Util.GetTimeStamp();
        ticket = Util.GetTicket();
        string shaString = "jsapi_ticket=" + ticket.Trim() + "&noncestr=" + nonceStr.Trim()
            + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
        shaParam = Util.GetSHA1(shaString);
       
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <title></title>
    <script src="../script/jquery-2.1.1.min.js"></script>
    <script src="../script/jquery.jplayer.js"></script>
    <link href="../style/jplayer.blue.monday.min.css" rel="stylesheet" />

    <style type="text/css">
        ul, li, p, h1, h2, h3, h4, h5, h6, dl, dt, dd, form, input, textarea, select { list-style-type:none; padding:0;}
        .jp-audio, .jp-audio-stream, .jp-video { margin-left: 5px; border: 1px solid #7AA23F; background: url(images/jplayerbg.png);  border-radius:4px;  width: 90px; height: 36px; line-height: 36px; padding:0 5px;}
        .jp-play { width: 100%; height: 36px; display: block; padding-top: 9px;}
        .jplay_play { background: url(images/jplayerstop.png) no-repeat; width: 16px; height: 19px; display: block; }
        .jp-play:focus { background: none;}
        .jp-stop {  width: 100%; height: 36px; display: block; margin-left: 0; padding-top: 9px; margin-top: 0; }
        .jplay_stop { display: block; margin-left: 0px;}
        .jp-stop:focus { background: none; margin-left: 0; }
        .feed_file_list, .feed_file_list li { border: none; margin:10px;}
        .jp-stop_1 { background: url(images/jplayerplay.png) no-repeat 0 0; width: 16px; height: 19px;  }
        .jp-stop_2 { background: url(images/jplayerplay.png) no-repeat -18px 0; width: 16px; height: 19px;  }
        .jp-stop_3 { background: url(images/jplayerplay.png) no-repeat -39px 0; width: 18px; height: 19px;  }
        .feed_file_list li { padding-left: 0px;}
    </style>
</head>
<body style="width:640px; margin:0 auto; background:#efadad;">
    <div>
        <div>
            <ul class="feed_file_list">
                <li></li>
            <%--<asp:Repeater ID="Repeater1" runat="server">
                <ItemTemplate>
                    <div></div>
                </ItemTemplate>
            </asp:Repeater>--%>
            
                <%--<li>
                    <div id="jquery_jplayer_1" class="jp-jplayer"></div>
                    <div style="background:url(images/jplayerleft.png); width: 6px; height: 36px; float: left; position: absolute;"></div>
                    <div id="jp_container_1" class="jp-audio" role="application" aria-label="media player" onclick='changePlay("1");' style="float:left;">
                        <a id="a_jp_play_1" class="jp-play" role="button" tabindex="0">
                            <span class="jplay_play"></span>
                        </a>
                        <a id="a_jp_stop_1" class="jp-stop" style="display: none;" role="button" tabindex="0">
                            <span class="jplay_stop"></span>
                        </a>
                        <div class="jp-duration" role="timer" aria-label="duration" style="display: none;"></div>
                    </div>
                    <div style="float:left; line-height:36px; margin-left:8px;">5”</div><div style="clear:both;"></div>
                    <script type="text/javascript">
                        $("#jquery_jplayer_1").jPlayer({
                            ready: function () {
                                $(this).jPlayer("setMedia", {
                                    mp3: "http://game.luqinwenda.com/amr/sounds/gVenWQ5NeWkRmDholkYpiZ-RpRmdKAtBNVu99qkjON0N96Mx22G-vliRLk1jhuxR.mp3"
                                });
                            },
                            play: function () {
                                $(this).jPlayer("stopOthers");
                            },
                            ended: function () {
                                $("#jquery_jplayer_2").jPlayer("play");
                                changePlay("2");
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

                <li>
                    <div id="jquery_jplayer_2" class="jp-jplayer"></div>
                    <div style="background:url(images/jplayerleft.png); width: 6px; height: 36px; float: left; position: absolute;"></div>
                    <div id="jp_container_2" class="jp-audio" role="application" aria-label="media player" onclick='changePlay("2");' style="float:left;">
                    <a id="a_jp_play_2" class="jp-play" role="button" tabindex="0">
                        <span class="jplay_play"></span>
                    </a>
                    <a id="a_jp_stop_2" class="jp-stop" style="display: none;" role="button" tabindex="0">
                        <span class="jplay_stop"></span>
                    </a>
                    <div class="jp-duration" role="timer" aria-label="duration" style="display: none;"></div>
                    </div>
                    <div style="float:left;">5”</div>
                    <div style="clear:both;"></div>
                    <script type="text/javascript">
                        $("#jquery_jplayer_2").jPlayer({
                            ready: function () {
                                $(this).jPlayer("setMedia", {
                                    wav: "http://192.168.1.38:8002/test/hello.wav"
                                });
                            },
                            play: function () {
                                $(this).jPlayer("stopOthers");
                            },
                            ended: function () {
                                alert('end');
                            },
                            swfPath: "__THEME__/js",
                            supplied: "wav",
                            cssSelectorAncestor: "#jp_container_2",
                            wmode: "window",
                            globalVolume: true,
                            useStateClassSkin: true,
                            autoBlur: false,
                            smoothPlayBar: true,
                            keyEnabled: true
                        });

                    </script>
                </li>--%>
            </ul>
        </div>
        <div style="position:fixed; bottom:0; left:0; width:100%; text-align:center; line-break:50px; line-height:50px;">
            <input type="button" value="开始录音" id="startRecord" style="width:100px; height:40px;" />　
            <input type="button" value="发送" id="stopRecord" style="width:60px; height:40px;" />
        </div>
    </div>
</body>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script>
    wx.config({
        debug: false,
        appId: '<%=appId%>', // 必填，公众号的唯一标识
        timestamp: '<%=timeStamp%>', // 必填，生成签名的时间戳
        nonceStr: '<%=nonceStr%>', // 必填，生成签名的随机串
        signature: '<%=shaParam %>', // 必填，签名，见附录1
        jsApiList: [
          'translateVoice',
          'startRecord',
          'stopRecord',
          'onVoiceRecordEnd',
          'playVoice',
          'onVoicePlayEnd',
          'pauseVoice',
          'stopVoice',
          'uploadVoice',
          'downloadVoice'
        ]
    });

    
    $(document).ready(function () {
        setInterval("fillList()", 2000);
    });


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
<script src="wktScript.js"></script>
</html>
