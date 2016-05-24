<%@ Control Language="C#" ClassName="UserHeadControl" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    private string NickName = "";
    private string UserHeadImg = "";
    private int UserIntegral = 0;
    public string Token = "";
    public int UserId = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        JavaScriptSerializer json = new JavaScriptSerializer();

        Users user = new Users(UserId);
        UserIntegral = user.Integral;
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

<div class="content-header">
    <div class="content-header-left">
        <div id="headimg" style="background:url(<%=UserHeadImg %>) no-repeat; background-size:40px 40px;"></div>
        <div id="nickname"><%=(NickName.Length > 5 ? NickName.Substring(0, 5) + "..." : NickName) %></div>
    </div>
    <div class="content-header-right">
        <div id="integralnum"><%=UserIntegral %></div>
        <div id="integraltext">积分余额</div>
    </div>
    <div class="content-header-right-link">
        <a style="color:#fff;" href="/dingyue/default.aspx?token=<%=Token %>">获<br />得<br />积<br />分<br /></a>
    </div>
</div>
<div class="content-header-nav">
    微 课 门 票 兑 换
</div>
<script type="text/javascript">
    $(document).ready(function () {
        $('.content-header-right').css('width', (parseInt($(document.body).width()) / 2 - 56).toString() + 'px');
    });
</script>

