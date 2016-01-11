<%@ Page Language="C#" %>

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
</head>
<body style="width:640px; margin:0 auto; background:#efadad;">
    <div>
        <div>

            <%--<div id="jquery_jplayer_1" class="jp-jplayer"></div>
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
                    cssSelectorAncestor: "#jp_container_1",
                    wmode: "window",
                    globalVolume: true,
                    useStateClassSkin: true,
                    autoBlur: false,
                    smoothPlayBar: true,
                    keyEnabled: true
                });

            </script>--%>

        </div>
        <div style="position:fixed; bottom:0; left:0; width:100%; text-align:center; line-break:50px; line-height:50px;">
            <input type="button" value="开始录音" id="startRecord" />　
            <input type="button" value="发送" id="stopRecord" />
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

    var voiceArr = [];

</script>
<script src="wktScript.js"></script>
</html>
