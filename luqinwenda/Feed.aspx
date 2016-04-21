<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>

<script runat="server">
    public string timeStamp = "";
    public string nonceStr = "wsa11fiqfs2ad0ewf90fqmcwbb";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid_dingyue"];
    
    public string token = "";
    public string roomid = "0";
    public int userid = 0;    
    public string domainName = System.Configuration.ConfigurationManager.AppSettings["domain_name"].ToString();
    public int feedId = 0;
    public string expertlist = System.Configuration.ConfigurationManager.AppSettings["Luqinwenda_expert_Idlist"].ToString();
    protected void Page_Load(object sender, EventArgs e)
    {
        feedId = int.Parse(Util.GetSafeRequestValue(Request, "feedid", "0"));
        if (feedId == 0)
        {
            Response.Write("参数错误");
            Response.End();
        }
        roomid = Util.GetSafeRequestValue(Request, "roomid", "0");
        if (int.Parse(roomid) <= 0)
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

        if (Array.IndexOf(expertlist.Split(','), userid.ToString()) >= 0)
        {
            ChatTimeLine.Update_State(feedId, 1);
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
    <div id="mydiv"  class="main-page">
        <div>
            <ul id="feed_file_list" class="feed_file_list">
                
            </ul>
        </div>

        <div id="bottomDiv" style="height:60px; clear:both;"></div>
        <div style="position:fixed; bottom:0; left:0; width:100%; background:#fff; border-top:1px solid #ccc; text-align:center; line-height:55px; z-index:100;">
            <div id="input_text" style="display:none;">
                <div style="width:50px; float:left; text-align:center;"><a class="horn-change" onclick="changeInput();"></a></div>
                <div style="width:auto; float:left;" ><input id="textContent" type="text" style="border:2px solid #CACACA; border-radius:5px; width:100%; height:30px; line-height:30px; padding:2px 5px;"  /></div>
                <div style="width:90px; float:right;"><input type="button" class="btn-feed-send" onclick="inputText(<%=feedId %>);" /></div>
            </div>
            <div id="input_voice">
                <div style="width:50px; float:left; text-align:center;"><a class="horn-change" onclick="changeInput();"></a></div>
                <input type="button" value="点击说话" id="startRecord" style="width:80%; height:40px;" />
                <input type="button" value="停止说话" id="stopRecord" style="width:80%; height:40px; display:none;" />
            </div>
        </div>
    </div>
    <script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript">
        var feedid = '<%=feedId %>';
        var userid = '<%=userid %>';
        var token = '<%=token %>';
        var roomid = '<%=roomid %>';
        var voiceIndex = '1';
        var domainName = '<%=domainName %>';
        var expertlist = '<%=expertlist %>';
        var maxId = '';
        var textLeft = "<div class=\"text-li\"><div class=\"left-head\"><img src=\"{0}\" /></div>"
                + "<div class=\"right-content\"><div class=\"text-nick\">{1}</div>"
                + "<div class=\"text-content\">{2}</div>"
                + "<div class=\"text_jiantou\"><img src=\"images/jt_icon_left.png\" /></div></div>"
                + "<div class=\"clear\"></div><div class=\"text-time\">{3}</div></div>";
        var textRight = "<div class=\"text-li-right\"><div class=\"left-head\"><img src=\"{0}\" /></div>"
            + "<div class=\"right-content\"><div class=\"text-content\">{1}</div>"
            + "<div class=\"text_jiantou\"><img src=\"images/jt_icon_right.png\" /></div></div>"
            + "<div class=\"clear\"></div><div class=\"text-time\">{2}</div></div>"
            + "<div class=\"clear\"></div>";
        var voiceLeft = "<div class=\"text-li\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div class=\"text-nick\">{1}</div><div class=\"text-content_radio\"><div id=\"jquery_jplayer_{3}\" class=\"jp-jplayer\"></div><div class=\"jt_left\"></div><div id=\"jp_container_{3}\" class=\"jp-audio\" role=\"application\" aria-label=\"media player\" onclick='changePlay(\"{3}\");' style=\"float:left;{6}\"><a id=\"a_jp_play_{3}\" class=\"jp-play\" role=\"button\" tabindex=\"0\"><span class=\"jplay_play\"></span></a><a id=\"a_jp_stop_{3}\" class=\"jp-stop\" style=\"display: none;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_stop\"></span></a><div class=\"jp-duration\" role=\"timer\" aria-label=\"duration\" style=\"display: none;\"></div></div><div class=\"voice-second\">{5}”</div><div id=\"dot_{3}\" class=\"dots\"><img src=\"images/dots.png\"></div><div style=\"clear:both;\"></div><script type=\"text/javascript\">$(\"#jquery_jplayer_{3}\").jPlayer({ready: function () {$(this).jPlayer(\"setMedia\", {mp3: \"{2}\"});},play: function () {$(this).jPlayer(\"stopOthers\");},ended: function () {$(\"#jp_container_{3}\").click();$(\"#jquery_jplayer_{4}\").jPlayer(\"play\");$(\"#jp_container_{4}\").click();},swfPath: \"__THEME__/js\",supplied: \"mp3\",cssSelectorAncestor: \"#jp_container_{3}\",wmode: \"window\",globalVolume: true,useStateClassSkin: true,autoBlur: false,smoothPlayBar: true,keyEnabled: true});&lt;/script&gt;</div></div><div class=\"clear\"></div><div class=\"text-time\">{7}</div></div>";
        var voiceRight = "<div class=\"text-li-right\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div id=\"jquery_jplayer_{2}\" class=\"jp-jplayer\"></div><div id=\"dot_{2}\" class=\"dots\"><img src=\"images/dots.png\"></div><div class=\"voice-second\">{4}”</div><div id=\"jp_container_{2}\" class=\"jp-audio\" role=\"application\" aria-label=\"media player\" onclick='changePlay(\"{2}\",\"R\");' style=\"float:left; margin-top:5px; {5}\"><a id=\"a_jp_play_{2}\" class=\"jp-play\" style=\"display:block;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_play_right\"></span></a><a id=\"a_jp_stop_{2}\" class=\"jp-stop\" style=\"display: none;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_stop_right jp-stop_right_3\"></span></a><div class=\"jp-duration\" role=\"timer\" aria-label=\"duration\" style=\"display: none;\"></div></div><div class=\"jt_right\"></div><div style=\"clear:both;\"></div><script type=\"text/javascript\">$(\"#jquery_jplayer_{2}\").jPlayer({ready: function () {$(this).jPlayer(\"setMedia\", {wav: \"{1}\"});},play: function () {$(this).jPlayer(\"stopOthers\");},ended: function () {$(\"#jp_container_{2}\").click();$(\"#jquery_jplayer_{3}\").jPlayer(\"play\");$(\"#jp_container_{3}\").click();},swfPath: \"__THEME__/js\",supplied: \"wav\",cssSelectorAncestor: \"#jp_container_{2}\",wmode: \"window\",globalVolume: true,useStateClassSkin: true,autoBlur: false,smoothPlayBar: true,keyEnabled: true});&lt;/script&gt;</div><div style=\"clear:both;\"></div><div class=\"text-time\">{6}</div></div><div class=\"clear\"></div>";
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
        $(document).ready(function () {
            $("#textContent").parent().css("width", (winWidth - 155).toString() + "px");

            fillFeed();

        });

        
        function fillFeed() {
            $.ajax({
                type: "GET",
                async: false,
                url: "http://" + domainName + "/api/chat_timeline_feed.aspx",
                data: { roomid: roomid, token: token, messageid: feedid },
                dataType: "json",
                success: function (data) {
                    var inHtml = '';
                    if (data.status == 0 && data.chat_time_line_father) {
                        
                        liItem = String.format(textLeft, data.chat_time_line_father.avatar, data.chat_time_line_father.nick, data.chat_time_line_father.message_content, strTohoursecond(data.chat_time_line_father.create_date));
                        inHtml += "<li>" + liItem.replace("&lt;", "<").replace("&gt;", ">") + "</li>";
                        $('.feed_file_list').html(inHtml);
                        fillAnswer();
                        setInterval("fillAnswer()", 5000);
                    }
                }
            });
        }

        function fillAnswer() {
            $.ajax({
                type: "GET",
                async: false,
                url: "http://" + domainName + "/api/chat_timeline_feed.aspx",
                data: { roomid: roomid, token: token, messageid: feedid, maxid: maxId },
                dataType: "json",
                success: function (data) {
                    var inHtml = '';
                    if (data.status == 0 && data.count > 0) {
                        maxId = data.max_id;
                        //答案
                        var expertArr = expertlist.split(',');
                        for (var i = 0; i < data.chat_time_line.length; i++) {
                            inHtml = "";
                            var liItem = '';
                            var chatline = data.chat_time_line[i];                            
                            switch (chatline.message_type) {
                                case "text":
                                    {
                                        if ($.inArray(chatline.user_id.toString(), expertArr) >= 0)
                                            liItem = String.format(textRight, chatline.avatar, chatline.message_content, strTohoursecond(chatline.create_date));
                                        else
                                            liItem = String.format(textLeft, chatline.avatar, chatline.nick, chatline.message_content, strTohoursecond(chatline.create_date), "", "");
                                    }
                                    break;
                                case "voice":
                                    {
                                        var vlen = parseInt(chatline.voice_length) * 3;
                                        if (vlen < 60)
                                            vlen = 60;
                                        if ($.inArray(chatline.user_id.toString(), expertArr) >= 0)
                                            liItem = String.format(voiceRight, chatline.avatar, chatline.message_content, voiceIndex, (parseInt(voiceIndex) + 1).toString(), chatline.voice_length, "width:" + vlen + "px", strTohoursecond(chatline.create_date));
                                        else
                                            liItem = String.format(voiceLeft, chatline.avatar, chatline.nick, chatline.message_content, voiceIndex, (parseInt(voiceIndex) + 1).toString(), chatline.voice_length, "width:" + vlen + "px", strTohoursecond(chatline.create_date));

                                        voiceIndex = (parseInt(voiceIndex) + 1).toString();
                                    }
                                    break;
                                default:
                            }
                            
                            inHtml += "<li>" + liItem.replace("&lt;", "<").replace("&gt;", ">") + "</li>";
                            $('.feed_file_list li:last').after(inHtml);
                            
                        }
                    }
                }
            });
        }

        function changeInput()
        {
            if($('#input_voice').css("display") == "none")
            {
                $('#input_text').css("display","none");
                $('#input_voice').css("display","");
            }
            else
            {
                $('#input_text').css("display","");
                $('#input_voice').css("display","none");
            }
        }
    </script>
    <script src="wxRecord.js"></script>
</asp:Content>

