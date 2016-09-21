<%@ Page Title="" Language="C#" MasterPageFile="~/IntegralMall/Master.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = "de0acf0f544eb478a8dfe60b3365d73d63de98a02f1cc0f79f908a28f13eacb2606f415a";
    public Users user = new Users();
    public string UserHeadImg = "http://game.luqinwenda.com/images/noAvatar.jpg";
    public string NickName = "匿名";
    public int roomId = 0;
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
        int userId = Users.CheckToken(token);
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

    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="max-width:640px; background:#FFFDEA; margin:0 auto; min-height:600px;">
        <div style="height:50px; width:100%; background:#C22B2B; font-family:宋体; color:#fff; font-size:14px; line-height:50px; font-weight:bold; letter-spacing:0.1em">
            <div style="float:left; width:40px; height:40px; margin:6px 0 0 10px; background:url(<%=UserHeadImg %>) no-repeat; background-size:40px 40px;"><img src="../dingyue/images/headbg.png" style="vertical-align:top; width:40px;" /></div>
            <div style="float:left; margin-left:10px; margin-top:2px;"><%=(NickName.Length > 5 ? NickName.Substring(0, 5) + "..." : NickName) %></div>
            <div style="float:right; margin-right:20px; font-size:16px;">积分：<span style="color:#D69100"><%=user.Integral %></span></div>
        </div>
        <div style="text-align:left; width:90%; margin-left:5%; line-height:25px; margin-top:20px;">
            <p><b>如何获得积分？</b></p>
            <div>转发签到文章到朋友圈可得1积分；</div>
            <div>邀请朋友转发您的签到文章到朋友圈，您可以再得到1积分。</div>
            <div>1. 请先关注悦长大家庭教育专家问答平台微信公众号（ID：luqinwendapingtai）；</div>
            <div style="text-align:center;">
                <img src="http://game.luqinwenda.com/dingyue/upload/dyh_code_min.jpg" width="50%" />
            </div>
            <div>2. 在公众号菜单点击“签到”，进入签到页面。</div>
            <div>3. 分享签到文章到朋友圈，获得积分。</div>
            <div>每位用户每天最多可以获得10积分。</div>
            <div>显示“已转”的签到文章再次分享到朋友圈将不会再增加积分。</div>
        </div>
        <div style="margin-top:20px; text-align:center;">
            <a href="wktIndexConfirm_Integral.aspx?roomid=<%=roomId %>&token=<%=token %>" class="btn btn-danger">返 回</a>
        </div>
    </div>
</asp:Content>

