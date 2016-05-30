<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
<%@ Register src="UserHeadControl.ascx" tagname="UserHeadControl" tagprefix="uc1" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = "";
    public string FirstDate = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");
    public int userId = 0;
    public int roomId = 0;
    public DataRow chatdrow = null;
    public DataTable currentCDt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        roomId = int.Parse(Util.GetSafeRequestValue(Request, "roomid", "0"));
        if (roomId <= 0)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
        
        token = Util.GetSafeRequestValue(Request, "token", "");
        userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            string currentUrl = Request.Url.ToString();
            if (token != "")
                currentUrl = currentUrl.Replace("&token=" + token, "").Replace("?token=" + token, "");
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(currentUrl), true);
        }

        this.UserHeadControl1.Token = token;
        this.UserHeadControl1.UserId = userId;

        string rdm = new Random().Next(1, 99999).ToString();
        UserChatRoomRights userChatRoom = new UserChatRoomRights(userId, roomId);
        if (userChatRoom.CanEnter)
        {
            this.Response.Redirect("Default.aspx?roomid=" + roomId + "&token=" + token + "&rdm=" + rdm);
        }

        ChatRoom chatRoom = new ChatRoom(roomId);
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="content-main">
        <uc1:UserHeadControl ID="UserHeadControl1" runat="server"  />
        <div class="content-couser-block">
            <div><span class="course-title">课程：</span><%=currentCDt.Rows[0]["course_title"].ToString() %></div>
            <div><span class="course-title">时间：</span><%=currentCDt.Rows[0]["course_time"].ToString().Trim() %></div>
            <div><span class="course-title">主讲：</span><%=currentCDt.Rows[0]["course_lecturer"].ToString() %></div>
        </div>
        <div class="content-paytitle">
            <span>支付方式选择</span>
        </div>
        <div class="content-paymethod">
            <div class="content-paymethod-left" style="width:100%;">
                <div class="pm-method-content paying" value="integral" style="width:35%;">
                    <a><img src="images/pay-integral.png"  style="width:100%;" /></a>
                    <span>积分兑换</span>
                    <div><%=chatdrow["integral"].ToString() %><span>积分</span></div>
                    <a class="selected"></a>
                </div>
            </div>
            <%--<div class="content-paymethod-right">
                <div class="pm-method-content" value="money">
                    <a><img src="images/pay-money.png"  style="width:100%;" /></a>
                    <span>现金支付</span>
                    <div><%=float.Parse(chatdrow["price"].ToString())/100 %><span>元</span></div>
                    <a class="selected"></a>
                </div>
            </div>--%>
            <div class="clear"></div>
        </div>
        <div style="margin-top:10px; width:100%; font-size:85%; line-height:18px;">
            <div style="width:100%; text-align:center; padding:0 10px;">
                <a style="display:block; color:#6cb2f9; text-decoration:underline;" href="/dingyue/default.aspx?token=<%=token %>">如何获得积分？</a>
                <a style="display:block; color:#6cb2f9;">分享每日签到文章可获得积分</a>
            </div>
        </div>
        <div style="text-align:center; margin-top:20px; position:relative; height:35px;">
            <a style="z-index:10; position:absolute; left:15%; top:0;" class="btn-action-pay" href="javascript:void(0);" onclick="jumpStep();">确认提交支付</a>
            <div style="background:#e8775c; width:100%; height:1px; left:0; top:23px; position:absolute; z-index:0;"></div>
        </div>
        <div style="padding:20px; line-height:20px; font-size:85%; ">
            <div>1. 当天课程结束后，次日即可收听回顾。通过“预告回顾”重复收听课程，无需再次报名。</div>
            <div>2. 未能及时收听当日课程，也可通过“预告回顾”收听课程回顾</div>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $('.pm-method-content').click(function () {
                $('.pm-method-content').each(function () {
                    $(this).removeClass('paying');
                });
                $(this).addClass('paying');
            });
        });

        function jumpStep() {
            location.href = 'wktPayStep.aspx?roomid=<%=roomId %>&token=<%=token %>&paymethod=' + $('.paying').eq(0).attr('value');
        }

    </script>
</asp:Content>

