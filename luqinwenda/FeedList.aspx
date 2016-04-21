<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    public string token = "";
    public string roomid = "0";
    public int userid = 0;
    public string domainName = System.Configuration.ConfigurationManager.AppSettings["domain_name"].ToString();
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
        if (Array.IndexOf(drow["expertlist"].ToString().Split(','), userid.ToString()) < 0)
        {
            Response.Write("你不是专家");
            Response.End();
        }

    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="mydiv" class="main-page">
        <ul id="feed_file_list" class="feed_file_list">
            
        </ul>
        <div style="clear: both; height: 10px;"></div>
    </div>
    <script type="text/javascript">
        var textLeft = "<div class=\"text-li\"><div class=\"left-head\"><img src=\"{0}\" /></div>"
                + "<div class=\"right-content\"><div class=\"text-nick\">{1}</div>"
                + "<div class=\"text-content{5}\" onclick=\"enterFeed({4});\">{2}</div>"
                + "<div class=\"text_jiantou\"><img src=\"images/jt_icon_left.png\" /></div></div>"
                + "<div class=\"clear\"></div><div class=\"text-time\">{3}</div></div>";
        var textRight = "<div class=\"text-li-right\"><div class=\"left-head\"><img src=\"{0}\" /></div>"
            + "<div class=\"right-content\"><div class=\"text-content\">{1}</div>"
            + "<div class=\"text_jiantou\"><img src=\"images/jt_icon_right.png\" /></div></div>"
            + "<div class=\"clear\"></div><div class=\"text-time\">{2}</div></div>"
            + "<div class=\"clear\"></div>";
        var voiceLeft = "<div class=\"text-li\"><div class=\"left-head\"><img src=\"{0}\" /></div>"
            + "<div class=\"right-content\"><div class=\"text-nick\">{1}</div>"
            + "<div class=\"text-content_radio\"><div id=\"jquery_jplayer_{3}\" class=\"jp-jplayer\"></div>"
            + "<div style=\"background:url(images/jplayerleft.png); width: 6px; height: 30px; top:29px; position: absolute;\"></div>"
            + "<div id=\"jp_container_{3}\" class=\"jp-audio\" role=\"application\" aria-label=\"media player\" onclick='changePlay(\"{3}\");' style=\"float:left;{6}\">"
            + "<a id=\"a_jp_play_{3}\" class=\"jp-play\" role=\"button\" tabindex=\"0\"><span class=\"jplay_play\"></span></a>"
            + "<a id=\"a_jp_stop_{3}\" class=\"jp-stop\" style=\"display: none;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_stop\"></span></a>"
            + "<div class=\"jp-duration\" role=\"timer\" aria-label=\"duration\" style=\"display: none;\"></div></div>"
            + "<div style=\"float:left; line-height:36px; margin-left:8px;\">{5}”</div>"
            + "<div id=\"dot_{3}\" class=\"dots\"><img src=\"images/dots.png\"></div>"
            + "<div style=\"clear:both;\"></div><script type=\"text/javascript\">$(\"#jquery_jplayer_{3}\").jPlayer({ready: function () {$(this).jPlayer(\"setMedia\", {mp3: \"{2}\"});},play: function () {$(this).jPlayer(\"stopOthers\");},ended: function () {$(\"#jp_container_{3}\").click();$(\"#jquery_jplayer_{4}\").jPlayer(\"play\");$(\"#jp_container_{4}\").click();},swfPath: \"__THEME__/js\",supplied: \"mp3\",cssSelectorAncestor: \"#jp_container_{3}\",wmode: \"window\",globalVolume: true,useStateClassSkin: true,autoBlur: false,smoothPlayBar: true,keyEnabled: true});&lt;/script&gt;</div></div><div class=\"clear\"></div></div>";
        var voiceRight = "<div class=\"text-li-right\"><div class=\"left-head\"><img src=\"{0}\" /></div><div class=\"right-content\"><div id=\"jquery_jplayer_{2}\" class=\"jp-jplayer\"></div><div id=\"dot_{2}\" class=\"dots\"><img src=\"images/dots.png\"></div><div style=\"float:left; line-height:40px; margin-top: 5px;\">{4}”</div><div id=\"jp_container_{2}\" class=\"jp-audio\" role=\"application\" aria-label=\"media player\" onclick='changePlay(\"{2}\",\"R\");' style=\"float:left; margin-top:5px; {5}\"><a id=\"a_jp_play_{2}\" class=\"jp-play\" style=\"display:block;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_play_right\"></span></a><a id=\"a_jp_stop_{2}\" class=\"jp-stop\" style=\"display: none;\" role=\"button\" tabindex=\"0\"><span class=\"jplay_stop_right jp-stop_right_3\"></span></a><div class=\"jp-duration\" role=\"timer\" aria-label=\"duration\" style=\"display: none;\"></div></div><div class=\"jt_right\"></div><div style=\"clear:both;\"></div><script type=\"text/javascript\">$(\"#jquery_jplayer_{2}\").jPlayer({ready: function () {$(this).jPlayer(\"setMedia\", {wav: \"{1}\"});},play: function () {$(this).jPlayer(\"stopOthers\");},ended: function () {$(\"#jp_container_{2}\").click();$(\"#jquery_jplayer_{3}\").jPlayer(\"play\");$(\"#jp_container_{3}\").click();},swfPath: \"__THEME__/js\",supplied: \"wav\",cssSelectorAncestor: \"#jp_container_{2}\",wmode: \"window\",globalVolume: true,useStateClassSkin: true,autoBlur: false,smoothPlayBar: true,keyEnabled: true});&lt;/script&gt;</div></div><div class=\"clear\"></div>";
        var maxid = '';
        var roomid = '<%=roomid %>';
        var domainName = '<%=domainName %>';
        var token = '<%=token %>';
        var parentid = 0;
        var voiceIndex = '1';
        $(document).ready(function () {
            fillFeedList(1);
            fillFeedList(0);

            //var movepx = $('#mydiv').css('height').replace("px", "");
            //$wd = $(window);
            //$wd.scrollTop($wd.scrollTop() + parseInt(movepx));

            //var wh = document.body.clientWidth;
            //$("#textContent").css("width", (wh - 180).toString() + "px");

            //setDots();

            setInterval("fillFeedList(0)", 5000);
        });

        function fillFeedList(state) {
            //alert(state);
            $.ajax({
                type: "GET",
                async: false,
                url: "http://" + domainName + "/api/chat_timeline_list.aspx",
                data: { roomid: roomid, token: token, maxid: maxid, parentid: parentid, state: state },
                dataType: "json",
                success: function (data) {
                    var inHtml = '';
                    if (data.status == 0 && data.count > 0) {
                        var expertlicss = "";
                        if (state == 0) {
                            maxid = data.max_id;
                            expertlicss = 'class = "expert-li"';
                        }
                        for (var i = 0; i < data.chat_time_line.length; i++) {
                            inHtml = "";
                            var liItem = '';
                            var chatline = data.chat_time_line[i];
                            switch (chatline.message_type) {
                                case "text":
                                    {
                                        var state_css = "";
                                        if (chatline.state > 0)
                                            state_css = " text-content_readed";
                                        liItem = String.format(textLeft, chatline.avatar, chatline.nick, chatline.message_content, strTohoursecond(chatline.create_date), chatline.id, state_css);
                                    }
                                    break;
                                default:
                            }
                            
                            inHtml += "<li " + expertlicss + ">" + liItem.replace("&lt;", "<").replace("&gt;", ">") + "</li>";
                            if ($('.feed_file_list li').length == 0)
                                $('.feed_file_list').html(inHtml);
                            else
                                $('.feed_file_list li:first').before(inHtml);
                        }
                    }
                }
            });
        }


        function enterFeed(feedid) {
            location.href = "Feed.aspx?roomid=" + roomid + "&feedid=" + feedid + "&token=" + token;
        }
    </script>
</asp:Content>

