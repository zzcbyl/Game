<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    public string timeStamp = "";
    public string nonceStr = "s4fa2s1d1ffdd0br0sfc9bwfa9d";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid"];
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            timeStamp = Util.GetTimeStamp();
            ticket = Util.GetTicket();
            string shaString = "jsapi_ticket=" + ticket.Trim() + "&noncestr=" + nonceStr.Trim()
                + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
            shaParam = Util.GetSHA1(shaString);
        }
        catch { }

        Response.Write(Request.Url.ToString().Trim());
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="../script/jquery-1.3.2.min.js"></script>
    <script src="../script/common.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        山东分公司对方告诉对方沃尔特沃尔特万人
    </div>
    </form>
</body>
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript">
        var shareTitle = "请大家支持我，完成我的心愿，分享最棒的资源"; //标题
        var shareImg = "http://game.luqinwenda.com/images/wkt_share_icon.jpg"; //图片
        var shareContent = '我要参加卢勤公益微课堂报名，请大家支持我，这是我盼望已久的事情！'; //简介
        var shareLink = document.URL; //链接

        alert('<%=ticket%>');
        alert('<%=nonceStr%>');
        alert('<%=timeStamp%>');
        alert(shareLink);
        alert('<%=shaParam%>');
        
        wx.config({
            debug: true, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
            appId: '<%=appId%>', // 必填，公众号的唯一标识
            timestamp: '<%=timeStamp%>', // 必填，生成签名的时间戳
            nonceStr: '<%=nonceStr%>', // 必填，生成签名的随机串
            signature: '<%=shaParam %>', // 必填，签名，见附录1
            jsApiList: [
                    'onMenuShareTimeline',
                    'onMenuShareAppMessage']
        });

        wx.ready(function () {
            //分享到朋友圈
            wx.onMenuShareTimeline({
                title: shareTitle, // 分享标题
                link: shareLink, // 分享链接
                imgUrl: shareImg, // 分享图标
                success: function () {
                    // 用户确认分享后执行的回调函数

                }
            });

            //分享给朋友
            wx.onMenuShareAppMessage({
                title: shareTitle, // 分享标题
                desc: shareContent, // 分享描述
                link: shareLink, // 分享链接
                imgUrl: shareImg, // 分享图标
                success: function () {
                    // 用户确认分享后执行的回调函数

                }
            });
        });

    </script>
</html>
