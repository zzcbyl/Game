<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    public string timeStamp = "";
    public string nonceStr = "y4fejubssf0bhr01sadf2w593ba9fskd3";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid_dingyue"];

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
        catch (Exception ex) { }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>卢勤问答暑期成长营</title>
    <script src="../script/jquery-1.3.2.min.js"></script>
</head>
<body style="background:#00c0c1;">
    <form id="form1" runat="server">
    <div style="max-width:640px; margin:0 auto; padding-bottom:60px;">
        <div><img src="upload/camp_01.jpg" width="100%" /></div>
        <div><a href="http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=506765618&idx=5&sn=c58b90ea74da22dbff472cc2832d4e8f&scene=0&previewkey=CaNeql4rjG8mbFEHXBc6BcwqSljwj2bfCUaCyDofEow%3D#wechat_redirect" style="display:block">
            <img src="upload/camp_02.jpg" width="100%" alt="“少年摄影家”秦岭户外训练营" /></a></div>
        <div><img src="upload/camp_03.jpg" width="100%" /></div>
        <div><a href="http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=506765618&idx=4&sn=eadba19b65ffcf9a463d4fdcbcbf800d&scene=0&previewkey=CaNeql4rjG8mbFEHXBc6BcwqSljwj2bfCUaCyDofEow%3D#wechat_redirect" style="display:block">
            <img src="upload/camp_04.jpg" width="100%" alt="“放飞梦想我能行” 2016年北京精品夏令营" /></a></div>
        <div><img src="upload/camp_05.jpg" width="100%" /></div>
        <div><a href="http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=506765618&idx=6&sn=58572d0681f3c3cf64056ef6822d2adc&scene=0&previewkey=CaNeql4rjG8mbFEHXBc6BcwqSljwj2bfCUaCyDofEow%3D#wechat_redirect" style="display:block">
            <img src="upload/camp_06.jpg" width="100%" alt="“少年摄影家”云南大咖摄影旅行训练营" /></a></div>
        <div><img src="upload/camp_07.jpg" width="100%" /></div>
        <div><a href="http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=506765618&idx=3&sn=ad49e07b28a2e912c5c79d103c73cae1&scene=0&previewkey=CaNeql4rjG8mbFEHXBc6BcwqSljwj2bfCUaCyDofEow%3D#wechat_redirect" style="display:block">
            <img src="upload/camp_08.jpg" width="100%" alt="“少年演说家”潜能开发营" /></a></div>
        <div><img src="upload/camp_09.jpg" width="100%" /></div>
        <div><a href="http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=506765618&idx=5&sn=c58b90ea74da22dbff472cc2832d4e8f&scene=0&previewkey=CaNeql4rjG8mbFEHXBc6BcwqSljwj2bfCUaCyDofEow%3D#wechat_redirect" style="display:block">
            <img src="upload/camp_10.jpg" width="100%" alt="“少年摄影家”秦岭户外训练营" /></a></div>
        <div><img src="upload/camp_11.jpg" width="100%" /></div>
        <div><a href="http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=506765618&idx=6&sn=58572d0681f3c3cf64056ef6822d2adc&scene=0&previewkey=CaNeql4rjG8mbFEHXBc6BcwqSljwj2bfCUaCyDofEow%3D#wechat_redirect" style="display:block">
            <img src="upload/camp_12.jpg" width="100%" alt="“少年摄影家”云南大咖摄影旅行训练营" /></a></div>
        <div><img src="upload/camp_13.jpg" width="100%" /></div>
        <div><a href="http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=506765618&idx=1&sn=285368af60e1fa1bbfa2182d00ca9e9e&scene=0&previewkey=CaNeql4rjG8mbFEHXBc6BcwqSljwj2bfCUaCyDofEow%3D#wechat_redirect" style="display:block">
            <img src="upload/camp_14.jpg" width="100%" alt="“大开眼界”【美国创新科技体验营】遇见未来的自己！" /></a></div>
        <div><img src="upload/camp_15.jpg" width="100%" /></div>
        <div><a href="http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=506765618&idx=7&sn=896a14921ece7e23a44195cc0b6a264c&scene=0&previewkey=CaNeql4rjG8mbFEHXBc6BcwqSljwj2bfCUaCyDofEow%3D#wechat_redirect" style="display:block">
            <img src="upload/camp_16.jpg" width="100%" alt="“少年探险家”北京松山户外拓展训练营" /></a></div>
    </div>
    </form>
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript">
        wx.config({
            debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
            appId: '<%=appId%>', // 必填，公众号的唯一标识
            timestamp: '<%=timeStamp%>', // 必填，生成签名的时间戳
            nonceStr: '<%=nonceStr%>', // 必填，生成签名的随机串
            signature: '<%=shaParam %>', // 必填，签名，见附录1
            jsApiList: [
                    'onMenuShareTimeline',
                    'onMenuShareAppMessage']
        });

        var shareTitle = '卢勤问答暑期成长营'; //标题
        var shareImg = 'http://game.luqinwenda.com/dingyue/upload/summercamp-icon.jpg'; //图片
        var shareContent = '2016年暑假，就是这么任性地过！踏出国门，“打开”美国科技大门，在高科技中预见未来的自己！跟随摄影大师，在户外探险中磨砺自己！跟卢勤、杨澜、敬一丹、小雨姐姐、鞠萍姐姐学习如何讲话！这个暑假，勇敢追梦，我能行！'; //简介
        var shareLink = 'http://game.luqinwenda.com/dingyue/SummerCamp.aspx'; //链接
        $(document).ready(function () {
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
        });
    </script>

</body>
</html>
