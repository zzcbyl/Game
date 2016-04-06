<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>

<script runat="server">
    public string timeStamp = "";
    public string nonceStr = "wsa11fiqfs2ad0ewf90fqmcwbb";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid_dingyue"];
    
    public string token = "";
    public string roomid = "2";
    public int userid = 0;
    public int voiceIndex = 1;
    public string maxid = "0";
    public string domainName = System.Configuration.ConfigurationManager.AppSettings["domain_name"].ToString();
    public int feedId = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        feedId = int.Parse(Util.GetSafeRequestValue(Request, "feedid", "0"));
        if (feedId == 0)
        {
            Response.Write("参数错误");
            Response.End();
        }
        
        
        token = Util.GetSafeRequestValue(Request, "token", "");
        userid = Users.CheckToken(token);
        if (userid <= 0)
        {
            string currentUrl = Request.Url.ToString();
            if (token != "")
                currentUrl = currentUrl.Replace("&token=" + token, "").Replace("?token=" + token, "");
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(currentUrl), true);
        }

        timeStamp = Util.GetTimeStamp();
        ticket = Util.GetTicket();
        string shaString = "jsapi_ticket=" + ticket.Trim() + "&noncestr=" + nonceStr.Trim()
            + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
        shaParam = Util.GetSHA1(shaString);
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="mydiv">
        <div>
            <ul id="feed_file_list" class="feed_file_list">
                <li>                    <div class="text-li">                        <div class="left-head">                            <img src="http://wx.qlogo.cn/mmopen/M13tqMABLia0mbuQSR36GgqxLRqK0ExSLIj8cEVy2pMQYR7xVwxAg5Is6Y3SiaHP03iciaQZJW1PicHhC4122Va5DSw/0" /></div>                        <div class="right-content">                            <div class="text-nick">老莫</div>                            <div class="text-content">啊岁的法撒旦2314234</div>                            <div style="position:absolute; left:65px; top:28px;"><img src="images/jt_icon_left.png" /></div>
                        </div>                        <div class="clear"></div>
                    </div>
                </li>                <li>                    <div class="text-li">                        <div class="left-head"><img src="http://wx.qlogo.cn/mmopen/M13tqMABLia0mbuQSR36GgqxLRqK0ExSLIj8cEVy2pMQYR7xVwxAg5Is6Y3SiaHP03iciaQZJW1PicHhC4122Va5DSw/0" /></div>                        <div class="right-content">                            <div class="text-nick">老莫</div>                            <div class="text-content">1234123这次vzxcvasdfasqweradfasd啊岁的法撒旦发射</div>                            <div style="position:absolute; left:65px; top:28px;"><img src="images/jt_icon_left.png" /></div>
                        </div>                        <div class="clear"></div>
                    </div>
                </li>      
                <div style="clear:both;"></div>
            </ul>
        </div>

        <div id="bottomDiv" style="height:60px; clear:both;"></div>
        <div style="position:fixed; bottom:0; left:0; width:100%; text-align:center; line-height:55px; background:#fff; z-index:100;">
            <div id="input_voice">
                <input type="button" value="开始录音" id="startRecord" style="width:100px; height:40px;" />
                <input type="button" value="停止录音" id="stopRecord" style="width:100px; height:40px; display:none;" />
            </div>
        </div>
    </div>
    <script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript">
        var feedid = '<%=feedId %>';
        var userid = '<%=userid %>';
        var token = '<%=token %>';
        var roomid = '<%=roomid %>';
        var voiceIndex = '<%=voiceIndex %>';
        var maxid = '<%=maxid %>';
        var domainName = '<%=domainName %>';
        var textLeft = "<div class=\"text-li\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div class=\"text-nick\">{1}</div><div class=\"text-content\">{2}</div><div style=\"position:absolute; left:65px; top:28px;\"><img src=\"images/jt_icon_left.png\" /></div></div><div class=\"clear\"></div></div>";
        var textRight = "<div class=\"text-li-right\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div class=\"text-content\">{1}</div><div style=\"position:absolute; right:65px; top:0px;\"><img src=\"images/jt_icon_right.png\" /></div></div></div><div class=\"clear\"></div>";
        var voiceLeft = "<div class=\"text-li\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div class=\"text-nick\">{1}</div><div class=\"text-content_radio\"><div id=\"jquery_jplayer_{3}\" class=\"jp-jplayer\"></div><div style=\"background:url(images/jplayerleft.png); width: 6px; height: 30px; top:29px; position: absolute;\"></div><div id=\"jp_container_{3}\" class=\"jp-audio\" role=\"application\" aria-label=\"media player\" onclick='changePlay(\"{3}\");' style=\"float:left;{6}\"><a id=\"a_jp_play_{3}\" class=\"jp-play\" role=\"button\" tabindex=\"0\"><span class=\"jplay_play\"></span></a><a id=\"a_jp_stop_{3}\" class=\"jp-stop\" style=\"display: none;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_stop\"></span></a><div class=\"jp-duration\" role=\"timer\" aria-label=\"duration\" style=\"display: none;\"></div></div><div style=\"float:left; line-height:36px; margin-left:8px;\">{5}”</div><div id=\"dot_{3}\" class=\"dots\"><img src=\"images/dots.png\"></div><div style=\"clear:both;\"></div><script type=\"text/javascript\">$(\"#jquery_jplayer_{3}\").jPlayer({ready: function () {$(this).jPlayer(\"setMedia\", {mp3: \"{2}\"});},play: function () {$(this).jPlayer(\"stopOthers\");},ended: function () {$(\"#jp_container_{3}\").click();$(\"#jquery_jplayer_{4}\").jPlayer(\"play\");$(\"#jp_container_{4}\").click();},swfPath: \"__THEME__/js\",supplied: \"mp3\",cssSelectorAncestor: \"#jp_container_{3}\",wmode: \"window\",globalVolume: true,useStateClassSkin: true,autoBlur: false,smoothPlayBar: true,keyEnabled: true});&lt;/script&gt;</div></div><div class=\"clear\"></div></div>";
        var voiceRight = "<div class=\"text-li-right\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div id=\"jquery_jplayer_{2}\" class=\"jp-jplayer\"></div><div id=\"dot_{2}\" class=\"dots\"><img src=\"images/dots.png\"></div><div style=\"float:left; line-height:40px; margin-top: 5px;\">{4}”</div><div id=\"jp_container_{2}\" class=\"jp-audio\" role=\"application\" aria-label=\"media player\" onclick='changePlay(\"{2}\",\"R\");' style=\"float:left; margin-top:5px; {5}\"><a id=\"a_jp_play_{2}\" class=\"jp-play\" style=\"display:block;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_play_right\"></span></a><a id=\"a_jp_stop_{2}\" class=\"jp-stop\" style=\"display: none;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_stop_right jp-stop_right_3\"></span></a><div class=\"jp-duration\" role=\"timer\" aria-label=\"duration\" style=\"display: none;\"></div></div><div class=\"jt_right\"></div><div style=\"clear:both;\"></div><script type=\"text/javascript\">$(\"#jquery_jplayer_{2}\").jPlayer({ready: function () {$(this).jPlayer(\"setMedia\", {wav: \"{1}\"});},play: function () {$(this).jPlayer(\"stopOthers\");},ended: function () {$(\"#jp_container_{2}\").click();$(\"#jquery_jplayer_{3}\").jPlayer(\"play\");$(\"#jp_container_{3}\").click();},swfPath: \"__THEME__/js\",supplied: \"wav\",cssSelectorAncestor: \"#jp_container_{2}\",wmode: \"window\",globalVolume: true,useStateClassSkin: true,autoBlur: false,smoothPlayBar: true,keyEnabled: true});&lt;/script&gt;</div></div><div class=\"clear\"></div>";
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
              'downloadVoice',
              'chooseImage',
              'previewImage',
              'uploadImage',
              'downloadImage'
            ]
        });
    </script>
</asp:Content>

