<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    public string token = "";
    public string roomid = "0";
    public int userid = 0;    
    public string domainName = System.Configuration.ConfigurationManager.AppSettings["domain_name"].ToString();
    public int feedId = 0;
    public string expertlist = "";
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
        expertlist = drow["expertlist"].ToString();
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="mydiv"  class="main-page" style="overflow-y:scroll; -webkit-overflow-scrolling: touch;">
        <div>
            <ul id="feed_file_list" class="feed_file_list">
                
            </ul>
        </div>
        <div id="bottomDiv" style="height:0px; clear:both;"></div>
    </div>
    <div style="position:fixed; bottom:0; left:0; width:100%; background:#fff; border-top:1px solid #ccc; text-align:center; line-height:55px; z-index:100;">
        <a id="switchInput" onclick="changeInput();" style="position:absolute; top:2px; left:5px; line-height:45px; "><img src="images/af9.png" width="30px" /></a>
        <div id="input_text" style="display:none; margin:0 50px;">
            <div style="width:auto; float:left;" ><div id="textContent" contenteditable="true" style="text-align:left; margin:10px 0 13px; background:#fff; border: 2px solid #CACACA; border-radius: 15px; width: 100%; line-height: 27px; padding: 0px 5px;"></div></div>
            <%--<input id="textContent" type="text" style="border:2px solid #CACACA; border-radius:5px; width:100%; height:30px; line-height:30px; padding:2px 5px;"  />--%>
            <div style="width:90px; float:right;"><input type="button" class="btn-feed-send" onclick="inputText(0, 'fillList_QA');" /></div>
        </div>
        <div id="input_voice" style=" margin:0 50px;">
            <div style="width:100%; float:left; text-align:center;">
                <input type="button" value="点击说话" id="startRecord" style="width:100%; height:40px; line-height:40px; display:block; margin:7px 0;" /></div>
            <div style="width:100%; float:left; text-align:center;">
                <input type="button" value="停止说话" id="stopRecord" style="width:100%; height:40px; line-height:40px; display:none; margin:7px 0" /></div>
        </div>
        <div style="position:absolute; top:2px; right:5px; line-height:50px;">
            <a onclick="changeBlock();"><img src="images/a6b.png" width="30px" /></a>
        </div>
        <div id="openblock" style="margin-top:60px; display:none; text-align:center; padding-bottom:10px;">
            <a id="uploadImg" style="display:block; width:55px; height:55px; border:1px solid #ccc; margin:0 auto; border-radius:3px;">
                <img src="images/pi.9.png" style="width:45px; height:45px; margin:5px;" /></a>
        </div>
    </div>
    <script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript">
        var feedid = '0';
        var userid = '<%=userid %>';
        var token = '<%=token %>';
        var roomid = '<%=roomid %>';
        var voiceIndex = '1';
        var domainName = '<%=domainName %>';
        var expertlist = '<%=expertlist %>';
        var expertArr = expertlist.split(',');
        var maxdt = '';
        var callback = 'fillList_QA';
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
            $("#textContent").parent().css("width", (winWidth - 200).toString() + "px");
            $('#mydiv').css("height", ($(window).height() - 60).toString() + "px");
            fillList_QA();
            setInterval("fillList_QA()", 5000);
            setDots();
            scrollPageBottom();
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
                            if (chatline.answerlist.length <= 0) {
                                expertlicss = 'class = "expert-li"';
                            }
                            else
                                expertlicss = '';
                            inHtml = "<li id=\"li_" + chatline.id.toString() + "\" " + expertlicss + ">" + liItem.replace("&lt;", "<").replace("&gt;", ">") + "</li>";
                            if ($('.feed_file_list li').length == 0)
                                $('.feed_file_list').html(inHtml);
                            else
                                after_append(inHtml);
                                //$('.feed_file_list li:last').after(inHtml);

                            if (chatline.answerlist.length > 0) {
                                var answerlist = "";
                                for (var j = 0; j < chatline.answerlist.length; j++) {
                                    var answerchat = chatline.answerlist[j];
                                    var answerItem = fomatLi(answerchat);
                                    answerlist = "<li>" + answerItem.replace("&lt;", "<").replace("&gt;", ">") + "</li>";
                                    after_append(answerlist);
                                }
                                answerlist = '<li class = "spacing-li"></li>';
                                after_append(answerlist);
                            }

                            if (i != 0 && i % 5 == 0)
                                after_append('<li class="time-li">' + strTohoursecond(chatline.create_date) + '</li>');
                                //$('.feed_file_list li:last').after('<li class="time-li">' + strTohoursecond(chatline.create_date) + '</li>');
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
    <script src="wxRecord.js"></script>
</asp:Content>

