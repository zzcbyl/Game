<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
<%@ Register src="UserHeadControl.ascx" tagname="UserHeadControl" tagprefix="uc1" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    public string token = "";
    public int userId = 0;
    public int roomId = 0;
    public DataRow chatdrow = null;
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

        ChatRoom chatRoom = new ChatRoom(roomId);
        chatdrow = chatRoom._fields;
        if (chatdrow == null)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <uc1:UserHeadControl ID="UserHeadControl1" runat="server"  />
    <div class="content-couser-block">
        <p><span class="">兑换失败！</span></p>
        <p><span class="">您的积分不足，请先签到获得积分。</span></p>
        <p><span class=""></span></p>
        <p><span class="">
            <a style="display:block; color:#6cb2f9; text-decoration:underline;" href="/dingyue/default.aspx?token=<%=token %>">如何获得积分？</a></span></p>
    </div>
    <div style="text-align:center; margin-top:20px; position:relative; height:45px;">
        <a class="btn-action-payed" href="wktIndex_integral.aspx?roomid=<%=roomId %>&token=<%=token %>">确认返回</a>
    </div>
</asp:Content>

