<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    public string token = "";
    public string roomid = "0";
    public ArrayList chatList = new ArrayList();
    public int userid = 0;
    public string liHtml = "";
    public string domainName = System.Configuration.ConfigurationManager.AppSettings["domain_name"].ToString();
    public string canText = "0";
    public string canVoice = "0";
    public string expertlist = "";
    public DataTable dt_userinfo;
    protected void Page_Load(object sender, EventArgs e)
    {
        roomid = Util.GetSafeRequestValue(Request, "roomid", "0");
        if (int.Parse(roomid) <= 0)
        {
            Response.Write("参数错误");
            Response.End();
            return;
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

        ChatRoom chatRoom = new ChatRoom(int.Parse(roomid));
        DataRow drow = chatRoom._fields;
        if (drow == null)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
        expertlist = drow["expertlist"].ToString();

        if (Convert.ToDateTime(drow["start_date"].ToString()) > DateTime.Now)
        {
            Response.Redirect("nostart.aspx?roomid=" + roomid);
            return;
        }

        UserChatRoomRights userChatRoom = new UserChatRoomRights(userid, int.Parse(roomid));
        if (!userChatRoom.CanEnter || !userChatRoom.CanPublishText)
        {
            Response.Redirect("wktConfirm.aspx?roomid=" + roomid);
            return;
        }

    }
    
    
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="main-header" style="">
        <div class="header-loginuser">
        </div>
        <div class="header-total">当前人数<br /><span id="personCount">238</span></div>
        <div class="header-userlist">
            <a style="background:url(http://wx.qlogo.cn/mmopen/M13tqMABLia0mbuQSR36GgqxLRqK0ExSLIj8cEVy2pMQYR7xVwxAg5Is6Y3SiaHP03iciaQZJW1PicHhC4122Va5DSw/0) no-repeat; background-size:40px;"></a>
            <a style="background:url(http://wx.qlogo.cn/mmopen/M13tqMABLia0mbuQSR36GgqxLRqK0ExSLIj8cEVy2pMQYR7xVwxAg5Is6Y3SiaHP03iciaQZJW1PicHhC4122Va5DSw/0) no-repeat; background-size:40px;"></a>
        </div>
        <div style="clear:both;"></div>
    </div>
    <div id="mydiv" class="main-page" style="margin-top:60px;">
        <div>
            <ul id="feed_file_list" class="feed_file_list">
                <div style="clear: both;"></div>
            </ul>
        </div>
        <div id="bottomDiv" style="height: 40px; clear: both;"></div>
        <%--<div style="position: fixed; bottom: 45px; left: 0; width: 100%; text-align: center; line-height: 55px; z-index: 100;">
            <div id="input_text" style="width: auto; margin: 0 15px; background: #fff; ">
                <div style="width: auto; float: left; margin-left: 10px;">
                    <input id="textContent" type="text" style="border: 2px solid #CACACA; border-radius: 5px; width: 100%; height: 30px; line-height: 30px; padding: 2px 5px;" /></div>
                <div style="width: 90px; float: right;">
                    <input type="button" class="btn-feed-send" onclick="inputText(0);" /></div>
                <div style="clear: both;"></div>
            </div>
        </div>--%>
        <div style="position: fixed; bottom: 0; left: 0; width: 100%; background: #71b4ff; text-align: center; line-height: 45px; z-index: 100; color: #fff; font-weight: bold; font-size: 12pt; letter-spacing: 0.05em;">
            <div style="float: left; width: 50%; text-align: center; background: #0259bb;">全部问题</div>
            <div style="float: right; width: 50%; text-align: center;" onclick="Redirect(0);">我的问题</div>
        </div>
    </div>
    <script type="text/javascript">
        var userid = '<%=userid %>';
        var token = '<%=token %>';
        var roomid = '<%=roomid %>';
        var voiceIndex = '1';
        var maxdt = '';
        var domainName = '<%=domainName %>';
        var expertlist = '<%=expertlist %>';
        var expertArr = expertlist.split(',');
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

        $(document).ready(function () {
            $("#textContent").parent().css("width", (winWidth- 150).toString() + "px");
            fillHeader();
            fillList_QA();
            scrollPageBottom();
            setInterval("fillList_QA()", 5000);
            setDots();
        });

        function fillList_QA() {
            $.ajax({
                type: "GET",
                async: false,
                url: "http://" + domainName + "/api/chat_timeline_qa_list.aspx",
                data: { roomid: roomid, token: token, maxdt: maxdt },
                dataType: "json",
                success: function (data) {
                    var inHtml = '';
                    if (data.status == 0 && data.count > 0) {
                        maxdt = data.maxdt;
                        for (var i = 0; i < data.chat_time_line.length; i++) {
                            inHtml = "";
                            var chatline = data.chat_time_line[i];
                            var liItem = fomatLi(chatline);
                            var expertlicss = "";
                            if ($.inArray(chatline.user_id.toString(), expertArr) >= 0)
                            {
                                expertlicss = 'class = "expert-li"';
                            }
                            inHtml = "<li " + expertlicss + ">" + liItem.replace("&lt;", "<").replace("&gt;", ">") + "</li>";
                            if ($('.feed_file_list li').length == 0)
                                $('.feed_file_list').html(inHtml);
                            else
                                $('.feed_file_list li:last').after(inHtml);

                            if (chatline.answerlist.length > 0) {
                                var answerlist = "";
                                for (var j = 0; j < chatline.answerlist.length; j++) {
                                    var answerchat = chatline.answerlist[j];
                                    var answerItem = fomatLi(answerchat);
                                    answerlist += "<li>" + answerItem.replace("&lt;", "<").replace("&gt;", ">") + "</li>";
                                }
                                answerlist += '<li class = "spacing-li"></li>';
                                $('.feed_file_list li:last').after(answerlist);
                            }

                            if (i % 5 == 0)
                                $('.feed_file_list li:last').after('<li class="time-li">' + strTohoursecond(chatline.create_date) + '</li>');
                        }
                    }
                }
            });
        }

    </script>
</asp:Content>

