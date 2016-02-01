<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>

<!DOCTYPE html>

<script runat="server">
    public string timeStamp = "";
    public string nonceStr = "3y2wsafsda11fqf2ad0bfswf90fqs6cw7fb";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid_dingyue"];
    public string token = "06517cbfb31f5fe5645c4d3138f2f9e9473c932a16727cfacec5416e5947362b44193b0d";
    public string roomid = "1";
    public ArrayList chatList = new ArrayList();
    public int userid = 0;
    public string liHtml = "";
    public string textLeft = "";
    public string textRight = "";
    public string voiceLeft = "";
    public string voiceRight = "";
    public int voiceIndex = 1;
    public string maxid = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        //roomid = Request["roomid"];
        
        timeStamp = Util.GetTimeStamp();
        ticket = Util.GetTicket();
        string shaString = "jsapi_ticket=" + ticket.Trim() + "&noncestr=" + nonceStr.Trim()
            + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
        shaParam = Util.GetSHA1(shaString);

        string listStr = Util.GetWebContent("http://game.luqinwenda.com/api/chat_timeline_list.aspx", "get", "", "text/html");
        System.Web.Script.Serialization.JavaScriptSerializer json = new System.Web.Script.Serialization.JavaScriptSerializer();
        Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(listStr);
        if (dic["status"].ToString() == "0")
        {
            chatList = (ArrayList)dic["chat_time_line"];
            maxid = dic["max_id"].ToString();
        }

        string userinfoStr = Util.GetWebContent("http://game.luqinwenda.com/api/user_info_get.aspx?token=" + token, "get", "", "text/html");
        Dictionary<string, object> userdic = json.Deserialize<Dictionary<string, object>>(userinfoStr);
        if (userdic["status"].ToString() == "0")
        {
            userid = Convert.ToInt32(userdic["uid"].ToString());
        }

        textLeft = "<div class=\"text-li\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div class=\"text-nick\">{1}</div><div class=\"text-content\">{2}</div><div style=\"position:absolute; left:65px; top:28px;\"><img src=\"images/jt_icon_left.png\" /></div></div><div class=\"clear\"></div></div>";
        textRight = "<div class=\"text-li-right\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div class=\"text-content\">{1}</div><div style=\"position:absolute; right:65px; top:0px;\"><img src=\"images/jt_icon_right.png\" /></div></div><div class=\"clear\"></div></div>";
        voiceLeft = "<div class=\"text-li\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div class=\"text-nick\"\">{1}</div><div class=\"text-content_radio\"><div id=\"jquery_jplayer_{3}\" class=\"jp-jplayer\"></div><div style=\"background:url(images/jplayerleft.png); width: 6px; height: 30px; top:29px; position: absolute;\"></div><div id=\"jp_container_{3}\" class=\"jp-audio\" role=\"application\" aria-label=\"media player\" onclick='changePlay(\"{3}\");' style=\"float:left;\"><a id=\"a_jp_play_{3}\" class=\"jp-play\" role=\"button\" tabindex=\"0\"><span class=\"jplay_play\"></span></a><a id=\"a_jp_stop_{3}\" class=\"jp-stop\" style=\"display: none;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_stop\"></span></a><div class=\"jp-duration\" role=\"timer\" aria-label=\"duration\" style=\"display: none;\"></div></div><div style=\"float:left; line-height:36px; margin-left:8px;\">5”</div><div style=\"clear:both;\"></div><script type=\"text/javascript\">$(\"#jquery_jplayer_{3}\").jPlayer({ready: function () {$(this).jPlayer(\"setMedia\", {mp3: \"{2}\"});},play: function () {$(this).jPlayer(\"stopOthers\");},ended: function () {$(\"#jp_container_{3}\").click();$(\"#jquery_jplayer_{4}\").jPlayer(\"play\");$(\"#jp_container_{4}\").click();},swfPath: \"__THEME__/js\",supplied: \"mp3\",cssSelectorAncestor: \"#jp_container_{3}\",wmode: \"window\",globalVolume: true,useStateClassSkin: true,autoBlur: false,smoothPlayBar: true,keyEnabled: true});&lt;/script&gt;</div></div><div class=\"clear\"></div></div>";
        voiceRight = "<div class=\"text-li-right\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div id=\"jquery_jplayer_{2}\" class=\"jp-jplayer\"></div><div style=\"float:left; line-height:40px;\">5”</div><div id=\"jp_container_{2}\" class=\"jp-audio\" role=\"application\" aria-label=\"media player\" onclick='changePlay(\"{2}\",\"R\");' style=\"float:left; margin-top: 5px;\"><a id=\"a_jp_play_{2}\" class=\"jp-play\" style=\"display:block;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_play_right\"></span></a><a id=\"a_jp_stop_{2}\" class=\"jp-stop\" style=\"display: none;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_stop_right jp-stop_right_3\"></span></a><div class=\"jp-duration\" role=\"timer\" aria-label=\"duration\" style=\"display: none;\"></div></div><div class=\"jt_right\"></div><div style=\"clear:both;\"></div><script type=\"text/javascript\">$(\"#jquery_jplayer_{2}\").jPlayer({ready: function () {$(this).jPlayer(\"setMedia\", {wav: \"{1}\"});},play: function () {$(this).jPlayer(\"stopOthers\");},ended: function () {$(\"#jp_container_{2}\").click();$(\"#jquery_jplayer_{3}\").jPlayer(\"play\");$(\"#jp_container_{3}\").click();},swfPath: \"__THEME__/js\",supplied: \"wav\",cssSelectorAncestor: \"#jp_container_{2}\",wmode: \"window\",globalVolume: true,useStateClassSkin: true,autoBlur: false,smoothPlayBar: true,keyEnabled: true});&lt;/script&gt;</div><div class=\"clear\"></div></div>";
        
        foreach (var item in chatList)
        {
            string liItem = ""; ;
            Dictionary<string, object> chatDic = (Dictionary<string, object>)item;
            switch (chatDic["message_type"].ToString())
            {
                case "text":
                    {
                        if (userid == Convert.ToInt32(chatDic["user_id"].ToString()))
                        {
                            liItem = string.Format(textRight, chatDic["avatar"].ToString(), chatDic["message_content"].ToString());
                        }
                        else
                        {
                            liItem = string.Format(textLeft, chatDic["avatar"].ToString(), chatDic["nick"].ToString(), chatDic["message_content"].ToString());
                        }
                    }
                    break;
                case "voice":
                    {
                        if (userid == Convert.ToInt32(chatDic["user_id"].ToString()))
                        {
                            //liItem = string.Format(voiceRight, chatDic["avatar"].ToString(), chatDic["message_content"].ToString(), voiceIndex, voiceIndex + 1);
                            liItem = voiceRight.Replace("{0}", chatDic["avatar"].ToString());
                            liItem = liItem.Replace("{1}", chatDic["message_content"].ToString());
                            liItem = liItem.Replace("{2}", voiceIndex.ToString());
                            liItem = liItem.Replace("{3}", (voiceIndex + 1).ToString());
                        }
                        else
                        {
                            liItem = voiceLeft.Replace("{0}", chatDic["avatar"].ToString());
                            liItem = liItem.Replace("{1}", chatDic["nick"].ToString());
                            liItem = liItem.Replace("{2}", chatDic["message_content"].ToString());
                            liItem = liItem.Replace("{3}", voiceIndex.ToString());
                            liItem = liItem.Replace("{4}", (voiceIndex + 1).ToString());
                        }
                        voiceIndex++;
                    }
                    break;
                default:
                    break;
            }
            liHtml += "<li>" + liItem + "</li>";
        }

        liHtml = liHtml.Replace("&lt;", "<").Replace("&gt;", ">");
    }
    
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <title></title>
    <script src="../script/jquery-2.1.1.min.js"></script>
    <script src="../script/common.js"></script>
    <script src="../script/jquery.jplayer.js"></script>
    <link href="../style/jplayer.blue.monday.min.css" rel="stylesheet" />

    <style type="text/css">
        body { font-size:14px; }
        ul, li, p, h1, h2, h3, h4, h5, h6, dl, dt, dd, form, input, textarea, select { list-style-type:none; padding:0;}
        .clear { clear:both;}
        .jp-audio, .jp-audio-stream, .jp-video { margin-left: 5px; border: 1px solid #7AA23F; background: url(images/jplayerbg.png);  border-radius:4px;  width: 90px; height: 36px; line-height: 36px; padding:0 5px;}
        .jp-play { width: 100%; height: 36px; display: block; padding-top: 9px;}
        .jplay_play { background: url(images/jplayerstop.png) no-repeat; width: 16px; height: 19px; display: block; }
        .jp-play:focus { background: none;}
        .jplay_play_right { background: url(images/jplayerstop_right.png) no-repeat; width: 16px; height: 19px; display: block; float:right; }
        .jp-stop {  width: 100%; height: 36px; display: block; margin-left: 0; padding-top: 9px; margin-top: 0; }
        .jplay_stop { display: block; margin-left: 0px;}
        .jplay_stop_right { display: block; margin-left: 0px; float:right;}
        .jp-stop:focus { background: none; margin-left: 0; }
        .feed_file_list { border: none; margin:0 10px;}
        .jp-stop_1 { background: url(images/jplayerplay.png) no-repeat 0 0; width: 16px; height: 19px;  }
        .jp-stop_2 { background: url(images/jplayerplay.png) no-repeat -18px 0; width: 16px; height: 19px;  }
        .jp-stop_3 { background: url(images/jplayerplay.png) no-repeat -39px 0; width: 18px; height: 19px;  }
        .jp-stop_right_1 { background: url(images/jplayerplay_right.png) no-repeat -41px 0; width: 16px; height: 19px;  }
        .jp-stop_right_2 { background: url(images/jplayerplay_right.png) no-repeat -23px 0; width: 16px; height: 19px;  }
        .jp-stop_right_3 { background: url(images/jplayerplay_right.png) no-repeat -0px 0; width: 18px; height: 19px;  }
        .feed_file_list li { padding-left: 0px; margin-top:20px;}
        .text-li { position:relative; min-height:50px; width:90%;}
        .text-li .left-head { position:absolute; top:10px; left:10px; }
        .text-li .left-head img { width:50px; border-radius:4px; }
        .text-li .right-content { float:left; margin-left:70px; }
        .text-li .right-content .text-nick { line-height:22px; height:22px; }
        .text-li .right-content .text-content { background:#fff; border-radius:5px; padding:10px; line-height:22px; margin-top:5px;}
        .text-li .right-content .text-content_radio { line-height:22px; margin-top:5px;}

        .text-li-right { position:relative; min-height:50px; width:90%; float:right; margin:5px 0;}
        .text-li-right .left-head { position:absolute; top:0px; right:10px; }
        .text-li-right .left-head img { width:50px; border-radius:4px; }
        .text-li-right .right-content { float:right; margin-right:70px; }
        .text-li-right .right-content .text-content {  background:#B4EB7C; border-radius:5px; padding:10px; line-height:22px; float:right;}

        .jt_right { background:url(images/jplayerright.png); width: 6px; height: 30px; right:65px; top:7px; position: absolute; z-index:99 }
    </style>
</head>
<body style="max-width:640px; margin:0 auto; background:#F2F2F2; border:1px solid #ccc;">
    <form id="form1" runat="server">
    <div id="mydiv">
        <div>
            <ul id="feed_file_list" class="feed_file_list">
                <%=liHtml %>
                <div style="clear:both;"></div>
            </ul>
        </div>
        <div style="height:60px; clear:both;"></div>
        <div id="msg_end" style="height:0px; overflow:hidden"></div>
        <div style="position:fixed; bottom:0; left:0; width:100%; text-align:center; line-break:50px; line-height:50px; background:#fff; z-index:100;">
            <a id="switchInput" onclick="changeInput();" style=" border:1px solid #7AA23F; position:absolute; top:5px; left:5px; line-height:25px; ">切换</a>
            <div style=" display:none;" id="input_voice">
                <input type="button" value="开始录音" id="startRecord" style="width:100px; height:40px;" />　
                <input type="button" value="停止录音" id="stopRecord" style="width:100px; height:40px; display:none;" />
            </div>
            <div style="display:flex; text-align:center; margin-left:40px; height:55px;" id="input_text">
                <textarea id="textContent" placeholder="请输入内容..." style=" display:inline-block; padding:0px 5px; margin-top:5px; width:100%; height:44px; line-height:22px; font-size:14px;"></textarea>　
                <input type="button" value="发送" style="width:50px; height:25px; margin-top:25px;" onclick="inputText();" />
            </div>
        </div>
    </div>
    </form>
</body>
<%--<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>--%>
<script>
    var userid = '<%=userid %>';
    var token = '<%=token %>';
    var roomid = '<%=roomid %>';
    var voiceIndex = '<%=voiceIndex %>';
    var maxid = '<%=maxid %>';
    var textLeft = '<%=textLeft %>';
    var textRight = '<%=textRight %>';
    var textLeft = "<div class=\"text-li\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div class=\"text-nick\">{1}</div><div class=\"text-content\">{2}</div><div style=\"position:absolute; left:65px; top:28px;\"><img src=\"images/jt_icon_left.png\" /></div></div><div class=\"clear\"></div></div>";
    var textRight = "<div class=\"text-li-right\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div class=\"text-content\">{1}</div><div style=\"position:absolute; right:65px; top:0px;\"><img src=\"images/jt_icon_right.png\" /></div></div><div class=\"clear\"></div></div>";
    var voiceLeft = "<div class=\"text-li\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div class=\"text-nick\"\">{1}</div><div class=\"text-content_radio\"><div id=\"jquery_jplayer_{3}\" class=\"jp-jplayer\"></div><div style=\"background:url(images/jplayerleft.png); width: 6px; height: 30px; top:29px; position: absolute;\"></div><div id=\"jp_container_{3}\" class=\"jp-audio\" role=\"application\" aria-label=\"media player\" onclick='changePlay(\"{3}\");' style=\"float:left;\"><a id=\"a_jp_play_{3}\" class=\"jp-play\" role=\"button\" tabindex=\"0\"><span class=\"jplay_play\"></span></a><a id=\"a_jp_stop_{3}\" class=\"jp-stop\" style=\"display: none;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_stop\"></span></a><div class=\"jp-duration\" role=\"timer\" aria-label=\"duration\" style=\"display: none;\"></div></div><div style=\"float:left; line-height:36px; margin-left:8px;\">5”</div><div style=\"clear:both;\"></div><script type=\"text/javascript\">$(\"#jquery_jplayer_{3}\").jPlayer({ready: function () {$(this).jPlayer(\"setMedia\", {mp3: \"{2}\"});},play: function () {$(this).jPlayer(\"stopOthers\");},ended: function () {$(\"#jp_container_{3}\").click();$(\"#jquery_jplayer_{4}\").jPlayer(\"play\");$(\"#jp_container_{4}\").click();},swfPath: \"__THEME__/js\",supplied: \"mp3\",cssSelectorAncestor: \"#jp_container_{3}\",wmode: \"window\",globalVolume: true,useStateClassSkin: true,autoBlur: false,smoothPlayBar: true,keyEnabled: true});&lt;/script&gt;</div></div><div class=\"clear\"></div></div>";
    var voiceRight = "<div class=\"text-li-right\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div id=\"jquery_jplayer_{2}\" class=\"jp-jplayer\"></div><div style=\"float:left; line-height:40px;\">5”</div><div id=\"jp_container_{2}\" class=\"jp-audio\" role=\"application\" aria-label=\"media player\" onclick='changePlay(\"{2}\",\"R\");' style=\"float:left; margin-top: 5px;\"><a id=\"a_jp_play_{2}\" class=\"jp-play\" style=\"display:block;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_play_right\"></span></a><a id=\"a_jp_stop_{2}\" class=\"jp-stop\" style=\"display: none;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_stop_right jp-stop_right_3\"></span></a><div class=\"jp-duration\" role=\"timer\" aria-label=\"duration\" style=\"display: none;\"></div></div><div class=\"jt_right\"></div><div style=\"clear:both;\"></div><script type=\"text/javascript\">$(\"#jquery_jplayer_{2}\").jPlayer({ready: function () {$(this).jPlayer(\"setMedia\", {wav: \"{1}\"});},play: function () {$(this).jPlayer(\"stopOthers\");},ended: function () {$(\"#jp_container_{2}\").click();$(\"#jquery_jplayer_{3}\").jPlayer(\"play\");$(\"#jp_container_{3}\").click();},swfPath: \"__THEME__/js\",supplied: \"wav\",cssSelectorAncestor: \"#jp_container_{2}\",wmode: \"window\",globalVolume: true,useStateClassSkin: true,autoBlur: false,smoothPlayBar: true,keyEnabled: true});&lt;/script&gt;</div><div class=\"clear\"></div></div>";

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
</script>
<script src="wktScript.js"></script>
</html>
