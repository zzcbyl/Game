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
    <style type="text/css">
        img { vertical-align:top; }
        .camp-main { max-width:640px; margin:0 auto; padding-bottom:60px; }
        .camp-main div { position:relative;}
        .camp-main .entry-count { color:#fff; position:absolute; right:6%; top:25%; font-size:130%; font-weight:bold; font-family:微软雅黑; width:23%; text-align:center; z-index:99; }
        .camp-main .entry-full { display:block; position:absolute; right:5%; top:10%; width:11%; height:100%; z-index:100; background:url(images/entry-full.png) no-repeat; background-size:contain;}
        .camp-main .entry-discount { display:block; position:absolute; right:30%; top:-18%; width:11%; height:100%; z-index:100; background:url(images/entry-discount.png) no-repeat; background-size:contain; }
        .camp-nav-bg { height:8px; background:url(upload/camp-ul-bg.jpg) repeat-y; background-size:contain; display:block; }
    </style>
</head>
<body style="background:#f9f5e9; margin:0;">
    <form id="form1" runat="server">
    <div class="camp-main">
        <div style="height:100px; width:100%; background:#E9775C; text-align:center;vertical-align:middle;">
            <img src="images/summercamp-title.png" style="width:90%; margin-top:35px;"/>
        </div>
        <div><img src="upload/camp-ul-header.jpg" width="100%" /></div>
        <a class="camp-nav-bg"></a>
        <div>
            <img src="upload/camp-ul-li01.jpg" width="100%" />
            <a class="entry-count">30/30</a>
            <a class="entry-full"></a>
        </div>
        <a class="camp-nav-bg"></a>
        <div onclick="jumpCamp(2);">
            <img src="upload/camp-ul-li03.jpg" width="100%" />
            <a class="entry-count">20/100</a>
            <a class="entry-discount"></a>
        </div>
        <a class="camp-nav-bg"></a>
        <div><img src="upload/camp-ul-li05.jpg" width="100%" />
            <a class="entry-count">30/30</a>
            <a class="entry-full"></a>
        </div>
        <a class="camp-nav-bg"></a>
        <div onclick="jumpCamp(4);">
            <img src="upload/camp-ul-li07.jpg" width="100%" />
            <a class="entry-count">33/100</a>
        </div>
        <a class="camp-nav-bg"></a>
        <div onclick="jumpCamp(5);">
            <img src="upload/camp-ul-li09.jpg" width="100%" />
            <a class="entry-count">12/30</a>
            <a class="entry-discount"></a>
        </div>
        <a class="camp-nav-bg"></a>
        <div onclick="jumpCamp(6);">
            <img src="upload/camp-ul-li11.jpg" width="100%" />
            <a class="entry-count">11/30</a>
            <a class="entry-discount"></a>
        </div>
        <a class="camp-nav-bg"></a>
        <div onclick="jumpCamp(7);">
            <img src="upload/camp-ul-li13.jpg" width="100%" />
            <a class="entry-count">50/50</a>
            <a class="entry-full"></a>
        </div>
        <a class="camp-nav-bg"></a>
        <div onclick="jumpCamp(8);">
            <img src="upload/camp-ul-li15.jpg" width="100%" />
            <a class="entry-count">22/50</a>
            <a class="entry-discount"></a>
        </div>
        <a class="camp-nav-bg"></a>
        <div onclick="jumpCamp(9);">
            <img src="upload/camp-ul-li17.jpg" width="100%" />
            <a class="entry-count">8/50</a>
            <a class="entry-discount"></a>
        </div>
        <div>
            <img src="upload/camp-ul-li18.jpg" width="100%" />
        </div>
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
        var shareContent = '2016年暑假夏令营全攻略，点开就能看！赶紧戳进来~'; //简介
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

        function jumpCamp(n) {
            if (n == 1) {
                
            }
            else if (n == 2) {
                location.href = 'http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=506765618&idx=4&sn=eadba19b65ffcf9a463d4fdcbcbf800d&scene=0&previewkey=CaNeql4rjG8mbFEHXBc6BcwqSljwj2bfCUaCyDofEow%3D#wechat_redirect';
            } else if (n == 3) {

            } else if (n == 4) {
                location.href = 'http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=506765618&idx=3&sn=ad49e07b28a2e912c5c79d103c73cae1&scene=0&previewkey=CaNeql4rjG8mbFEHXBc6BcwqSljwj2bfCUaCyDofEow%3D#wechat_redirect';
            } else if (n == 5) {
                location.href = 'http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=506765618&idx=5&sn=c58b90ea74da22dbff472cc2832d4e8f&scene=0&previewkey=CaNeql4rjG8mbFEHXBc6BcwqSljwj2bfCUaCyDofEow%3D#wechat_redirect';
            } else if (n == 6) {
                location.href = 'http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=506765749&idx=1&sn=e3059515579d8e713f945c0e71f5d016#rd';
            } else if (n == 7) {
                location.href = 'http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=2654249317&idx=3&sn=0746623aaece6ef6bafe2ce99396bbcd&scene=21#wechat_redirect';
            } else if (n == 8) {
                location.href = 'http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=506765618&idx=6&sn=58572d0681f3c3cf64056ef6822d2adc&scene=0&previewkey=CaNeql4rjG8mbFEHXBc6BcwqSljwj2bfCUaCyDofEow%3D#wechat_redirect';
            } else if (n == 9) {
                location.href = 'http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=506765618&idx=7&sn=896a14921ece7e23a44195cc0b6a264c&scene=0&previewkey=CaNeql4rjG8mbFEHXBc6BcwqSljwj2bfCUaCyDofEow%3D#wechat_redirect';
            }

        }
    </script>

</body>
</html>
