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
    <script src="../script/suda.js"></script>
    <script src="../script/touch-0.2.13.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="main-header" style="">
        <div class="video_wrap" style="height:210px;">   
	        <div class="video_inner">
	   	        <!--video preload="<%=chatDrow["audio_bg"].ToString() %>"  controls="controls" node-type="mp4" id="h5-player" webkit-playsinline="" playsinline="true" x-webkit-airplay="true"  class="video"  type="video/mp4"  
src="https://blobsnowmeet.blob.core.chinacloudapi.cn/asset-0a7b93c0-11c0-4fe5-a2ce-913a9d64b73f/DJI_0001_compress.mp4?sv=2015-07-08&sr=c&si=c778c2b6-fe6a-47ec-a551-1df2dcb0b9ce&sig=DErta5PskNp4wiIeWq7yneafqk%2Fn9YQuFJmSQjI5KJI%3D&st=2017-05-24T03%3A52%3A04Z&se=2117-05-24T03%3A52%3A04Z"                        
                       >
                       
	   	        </!video-->
                <video preload="<%=chatDrow["audio_bg"].ToString() %>"  controls="controls" node-type="mp4" id="h5-player" webkit-playsinline="" playsinline="true" x-webkit-airplay="true"  class="video"  type="video/mp4"  
src="http://weixin.luqinwenda.com/go_to_classroom.aspx"                        
                       >
                       
	   	        </video>
    	        <!-- 封面图片 -->
		        <div class="poster_wrap" style="height: 375px;"><img src="<%=chatDrow["audio_bg"].ToString() %>" alt="" class="poster" style="height: 210px; width: auto;"></div>
	            <!-- 封面图片 -->
	            <!-- 播放按钮 -->
	            <!--div class="play_icon"></div-->
	            <!-- 播放按钮 -->
	        </div>    
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
            shareTitle = '【悦长大微课教室】';
            if (chat_shareContent != '')
                shareContent = chat_shareContent;
            if (chat_shareImage != '')
                shareImg = chat_shareImage;

            $('.emotion').qqFace({
                id: 'facebox', //表情盒子的ID
                assign: 'textContent', //给那个控件赋值
                path: 'face/'	//表情存放的路径
            });


            var video = document.getElementById('h5-player') || document.getElementById('ios5_player');
            if (typeof video !== "undefined") {
                var paused = false;
                video.addEventListener('pause', function () {
                    if (paused == false) {
                        paused = true;
                    }
                    if (video.ended) {
                        paused = false;
                    }
                }, false);
                video.addEventListener('ended', function () {
                    paused = false;
                }, false);
                video.addEventListener('play', function () {
                    if (paused == false) {
                        window.SUDA && window.SUDA.uaTrack && window.SUDA.uaTrack('video_landing_page', 'play_button');
                        poster.style.display = 'none';
                    }
                }, false);
            }


            $("#textContent").parent().css("width", (winWidth- 120).toString() + "px");
            $('#mydiv').css("height", ($(window).height() - 275).toString() + "px");

            fillList_QA();
            setInterval("fillList_QA()", 5000);
            setDots();
        });


        var videoWrap = document.getElementsByClassName('video_wrap')[0];
        var video = document.getElementsByClassName('video')[0];
        var poster = document.getElementsByClassName('poster')[0];
        var posterURL = poster.src;
        var posterWrap = document.getElementsByClassName('poster_wrap')[0];
        var videoURL = video.getAttribute('node-id');
        
        function ios5style() {
            var ua = window.navigator.userAgent;
            var ios5 = /iPhone OS/g;
            var ipad = /iPad/g;
            if (ios5.test(ua) || ipad.test(ua)) {
                posterWrap.style.display = 'none';
                
                document.getElementsByClassName('play_icon')[0].style.display = 'none';
                var clientW = document.body.clientWidth;
                video.setAttribute('class', 'ios5video');
                video.setAttribute("id", "ios5_player");
                video.setAttribute('poster', posterURL);
                //video.style.height = clientW + 'px';
                video.style.width = clientW + 'px';
            }
        }
        ios5style();
        function styleInit() {
            var clientW = document.body.clientWidth;
            var posterH = poster.height;
            var posterW = poster.width;
            posterWrap.style.height = '210px';
            if (posterH > posterW) {
                poster.style.width = clientW + 'px';
                poster.style.height = 'auto';
            }
            else if (posterH < posterW) {
                poster.style.height = clientW + 'px';
                poster.style.width = 'auto';
            }
        }
        poster.onload = function () {
            styleInit();
        }
        window.onresize = function () {
            styleInit();
            var clientW = document.body.clientWidth;
            var ua = window.navigator.userAgent;
            var ios5 = /iPhone OS 5/g;
            var ipad = /iPad/g;
            if (ios5.test(ua) || ipad.test(ua)) {
                video.style.height = clientW + 'px';
                video.style.width = clientW + 'px';
            }
        }

        touch.on(videoWrap, 'tap', function (ev) {
            if (window.navigator.platform !== 'iPhone' && window.navigator.platform !== 'iPad') {
                var ua = window.navigator.userAgent;
                var android4_4 = /Android [4-9]\.[0-9]/g;
                if (video.getAttribute('node-type') !== 'mp4') {
                    alert('该视频不能播放');
                    return false;
                } else if (android4_4.test(ua)) {
                    video.style.display = 'block';
                    //video.webkitRequestFullScreen();
                    var clientW = document.body.clientWidth;
                    video.style.width = clientW + 'px';
                    video.play();
                    /*
                    setTimeout(function () {
                        video.onwebkitfullscreenchange = function () {
                            if (!video.paused) {
                                video.pause();
                            }
                        }
                    }, 1000);*/
                } else {
                    window.location.href = '<%=audioUrl %>';
                    return false;
                }
            } else {
                video.style.display = 'block';
                video.play();
                if (video.paused) {
                    video.play();
                }
                return false;
            }
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

