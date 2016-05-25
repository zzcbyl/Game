<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
<%@ Register src="UserHeadControl.ascx" tagname="UserHeadControl" tagprefix="uc1" %>
<%@ Import Namespace="System.Data" %>

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

        if (Request["product_id"] != null && Request["product_id"] != "" && int.Parse(Request["product_id"]) > 0)
        {
            Donate.setBuyTicketState(int.Parse(Request["product_id"]));
            DataTable ticketDt = Donate.getTicket(int.Parse(Request["product_id"]));
            if (ticketDt != null && ticketDt.Rows.Count > 0)
            {
                if (ticketDt.Rows[0]["paystate"].ToString().Equals("1"))
                {
                    UserChatRoomRights.SetUserChatRoom(userId, int.Parse(ticketDt.Rows[0]["roomid"].ToString()));
                    //this.Response.Redirect("wktIndex_integral.aspx?roomid=" + roomId + "&token=" + token);
                }
            }
        }
        
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <uc1:UserHeadControl ID="UserHeadControl1" runat="server"  />
    <div class="content-couser-block">
        <p><span class="course-title">兑换成功！</span></p>
        <p><span class="course-title">恭喜您获得“<%=currentCDt.Rows[0]["course_title"].ToString() %>”！</span></p>
        <p><span class="course-title">请在开课之前30分钟进入微课教室。</span></p>
        <p><span class="course-title">如错过本次课程，您可以在课程结束后的第二天收听重播。收听重播课程无需重复兑换门票。</span></p>
    </div>
    <div style="text-align:center; margin-top:20px; position:relative; height:45px;">
        <a class="btn-action-payed" href="wktIndex_integral.aspx?roomid=<%=roomId %>&token=<%=token %>">确认返回</a>
    </div>
</asp:Content>

