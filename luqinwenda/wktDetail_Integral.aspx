<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">
    public int roomid = 0;
    public DataTable currentCDt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        roomid = int.Parse(Util.GetSafeRequestValue(Request, "roomid", "0"));
        if (roomid <= 0)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }

        ChatRoom chatRoom = new ChatRoom(roomid);
        DataRow drow = chatRoom._fields;
        if (drow == null)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
        int courseid = -1;
        if (drow["courseid"].ToString().Trim() != "0")
            courseid = int.Parse(drow["courseid"].ToString());
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
            <a href="wktConfirm_Integral.aspx?roomid=<%=roomid %>"><img src="/dingyue/upload/wkt_head<%=roomid %>.gif" style="width:100%;"/></a>
        </div>
        <div class="line_main" onclick="clickCourse(this, '<%=currentCDt.Rows[0]["course_link"].ToString() %>');">
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
        <div class="line_main" style="border-bottom:none; padding:10px 20px; height:auto; line-height:22px;">
            <div style="font-size:14px; font-weight:bold; padding:5px 0;">听课须知</div>
            <div>1、点击最上方大图，进入【卢勤问答平台微课教室】直播间；</div>
            <div>2、卢勤问答平台微课教室直播间为免费课程，只需花费课程积分即可；</div>
            <div>3、点击确定扣除积分后，进入微课直播间。课程直播中如需提问，点击右下方【我的问题】开始提问，您的问题将显示在这里。如果专家已经回答您的提问，左下方【全部问题】中将会显示您的问题解答。</div>
        </div>
        <div style="height:100px;"></div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            var bw = document.body.clientWidth;
            if (bw > 640)
                bw = 640;
            $('.line_middle').css('width', (bw - 130).toString() + "px");
        });

        function clickCourse(obj, url)
        {
            $(obj).css('color', '#888');
            location.href = url;
        }
    </script>
</asp:Content>

