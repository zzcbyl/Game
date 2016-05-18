<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">
    public int roomid = 0;
    public DataTable currentCDt = new DataTable();
    public string token = "";
    public int userid = 0;
    public int isbaoming = 0;
    public DataRow chatdrow = null;
    protected void Page_Load(object sender, EventArgs e)
    {
        roomid = int.Parse(Util.GetSafeRequestValue(Request, "roomid", "0"));
        if (roomid <= 0)
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

        UserChatRoomRights userChatRoom = new UserChatRoomRights(userid, roomid);
        if (userChatRoom.CanEnter && userChatRoom.CanPublishText)
        {
            isbaoming = 1;
        }

        ChatRoom chatRoom = new ChatRoom(roomid);
        chatdrow = chatRoom._fields;
        if (chatdrow == null)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
        int courseid = -1;
        if (chatdrow["courseid"].ToString().Trim() != "0")
            courseid = int.Parse(chatdrow["courseid"].ToString());
        DataTable CourseDt = Donate.getCourse(courseid);
        if (CourseDt != null && CourseDt.Rows.Count > 0)
        {
            currentCDt = CourseDt;
        }
        
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .line_main { height:70px; width:auto; border-bottom:1px solid #A89390; }
        .line_left { float:left; background:#6ED4D6; width:70px; height:70px; text-align:center; }
        .line_left img { height:30px; margin-top:20px; }
        .line_middle { float:left; width:auto; height:50px; margin-left:10px; line-height:25px; margin-top:10px; font-weight:bold; margin-right:10px; }
        .line_middle div { width:auto; height:25px; overflow:hidden; }
        .line_right { float:right; width:40px;}
        .line_right img { height:30px; margin-top:20px; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="max-width:640px; background:#FFFDEA; margin:0 auto;">
        <%--<div style='width:auto; height:300px; background:#D04131; text-align:center; background:url(<%=currentCDt.Rows[0]["course_headimg"].ToString() %>) no-repeat; background-size:100% auto; background-position-y:center;'>--%>
        <div style="width:auto; background:#D04131; text-align:center;">
            <a href="javascript:void(0);" onclick="jumpCourse();"><img src="<%=chatdrow["audio_bg"].ToString() %>" style="width:100%;"/></a>
        </div>
        <div style="background:#e8775c; height:100px; border-bottom:1px solid #c5593e; color:#fff;" onclick="jumpCourse();">
            <div style="float:left; width:30%; height:100px; line-height:100px; text-align:center; vertical-align:middle; border-right:1px solid #c5593e; position:relative;">
                <% if (isbaoming==0) { %>
                <a style="position:absolute; z-index:99; left:5px; top:-10px;"><img src="images/wkt_index_bm.png" style="width:90%; margin-top:-10px;" /></a>
                <% } else { %>
                <a style="position:absolute; z-index:99; left:5px; top:-10px;"><img src="images/wkt_index_jr.png" style="width:90%; margin-top:-10px;" /></a>
                <%} %>
            </div>
            <div style="float:left; width:25%; height:100px; padding:5px 2%; border-right:1px solid #c5593e; line-height:30px;">
               <div style="height:60px; overflow:hidden; font-size:18px; font-family:SimHei; font-weight:bold; text-align:center; color:#fceadd;">
                   <div><%=currentCDt.Rows[0]["course_time"].ToString().Substring(0, currentCDt.Rows[0]["course_time"].ToString().IndexOf('（')).Trim() %></div>
                   <div style="font-weight:normal; font-size:16px;">20:00</div>
               </div>
               <div style="color:#b65138; font-weight:bold; text-align:center; font-size:12px;">讲课时间</div>
            </div>
            <div style="float:left; width:45%; height:100px; padding:5px 2%; line-height:30px; overflow:hidden;">
               <div style="height:60px; font-size:18px; overflow:hidden; text-align:center; color:#fceadd; font-family:SimHei; font-weight:bold;"><%=currentCDt.Rows[0]["course_title"].ToString() %></div>
               <div style="color:#b65138; font-weight:bold; text-align:center; font-size:12px;">讲课主题</div>
            </div>
        </div>
        <div id="time_div" style="background:#e8775c; height:50px; color:#fff; ">
            <div style="float:left; width:70%; line-height:50px; padding:0 10px; color:#b65138; font-weight:bold;">
                <div style="float:left;">倒计时：</div><ul id="sp_time" class="time_ul" style="border-radius:15px; width:163px;"><li>-</li><li>-</li><li>-</li><li style="border-right:none;">-</li></ul>
            </div>
            <%--<div style="float:left; width:30%; background:#bd634c; text-align:center; height:50px; line-height:20px; padding:5px 0;">设置<br />提醒</div>--%>
        </div>
        <div class="line_main" style="padding:10px 20px; height:auto; line-height:22px;">
            <div style="font-size:14px; font-weight:bold; padding:5px 0; color:#b65138;">课程简介</div>
            <span style="color:#b65138;">　　<%=currentCDt.Rows[0]["course_title"].ToString() %></span>
            <%=chatdrow["course_intro"].ToString() %>
            <%--<%=currentCDt.Rows[0]["course_preface"].ToString() %>--%>
        </div>
        <div class="line_main" style="padding:10px 20px; height:auto; line-height:22px;">
            <div style="font-size:14px; font-weight:bold; padding:5px 0; color:#b65138;">主讲介绍</div>
            <%=chatdrow["lecturer_intro"].ToString() %>
            
        </div>


        <%--<div class="line_main" onclick="clickCourse(this, '<%=currentCDt.Rows[0]["course_link"].ToString() %>');">
            <div class="line_left">
                <img src="../images/wkt_icon1.jpg" />
            </div>
            <div class="line_middle">
                <div style="height:50px;">主题：<%=currentCDt.Rows[0]["course_title"].ToString() %></div>
            </div>
            <div class="line_right">
                <img src="../images/wkt_icon6.jpg" />
            </div>
        </div>
        <div class="line_main" onclick="clickCourse(this, '<%=currentCDt.Rows[0]["course_lecturer_link"].ToString() %>');">
            <div class="line_left" style="background:#D66E93;">
                <img src="../images/wkt_icon2.jpg" />
            </div>
            <div class="line_middle">
                <div>主讲老师：<%=currentCDt.Rows[0]["course_lecturer"].ToString() %></div>
                <div style="font-size:12px;"><%=currentCDt.Rows[0]["course_time"].ToString() %></div>
            </div>
            <div class="line_right">
                <img src="../images/wkt_icon6.jpg" />
            </div>
        </div>
        <div class="line_main" style="padding:10px 20px; height:auto; line-height:22px;">
            <div style="font-size:14px; font-weight:bold; padding:5px 0;">课程简介</div>
            <div>　　每个妈妈都希望和孩子亲密沟通，良好的亲子沟通是建立亲密亲子关系的基础，如何实现高质量的亲子沟通呢？</div>
        </div>
        <div class="line_main" style="border-bottom:none; padding:10px 20px; height:auto; line-height:22px;">
            <div style="font-size:14px; font-weight:bold; padding:5px 0;">听课须知</div>
            <div>1、点击最上方大图，进入【卢勤问答平台微课教室】直播间；</div>
            <div>2、卢勤问答平台微课教室直播间为免费课程，只需花费课程积分即可；</div>
            <div>3、点击确定扣除积分后，进入微课直播间。课程直播中如需提问，点击右下方【我的问题】开始提问，您的问题将显示在这里。如果专家已经回答您的提问，左下方【全部问题】中将会显示您的问题解答。</div>
        </div>--%>
        <div style="height:100px;"></div>
    </div>
    <script type="text/javascript">
        var startTime = '<%=chatdrow["start_date"].ToString() %>';
        var timeID;
        var chat_shareContent = '<%=chatdrow["shareContent"].ToString() %>';
        var chat_shareImage = '<%=chatdrow["shareimage"].ToString() %>';
        $(document).ready(function () {
            shareTitle = '<%=currentCDt.Rows[0]["course_title"].ToString() %>';
            if (chat_shareContent!='')
                shareContent = chat_shareContent;
            if (chat_shareImage != '')
                shareImg = chat_shareImage;

            var bw = document.body.clientWidth;
            if (bw > 640)
                bw = 640;
            $('.line_middle').css('width', (bw - 130).toString() + "px");
            var sTime = new Date(Date.parse(startTime.replace(/-/g, "/")))
            timeID = window.setInterval(function () { ShowCountDown(sTime.getFullYear(), sTime.getMonth() + 1, sTime.getDate(), sTime.getHours(), sTime.getMinutes(), 0); }, 1000);
        });

        function clickCourse(obj, url)
        {
            $(obj).css('color', '#888');
            location.href = url;
        }

        function jumpCourse()
        {
            location.href = 'wktIndexConfirm_Integral.aspx?roomid=<%=roomid %>&token=<%=token %>';
        }


        function ShowCountDown(year, month, day, s_hour, s_minute, s_second) {
            var now = new Date();
            var endDate = new Date(year, month - 1, day, s_hour, s_minute, s_second);
            var leftTime = endDate.getTime() - now.getTime();
            if (leftTime < 0) {
                $('#time_div').hide();
                window.clearInterval(timeID);
            }
            var leftsecond = parseInt(leftTime / 1000);
            var day1 = Math.floor(leftsecond / (60 * 60 * 24));
            var hour = Math.floor((leftsecond - day1 * 24 * 60 * 60) / 3600);
            var minute = Math.floor((leftsecond - day1 * 24 * 60 * 60 - hour * 3600) / 60);
            var second = Math.floor(leftsecond - day1 * 24 * 60 * 60 - hour * 3600 - minute * 60);
            $('#sp_time li').eq(0).html(day1 + "天");
            $('#sp_time li').eq(1).html(hour + "时");
            $('#sp_time li').eq(2).html(minute + "分");
            $('#sp_time li').eq(3).html(second + "秒");
            //$('#sp_time').html(day1 + "天" + hour + "小时" + minute + "分" + second + "秒");
        }
    </script>
</asp:Content>

