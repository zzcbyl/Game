<%@ Control Language="C#" ClassName="UserHeadControl" %>

<script runat="server">
    public string NickName = "";
    public string UserHeadImg = "";
    public string UserIntegral = "";
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
</div>
