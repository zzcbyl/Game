<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    public int roomid = 0;
    public DataRow drow = null;
    public string token = "";
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
        int userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            string currentUrl = Request.Url.ToString();
            if (token != "")
                currentUrl = currentUrl.Replace("&token=" + token, "").Replace("?token=" + token, "");
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(currentUrl), true);
        }
        
        ChatRoom chatRoom = new ChatRoom(roomid);
        drow = chatRoom._fields;
        if (drow == null)
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
    <div id="mydiv" class="main-page">
        <div style="padding:10px; background:#e3e3e3; text-align:center;">
            <div style="margin-top:30px; text-align:center;">温馨提示</div>
            <div style="margin-top:15px; line-height:22px; margin-bottom:30px;">
                该课程将于<%=DateTime.Parse(drow["start_date"].ToString()).ToString("yyyy年MM月dd日HH点") %>开始开播<br />
                请提前半小时入场，感谢您对卢勤问答平台微课教室的关注。
            </div>
        </div>
        <div style="margin-top:20px; text-align:center;">
            <a href="wktIndex_Integral.aspx?roomid=<%=roomid %>&token=<%=token %>" class="btn btn-danger">返 回</a>
        </div>
    </div>
</asp:Content>

