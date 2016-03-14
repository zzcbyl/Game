<%@ Page Title="卢勤和她的朋友们视频微课堂" Language="C#" MasterPageFile="~/IntegralMall/Master.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = "ca013d0c12977bcafc530fd58f82782901bdb19d2fcb8f85769be0f1c6b57e5445f47401";
    public Users user = new Users();
    public string UserHeadImg = "http://game.luqinwenda.com/images/noAvatar.jpg";
    public string NickName = "匿名";
    public int user_integral = 0;
    private int article_video_id = 20;
    public int article_integral = 0;
    public int is_repeat = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        token = Util.GetSafeRequestValue(Request, "token", "");

        if (token.Trim().Equals(""))
        {
            if (Session["user_token"] != null)
            {
                token = Session["user_token"].ToString().Trim();
            }
        }

        int userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(Request.Url.ToString()), true);
        }
        Session["user_token"] = token;

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
        catch
        {

        }

        user_integral = int.Parse(user._fields["integral"].ToString());
        
        string type = "video";
        DataTable dt_integral = Integral.GetList(userId, 0, type, article_video_id);
        if (dt_integral.Rows.Count > 0)
            is_repeat = 1;

        DataTable dt = Article.Get(article_video_id);
        if (dt != null && dt.Rows.Count > 0)
        {
            article_integral = int.Parse(dt.Rows[0]["article_integral"].ToString());
        }



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
        <div style="margin:30px 0; text-align:center;">
            <img src="../images/wkt_confirm_icon.png" style="width:40%;" />
        </div>
        <div style="text-align:left; width:70%; margin-left:15%; line-height:25px;">
            <div>欢迎您进入【卢勤视频微课堂】</div>
            <div>观看直播视频微课将扣除 <%=article_integral %> 积分</div>
            <div>您目前的积分余额是：<%=user.Integral %></div>
        </div>
        <div style="text-align:center; margin:35px 0 80px;">
            <a class="btn" style="background:#E06F61; color:#fff;" href="javascript:submitVideo();">确定</a>　　
            <a class="btn" style="background:#E06F61; color:#fff;" href="javascript:history.go(-1);">取消</a>
        </div>
    </div>

    <script type="text/javascript">
        var uintegral = parseInt('<%=user_integral %>');
        var integral = parseInt('<%=article_integral %>');
        var video_aid = '<%=article_video_id %>';
        var isrepeat = '<%=is_repeat %>';
        function submitVideo() {
            if (isrepeat == '1') {
                location.href = 'wktVideo.aspx?article_video_id=' + video_aid;
                return;
            }

            if (uintegral > 0) {
                if (uintegral >= integral) {
                    location.href = 'wktVideo.aspx?article_video_id=' + video_aid;
                    return;
                }
            }
            alert("您的积分不足，请先签到获取积分");
            location.href = 'http://game.luqinwenda.com/dingyue/default.aspx';
        }

    </script>
</asp:Content>

