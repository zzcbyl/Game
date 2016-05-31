﻿<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    public string token = "e90477e2f0993c8cea841471d157caad237cfd776919dc0b28c5b51ee601b782f51f69fc";
    public string roomid = "0";
    public ArrayList chatList = new ArrayList();
    public int userid = 0;
    public string liHtml = "";
    public string domainName = System.Configuration.ConfigurationManager.AppSettings["domain_name"].ToString();
    public string canText = "0";
    public string canVoice = "0";
    public string expertlist = "";
    public DataTable dt_userinfo;
    public DataRow chatDrow = null;
    //public DataTable courseDt = new DataTable();
    public Random ran = new Random();
    public string audioUrl = "";
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
        chatDrow = chatRoom._fields;
        if (chatDrow == null)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }

        audioUrl = chatDrow["audio_url"].ToString();
        if (audioUrl.IndexOf(Util.DomainName) >= 0)
        {
            audioUrl += "?rdm=" + ran.Next(1, 99999);
        }

        UserChatRoomRights.SetUserChatRoom(userid, int.Parse(roomid));
        
        //expertlist = chatDrow["expertlist"].ToString();

        //if (Convert.ToDateTime(chatDrow["start_date"].ToString()) > DateTime.Now)
        //{
        //    Response.Redirect("nostart.aspx?roomid=" + roomid + "&token=" + token);
        //    return;
        //}

        //int courseid = -1;
        //if (chatDrow["courseid"].ToString().Trim() != "0")
        //    courseid = int.Parse(chatDrow["courseid"].ToString());
        //DataTable CourseDt = Donate.getCourse(courseid);
        //if (CourseDt != null && CourseDt.Rows.Count > 0)
        //{
        //    courseDt = CourseDt;
        //}
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="../script/jquery.qqFace.js"></script>
    <style type="text/css">
        span.emotion{width:42px; height:25px; background:url(face/face_icon.png) no-repeat; background-size:25px 25px; padding-left:20px; cursor:pointer; display:inline-block; margin:12px 0 0 8px;}
        #facebox { background:#fff;}
        #facebox table td { height:25px; line-height:25px;}
        .qqFace {margin-top:4px;background:#fff;padding:2px;border:1px #dfe6f6 solid;}
        .qqFace ul { width:100%; }
        .qqFace li { float:left; height:25px; line-height:25px; margin:2px; }
        #textContent img { margin-top:-3px; width:auto;}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="main-header" style="">
        <div style="height:210px; text-align:center; background:#EBE8E1; ">
            <%--<img src="<%=chatDrow["audio_bg"].ToString() %>" style="width:100%; height:170px;" />--%>
            <video src="<%=audioUrl %>" 
                poster="<%=chatDrow["audio_bg"].ToString() %>" autoplay="autoplay" controls="controls"
                 x-webkit-airplay="true" webkit-playsinline="true" style="height:210px;" webkit-playsinline></video>
            <%--<div style="display:none;"><audio id="audio_1" controls="controls" autoplay="autoplay" src="<%=audioUrl %>"></audio></div>--%>
        </div>
        
    </div>
    <div id="mydiv" class="main-page" style="margin-top:220px; overflow-y:scroll; -webkit-overflow-scrolling: touch;">
        <div>
            <ul id="feed_file_list" class="feed_file_list">
                <div style="clear: both;"></div>
            </ul>
        </div>
        <div id="bottomDiv" style="height: 1px; clear: both;"></div>
        
        <%--<div style="position: fixed; bottom: 45px; left: 0; width: 100%; text-align: center; line-height: 55px; z-index: 100;">
            <div id="input_text" style="width: auto; margin: 0 15px; background: #fff; ">
                <div style="width: auto; float: left; margin-left: 10px;">
                    <input id="textContent" type="text" style="border: 2px solid #CACACA; border-radius: 5px; width: 100%; height: 30px; line-height: 30px; padding: 2px 5px;" /></div>
                <div style="width: 90px; float: right;">
                    <input type="button" class="btn-feed-send" onclick="inputText(0);" /></div>
                <div style="clear: both;"></div>
            </div>
        </div>--%>
    </div>
    <div style="position: fixed; bottom: 0px; left: 0; width: 100%; text-align: center; line-height: 55px; z-index: 100;">
        <div id="input_text" style="width: auto; margin: 0; background: #ebe9e1; ">
            <div style="width: auto; float: left; margin-left: 10px;">
                <%--<input id="textContent" type="text" style="border: 2px solid #CACACA; border-radius: 15px; width: 100%; height: 30px; line-height: 30px; padding: 2px 5px;" />--%>
                <div id="textContent" contenteditable="true" style="text-align:left; margin-top:10px; background:#fff; border: 2px solid #CACACA; border-radius: 15px; width: 100%; line-height: 27px; padding: 0px 5px;"></div>
            </div>
            <div style="width: 30px; float: left; height:50px;"><span class="emotion"></span></div>
            <div style="width: 70px; float: right;">
                <input type="button" class="btn-feed-send" onclick="inputText(0, 'fillList_QA');" /></div>
            <div style="clear: both;"></div>
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
        var audio;
        var chat_shareContent = '<%=chatDrow["shareContent"].ToString() %>';
        var chat_shareImage = '<%=chatDrow["shareimage"].ToString() %>';
        $(document).ready(function () {
            shareTitle = '【卢勤微课教室】';
            if (chat_shareContent != '')
                shareContent = chat_shareContent;
            if (chat_shareImage != '')
                shareImg = chat_shareImage;

            $('.emotion').qqFace({
                id: 'facebox', //表情盒子的ID
                assign: 'textContent', //给那个控件赋值
                path: 'face/'	//表情存放的路径
            });

            $(".sub_btn").click(function () {
                var str = $("#saytext").val();
                $("#show").html(replace_em(str));
            });

            //audio = document.getElementById('audio_1');
            //playCotrol();
            $("#textContent").parent().css("width", (winWidth- 120).toString() + "px");
            
            $('#mydiv').css("height", ($(window).height() - 275).toString() + "px");
            

            fillList_QA();
            setInterval("fillList_QA()", 5000);
            setDots();
        });



        function playCotrol() {
            audio.addEventListener("loadeddata", //歌曲一经完整的加载完毕( 也可以写成上面提到的那些事件类型)
                function () {
                    $('#audio_loading').hide();
                    $('#btn_audio_control').show();
                    audio.play();
                    $('#audio_loading').parent().bind('click', function () {
                        if (audio.paused) {
                            audio.play();
                        }
                        else {
                            audio.pause();
                        }
                    });
                }, false);

            audio.addEventListener("pause",
                function () { //监听暂停
                    $('#btn_audio_control').attr('src', 'images/wkt_play.png');
                }, false);
            audio.addEventListener("play",
                function () { //监听暂停
                    $('#btn_audio_control').attr('src', 'images/wkt_paused.png');
                }, false);
            audio.addEventListener("ended", function () {
                
            }, false)
        }

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
                            //if ($.inArray(chatline.user_id.toString(), expertArr) < 0)
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
                        }
                    }

                    $.ajax({
                        type: "GET",
                        async: false,
                        url: "http://" + domainName + "/api/chat_timeline_deleted_list.aspx",
                        data: { roomid: roomid, token: token },
                        dataType: "json",
                        success: function (data) {
                            if (data.status == 0 && data.count > 0) {
                                for (var i = 0; i < data.chat_time_line.length; i++) {
                                    $('#li_' + data.chat_time_line[i].id).remove();
                                }
                            }
                        }
                    });
                    scrollPageBottom();
                }
            });

        }

    </script>
</asp:Content>
