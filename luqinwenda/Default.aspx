<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
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
    public DataTable courseDt = new DataTable();
    public Random ran = new Random();
    public string audioUrl = "";

    public DateTime chatStartDate;
    public DateTime chatEndDate;
    
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
        chatStartDate = DateTime.Parse(chatDrow["start_date"].ToString());
        chatEndDate = DateTime.Parse(chatDrow["end_date"].ToString());
            
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
        
        expertlist = chatDrow["expertlist"].ToString();

        if (Convert.ToDateTime(chatDrow["start_date"].ToString()) > DateTime.Now)
        {
            Response.Redirect("nostart.aspx?roomid=" + roomid + "&token=" + token);
            return;
        }

        UserChatRoomRights userChatRoom = new UserChatRoomRights(userid, int.Parse(roomid));
        if (!userChatRoom.CanEnter && Request["canfree"] == null )
        {
            Response.Redirect("wktPay.aspx?roomid=" + roomid + "&token=" + token);
            return;
        }

        int courseid = -1;
        if (chatDrow["courseid"].ToString().Trim() != "0")
            courseid = int.Parse(chatDrow["courseid"].ToString());
        DataTable CourseDt = Donate.getCourse(courseid);
        if (CourseDt != null && CourseDt.Rows.Count > 0)
        {
            courseDt = CourseDt;
        }
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
        <div style="height:170px; text-align:center; background:#EBE8E1; ">
            <img src="<%=chatDrow["audio_bg"].ToString() %>" style="width:100%; height:170px;" />
            <div style="display:none;">
                <audio id="audio_1" controls="controls">
                    <source src="<%=audioUrl %>" type="audio/mp3" />
                </audio></div>
        </div>
        <div style="height:60px; position:relative; background:url(/luqinwenda/images/wkt_bottom_bg.jpg) no-repeat; background-size:100% 60px; background-position-y:center;">
            <% if (DateTime.Now > chatEndDate.AddMinutes(10)) { %>
                <div style="margin:0; display:none;" id="btn_audio_control">
                    <a style="display:inline-block; width:18%; margin-top:8px; text-align:center;" id="audio_control">
                        <img id="btn_audio_icon" src="images/wkt_paused1.png" style="height:35px;" /></a>
                    <div style="width:50%; display:inline-block; position:relative;">
                        <a id="progress_block" style="display:block; height:10px; border:2px solid #74705f; background:#bab49a; border-radius:5px; width:100%;"></a>
                        <a id="progress_bg" style="position:absolute; height:8px; border:1px solid #74705f;  display:block; top:1px; left:1px; width:1px; background:url(images/wkt_progress_bg.jpg) repeat-x; border-radius:5px; "></a>
                        <a id="progress_icon" style="display:block; width:20px; height:20px; background:url(images/wkt_audio_icon.png) no-repeat; background-size:contain; position:absolute; top:-5px; left:-10px;"></a>

                    </div>
                    <a style="display:inline-block; width:25%; margin-left:3%; color:#000;" id="audio_time"></a>
                </div>    
            <% } else { %>
                <div style="display:none;" id="btn_audio_control">
                    <a id="audio_control" style="position:absolute; top:-15px; display:inline-block; width:100%; text-align:center;"><img id="btn_audio_icon" src="images/wkt_play.gif" style="height:60px;" /></a>
                </div>
            <% } %>
            <a id="audio_loading" style="display:inline-block; width:100%; text-align:center; top:5px; position:absolute;"><img src="/upload/images/loading.gif" style="width:40px; height:40px;" /></a>
        </div>
    </div>
    <div id="mydiv" class="main-page" style="margin-top:225px; overflow-y:scroll; -webkit-overflow-scrolling: touch;">
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
                <div id="textContent" contenteditable="true" style="text-align:left; margin-top:10px; background:#fff; border: 2px solid #CACACA; border-radius: 15px; width: 100%; line-height: 27px; min-height: 27px; padding: 0px 5px;"></div>
            </div>
            <div style="width: 30px; float: left; height:50px;"><span class="emotion"></span></div>
            <div style="width: 70px; float: right;">
                <input type="button" class="btn-feed-send" onclick="inputText(0, 'fillList_QA');" /></div>
            <div style="clear: both;"></div>
        </div>
    </div>
    <div id="divHidden" style="display:none;"></div>
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
        var audioUrl = '<%=audioUrl %>';
        var chat_shareContent = '<%=chatDrow["shareContent"].ToString() %>';
        var chat_shareImage = '<%=chatDrow["shareimage"].ToString() %>';
        $(document).ready(function () {
            if (!navigator.userAgent.match(/(iPhone|iPod|Android|ios|iPad)/i)) {
                location.href = 'error404.aspx';
            }
            uploadLog();
            shareTitle = '【卢勤微课教室】<%=(courseDt.Rows.Count > 0 ? courseDt.Rows[0]["course_title"].ToString() : "") %>';
            if (chat_shareContent != '')
                shareContent = chat_shareContent;
            if (chat_shareImage != '')
                shareImg = chat_shareImage;

            $('.emotion').qqFace({
                id: 'facebox', //表情盒子的ID
                assign: 'textContent', //给那个控件赋值
                path: 'face/'	//表情存放的路径
            });

            audio = document.getElementById('audio_1');
            playCotrol();

            $("#textContent").parent().css("width", (winWidth- 120).toString() + "px");
            $('#mydiv').css("height", ($(window).height() - 260).toString() + "px");

            fillList_QA(1);
            setInterval("fillList_QA(0)", 5000);
            setDots();
        });

        function playCotrol() {
            var updInterval;
            
            $('#audio_loading').hide();
            $('#btn_audio_control').show();
            $('#audio_control').click(function () {
                if (audio.paused) {
                    audio.play();
                    addLog('play');
                }
                else {
                    audio.pause();
                    addLog('pause');
                }

                if ($('#progress_bg').html() != null) {
                    updInterval = setInterval(function () {
                        _updateProgress();
                        $('#audio_time').html(timeChange(audio.currentTime) + "/" + timeChange(audio.duration));
                    }, 1000);
                }
            });

            audio.addEventListener("loadeddata",
                function () {
                    addListenTouch();
                    addLog('loadeddata');
                }, false);

            audio.addEventListener("pause",
                function () { //监听暂停
                    addLog('pause');
                    if ($('#progress_bg').html() != null)
                        $('#btn_audio_icon').attr('src', 'images/wkt_paused1.png');
                    else
                        $('#btn_audio_icon').attr('src', 'images/wkt_play.gif');
                }, false);
            audio.addEventListener("play",
                function () { //监听播放
                    addLog('play');
                    if ($('#progress_bg').html() != null)
                        $('#btn_audio_icon').attr('src', 'images/wkt_played.png');
                    else
                        $('#btn_audio_icon').attr('src', 'images/wkt_paused.png');
                }, false);
            audio.addEventListener("ended", function () {
                addLog('ended');
                if ($('#progress_bg').html() != null)
                    $('#btn_audio_icon').attr('src', 'images/wkt_paused1.png');
                else
                    $('#btn_audio_icon').attr('src', 'images/wkt_play.gif');
                if (updInterval)
                    clearInterval(updInterval);
            }, false);

            audio.addEventListener("canplay", function () {
                addLog('canplay');
            }, false);
            audio.addEventListener("emptied", function () {
                addLog('emptied');
            }, false);
            audio.addEventListener("error", function () {
                addLog('error' + audio.error.code);
            }, false);
            audio.addEventListener("loadstart", function () {
                addLog('loadstart');
            }, false);
            //audio.addEventListener("progress", function () {
            //    addLog('progress');
            //}, false);
            audio.addEventListener("readystatechange", function () {
                addLog('readystatechange');
            }, false);
            audio.addEventListener("stalled", function () {
                addLog('stalled');
            }, false);
            //audio.addEventListener("suspend", function () {
            //    addLog('suspend');
            //}, false);
            //audio.addEventListener("timeupdate", function () {
            //    addLog('timeupdate');
            //}, false);
        }
        var storage = window.localStorage;
        function addLog(state)
        {   
            storage.setItem("logstr", (storage.getItem("logstr") != null ? storage.getItem("logstr") : "") + new Date().toString() + "：" + state + " | ");
            uploadLog()
        }
        
        function uploadLog()
        {
            if (!navigator.userAgent.match(/(iPhone|iPod|Android|ios|iPad)/i)) {
                return;
            }
            if(storage.getItem("logtime") != null && parseInt(storage.getItem("logtime")) > 0)
            {
                if(parseInt(storage.getItem("logtime")) < new Date(
                    new Date().getFullYear(), new Date().getMonth(), new Date().getDate(),
                    new Date().getHours(), new Date().getMinutes()-10, new Date().getSeconds()).getTime())
                {
                    //上传
                    if(storage.getItem("logstr") != null && storage.getItem("logstr").toString().Trim() != '')
                    {
                        $.ajax({
                            type: "POST",
                            url: "recordUserAgent.ashx",
                            data: { userid: '<%=userid %>', roomid: '<%=roomid %>', useragent: navigator.userAgent.toString(), 
                                audiolog: storage.getItem("logstr") },
                            success: function (data) {
                            
                            }
                        });
                    }
                    storage.removeItem("logtime");
                    storage.removeItem("logstr");
                }
            }
            else
            {
                storage.setItem("logtime", new Date().getTime().toString());
            }
        }

        function _updateProgress() {
            var duraTime = audio.duration;
            var curTime = audio.currentTime;
            var scale = curTime / duraTime;
            var progressW = $('#progress_icon').parent().width();
            if ((progressW * scale) < progressW)
                progressW = progressW * scale;
            $('#progress_bg').css('width', (progressW).toString() + 'px');
            $('#progress_icon').css('left', (progressW - 10).toString() + 'px');
        }

        function timeChange(time) {//默认获取的时间是时间戳改成我们常见的时间格式
            //分钟
            var minute = time / 60;
            var minutes = parseInt(minute);
            if (minutes < 10) {
                minutes = "0" + minutes;
            }
            //秒
            var second = time % 60;
            seconds = parseInt(second);
            if (seconds < 10) {
                seconds = "0" + seconds;
            }
            return "" + minutes + "" + ":" + "" + seconds + "";
        }

        var startX, x, aboveX = 0; //触摸时的坐标 //滑动的距离  //设一个全局变量记录上一次内部块滑动的位置 

        //1拖动监听touch事件
        function addListenTouch() {
            if (document.getElementById("progress_icon")) {
                document.getElementById("progress_icon").addEventListener("touchstart", touchStart, false);
                document.getElementById("progress_icon").addEventListener("touchmove", touchMove, false);
                document.getElementById("progress_icon").addEventListener("touchend", touchEnd, false);
            }
        }
        //touchstart,touchmove,touchend事件函数
        function touchStart(e) {
            e.preventDefault();
            var touch = e.touches[0];
            startX = touch.pageX;
        }
        function touchMove(e) { //滑动          
            e.preventDefault();
            var touch = e.touches[0];
            x = touch.pageX - startX; //滑动的距离
            var moveX = aboveX + x;
            if ((aboveX + x) > $('#progress_icon').parent().width())
                moveX = $('#progress_icon').parent().width();
            $('#progress_bg').css('width', (moveX).toString() + 'px');
            $('#progress_icon').css('left', (moveX - 10).toString() + 'px');
        }
        function touchEnd(e) { //手指离开屏幕
            e.preventDefault();
            aboveX = parseInt($('#progress_icon').css('left').replace('px', ''));
            var touch = e.touches[0];
            var dragPaddingLeft = $('#progress_icon').css('left').replace('px', '');
            var change = dragPaddingLeft.replace("px", "");
            var cTime = (parseInt(change) / $('#progress_icon').parent().width()) * audio.duration;//30是拖动圆圈的长度，减掉是为了让歌曲结束的时候不会跑到window以外
            audio.currentTime = cTime;
        }

        function fillList_QA(o) {
            $.ajax({
                type: "GET",
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
                                if (!o) {
                                    setTimeout(function () {
                                        fillAnswer(chatline);
                                    }, 6000);
                                }
                                else {
                                    fillAnswer(chatline);
                                }
                            }

                            if (i != 0 && i % 5 == 0)
                                after_append('<li class="time-li">' + strTohoursecond(chatline.create_date) + '</li>');
                        }
                        if (o == 0)
                            scrollPage();
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

                    if (0 == 1)
                        scrollPageBottom();
                }
            });

        }

        function fillAnswer(chatline) {
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

        //function recordUserAgent(uid, roomid) {
        //    if (!navigator.userAgent.match(/(iPhone|iPod|Android|ios|iPad)/i)) {
        //        return;
        //    }
        //    if (getCookie('userAgent') != null)
        //        return;
        //    $.ajax({
        //        type: "POST",
        //        url: "recordUserAgent.ashx",
        //        data: { userid: uid, roomid: roomid, useragent: navigator.userAgent.toString() },
        //        success: function (data) {
        //            setCookie('userAgent', '1', 60 * 5);
        //        }
        //    });
        //}

        
        if (audioUrl.indexOf("Manifest") == -1 && new Date().getTime() < new Date(<%=chatEndDate.Year.ToString()%>, <%=(chatEndDate.Month-1).ToString() %>, 
            <%=chatEndDate.Day.ToString() %>, <%=chatEndDate.Hour.ToString()%>, <% =chatEndDate.Minute.ToString()%>, 
            <%=chatEndDate.Second.ToString() %>, <%=chatEndDate.Millisecond.ToString()%>).getTime()) {

            var broadcast_start_date = new Date(<%=chatStartDate.Year.ToString()%>, <% =(chatStartDate.Month-1).ToString() %>, 
                <% =chatStartDate.Day.ToString() %>, <%=chatStartDate.Hour.ToString()%>, <% =chatStartDate.Minute.ToString()%>, 
                <% =chatStartDate.Second.ToString() %>, <%=chatStartDate.Millisecond.ToString()%>);
            var current_time = new Date();
            var seek_time = (current_time - broadcast_start_date) / 1000;       
            var audio_player_1 = document.getElementById("audio_1");
            audio_player_1.onplay = function () {
                if (seek_time < 0) {
                    audio_player_1.pause();
                }
                else {
                    if(seek_time < 4000) {
                        audio_player_1.currentTime = seek_time;
                    }
                }
            }
        }

    </script>
</asp:Content>

