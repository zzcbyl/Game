<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
<%@ Register src="UserHeadControl.ascx" tagname="UserHeadControl" tagprefix="uc1" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    public string token = "";
    public string UserHeadImg = "http://game.luqinwenda.com/images/noAvatar.jpg";
    public string NickName = "匿名";
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
            //this.Response.Redirect("Default.aspx?roomid=" + roomId + "&token=" + token + "&rdm=" + rdm);
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
    <uc1:UserHeadControl ID="UserHeadControl1" runat="server"  />
    <div class="content-couser-block">
        <div><span class="course-title">课程：</span><%=currentCDt.Rows[0]["course_title"].ToString() %></div>
        <div><span class="course-title">时间：</span><%=currentCDt.Rows[0]["course_time"].ToString().Trim() %></div>
        <div><span class="course-title">主讲：</span><%=currentCDt.Rows[0]["course_lecturer"].ToString() %></div>
    </div>
    <div style="padding:10px 30px; color:#e8775c; text-align:center;">
        <div>积分兑换：30 积分</div>
        <div>支付金额：10 元</div>
    </div>
    <div style="text-align:center; margin-top:20px; position:relative; height:45px;">
        <a style="z-index:10; position:absolute; left:20%; top:0; display:block; width:60%;" href="javascript:void(0);" onclick="jumpStep();"><img src="images/btn-pay.png" style="width:100%;" /></a>
    </div>
</asp:Content>

