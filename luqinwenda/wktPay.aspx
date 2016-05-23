<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
<%@ Register src="UserHeadControl.ascx" tagname="UserHeadControl" tagprefix="uc1" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = "";
    public Users user = new Users();
    public string UserHeadImg = "http://game.luqinwenda.com/images/noAvatar.jpg";
    public string NickName = "匿名";
    public string FirstDate = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");
    public int userId = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        token = Util.GetSafeRequestValue(Request, "token", "");
        userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            string currentUrl = Request.Url.ToString();
            if (token != "")
                currentUrl = currentUrl.Replace("&token=" + token, "").Replace("?token=" + token, "");
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(currentUrl), true);
        }
        JavaScriptSerializer json = new JavaScriptSerializer();

        user = new Users(userId);
        try
        {
            Dictionary<string, object> dicUser = json.Deserialize<Dictionary<string, object>>(user.GetUserAvatarJson());
            if (dicUser.Keys.Contains("nickname"))
                NickName = dicUser["nickname"].ToString();
            if (dicUser.Keys.Contains("headimgurl"))
                UserHeadImg = dicUser["headimgurl"].ToString();
        }
        catch { }

        this.UserHeadControl1.UserHeadImg = UserHeadImg;
        this.UserHeadControl1.NickName = NickName;
        this.UserHeadControl1.UserIntegral = user.Integral.ToString();
        
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="content-main">
        <uc1:UserHeadControl ID="UserHeadControl1" runat="server"  />

    </div>
</asp:Content>

