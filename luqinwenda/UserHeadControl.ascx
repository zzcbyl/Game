<%@ Control Language="C#" ClassName="UserHeadControl" %>

<script runat="server">
    public string NickName = "";
    public string UserHeadImg = "";
    public string UserIntegral = "";
    public string Token = "";
    protected void Page_Load(object sender, EventArgs e)
    {

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

