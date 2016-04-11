<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>


<script runat="server">
    public string token = "89970452e9cf12c3dfe576e0eef8c47a10fc94a4a36a8ac60a51e9a4488bb3027e9d1499";
    public string roomid = "2";
    public ArrayList chatList = new ArrayList();
    public int userid = 0;
    public string liHtml = "";
    public string textLeft = "";
    public string textRight = "";
    public string voiceLeft = "";
    public string voiceRight = "";
    public int voiceIndex = 1;
    public string maxid = "0";
    public string domainName = System.Configuration.ConfigurationManager.AppSettings["domain_name"].ToString();
    public string canText = "0";
    public string canVoice = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        token = Util.GetSafeRequestValue(Request, "token", "");
        userid = Users.CheckToken(token);
        if (userid <= 0)
        {
            string currentUrl = Request.Url.ToString();
            if (token != "")
                currentUrl = currentUrl.Replace("&token=" + token, "").Replace("?token=" + token, "");
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(currentUrl), true);
        }

        //判断权限
        System.Web.Script.Serialization.JavaScriptSerializer json = new System.Web.Script.Serialization.JavaScriptSerializer();
        string roomRightStr = Util.GetWebContent("http://" + domainName + "/api/chat_room_rights.aspx?token=" + token + "&roomid=" + roomid, "get", "", "text/html");
        Dictionary<string, object> rightdic = json.Deserialize<Dictionary<string, object>>(roomRightStr);
        if (rightdic["status"].ToString() == "0")
        {
            if (rightdic["can_enter"].ToString().Equals("1") && rightdic["can_publish_text"].ToString().Equals("1"))
                canText = "1";
            if (rightdic["can_enter"].ToString().Equals("1") && rightdic["can_publish_voice"].ToString().Equals("1"))
                canVoice = "1";
        }

        //获取数据列表
        //    string listStr = Util.GetWebContent("http://" + domainName + "/api/chat_timeline_list.aspx?roomid=" + roomid, "get", "", "text/html");
        //    Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(listStr);
        //    if (dic["status"].ToString() == "0")
        //    {
        //        chatList = (ArrayList)dic["chat_time_line"];
        //        maxid = dic["max_id"].ToString();
        //    }

        //    textLeft = "<div class=\"text-li\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div class=\"text-nick\">{1}</div><div class=\"text-content\">{2}</div><div style=\"position:absolute; left:65px; top:28px;\"><img src=\"images/jt_icon_left.png\" /></div></div><div class=\"clear\"></div></div>";
        //    textRight = "<div class=\"text-li-right\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div class=\"text-content\">{1}</div><div style=\"position:absolute; right:65px; top:0px;\"><img src=\"images/jt_icon_right.png\" /></div></div></div><div class=\"clear\"></div>";
        //    voiceLeft = "<div class=\"text-li\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div class=\"text-nick\">{1}</div><div class=\"text-content_radio\"><div id=\"jquery_jplayer_{3}\" class=\"jp-jplayer\"></div><div style=\"background:url(images/jplayerleft.png); width: 6px; height: 30px; top:29px; position: absolute;\"></div><div id=\"jp_container_{3}\" class=\"jp-audio\" role=\"application\" aria-label=\"media player\" onclick='changePlay(\"{3}\");' style=\"float:left;{6}\"><a id=\"a_jp_play_{3}\" class=\"jp-play\" role=\"button\" tabindex=\"0\"><span class=\"jplay_play\"></span></a><a id=\"a_jp_stop_{3}\" class=\"jp-stop\" style=\"display: none;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_stop\"></span></a><div class=\"jp-duration\" role=\"timer\" aria-label=\"duration\" style=\"display: none;\"></div></div><div style=\"float:left; line-height:36px; margin-left:8px;\">{5}”</div><div id=\"dot_{3}\" class=\"dots\"><img src=\"images/dots.png\"></div><div style=\"clear:both;\"></div><script type=\"text/javascript\">$(\"#jquery_jplayer_{3}\").jPlayer({ready: function () {$(this).jPlayer(\"setMedia\", {mp3: \"{2}\"});},play: function () {$(this).jPlayer(\"stopOthers\");},ended: function () {$(\"#jp_container_{3}\").click();$(\"#jquery_jplayer_{4}\").jPlayer(\"play\");$(\"#jp_container_{4}\").click();},swfPath: \"__THEME__/js\",supplied: \"mp3\",cssSelectorAncestor: \"#jp_container_{3}\",wmode: \"window\",globalVolume: true,useStateClassSkin: true,autoBlur: false,smoothPlayBar: true,keyEnabled: true});&lt;/script&gt;</div></div><div class=\"clear\"></div></div>";
        //    voiceRight = "<div class=\"text-li-right\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div id=\"jquery_jplayer_{2}\" class=\"jp-jplayer\"></div><div id=\"dot_{2}\" class=\"dots\"><img src=\"images/dots.png\"></div><div style=\"float:left; line-height:40px; margin-top: 5px;\">{4}”</div><div id=\"jp_container_{2}\" class=\"jp-audio\" role=\"application\" aria-label=\"media player\" onclick='changePlay(\"{2}\",\"R\");' style=\"float:left; margin-top:5px; {5}\"><a id=\"a_jp_play_{2}\" class=\"jp-play\" style=\"display:block;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_play_right\"></span></a><a id=\"a_jp_stop_{2}\" class=\"jp-stop\" style=\"display: none;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_stop_right jp-stop_right_3\"></span></a><div class=\"jp-duration\" role=\"timer\" aria-label=\"duration\" style=\"display: none;\"></div></div><div class=\"jt_right\"></div><div style=\"clear:both;\"></div><script type=\"text/javascript\">$(\"#jquery_jplayer_{2}\").jPlayer({ready: function () {$(this).jPlayer(\"setMedia\", {wav: \"{1}\"});},play: function () {$(this).jPlayer(\"stopOthers\");},ended: function () {$(\"#jp_container_{2}\").click();$(\"#jquery_jplayer_{3}\").jPlayer(\"play\");$(\"#jp_container_{3}\").click();},swfPath: \"__THEME__/js\",supplied: \"wav\",cssSelectorAncestor: \"#jp_container_{2}\",wmode: \"window\",globalVolume: true,useStateClassSkin: true,autoBlur: false,smoothPlayBar: true,keyEnabled: true});&lt;/script&gt;</div></div><div class=\"clear\"></div>";

        //    foreach (var item in chatList)
        //    {
        //        string liItem = ""; ;
        //        Dictionary<string, object> chatDic = (Dictionary<string, object>)item;
        //        switch (chatDic["message_type"].ToString())
        //        {
        //            case "text":
        //                {

        //                        liItem = string.Format(textLeft, chatDic["avatar"].ToString(), chatDic["nick"].ToString(), chatDic["message_content"].ToString().Replace("\n", "<br />"));
        //                }
        //                break;
        //            case "voice":
        //                {
        //                    int vlen = Convert.ToInt32(chatDic["voice_length"].ToString()) * 3;
        //                    if (vlen < 60)
        //                        vlen = 60;

        //                    liItem = voiceLeft.Replace("{0}", chatDic["avatar"].ToString());
        //                    liItem = liItem.Replace("{1}", chatDic["nick"].ToString());
        //                    liItem = liItem.Replace("{2}", chatDic["message_content"].ToString());
        //                    liItem = liItem.Replace("{3}", voiceIndex.ToString());
        //                    liItem = liItem.Replace("{4}", (voiceIndex + 1).ToString());
        //                    liItem = liItem.Replace("{5}", chatDic["voice_length"].ToString());
        //                    liItem = liItem.Replace("{6}", "width:" + vlen + "px");

        //                    voiceIndex++;
        //                }
        //                break;
        //            default:
        //                break;
        //        }
        //        liHtml += "<li>" + liItem + "</li>";
        //    }

        //    liHtml = liHtml.Replace("&lt;", "<").Replace("&gt;", ">");
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
            <div style="display:flex; text-align:center; margin:0 40px; height:55px;" id="input_text">
                <textarea id="textContent" placeholder="请输入内容..." style=" display:inline-block; padding:0px 5px; margin-top:5px; width:auto; height:44px; line-height:22px; font-size:14px;"></textarea>　
                <input type="button" value="发送" style="width:50px; height:25px; margin-top:17px;" onclick="inputText();" />
            </div>
        </div>
    </div>
    <script type="text/javascript">
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


        function changeBlock() {
            if ($('#openblock').css("display") == "none") {
                $('#openblock').show();
                $('#bottomDiv').css('height', '130px');
            }
            else {
                $('#openblock').hide();
                $('#bottomDiv').css('height', '60px');
            }
        }

        
    </script>
</asp:Content>

