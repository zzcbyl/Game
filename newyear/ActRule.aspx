﻿<%@ Page Title="" Language="C#" MasterPageFile="~/dingyue/Master.master" %>

<script runat="server">

</script>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="../script/jquery-2.1.1.min.js"></script>
    <script src="../script/common.js"></script>
    <style type="text/css">
        body, div { font-family:SimSun;}
        .bgContent { background:#595167; max-width: 640px; margin: 0 auto; min-height:600px; padding-bottom:10px; }
        .header { min-height:120px; background:#B6092F; }
        .header #leftlogo { float:left; width:50%; max-height:120px;  }
        .header #rightlogo { float:right; width:45%; max-height:120px; margin-top:5%; margin-right:5%; }
        .header img { width:100%; }
        .maincontent { padding:0 20px 20px; }
        .maincontent div { margin-top:10px;  }
        .maincontent .tab1 { width:33%; float:left; text-align:center; }
        .maincontent .tab2 { width:33%; float:left; text-align:center; }
        .maincontent .tab3 { width:33%; float:left; text-align:center; }
        .maincontent .tab1 img, .maincontent .tab2 img, .maincontent .tab3 img { width:60%; margin:5px auto; }
        .progress { width:40%; float:left; height:20px; border:2px solid #332942; }
        .giftList { margin-left:20px; margin-top:5px;}
        .giftList div { margin:0; font-size:16px; color:#392D4C; width:100%;  line-height:25px;}
        .promptDiv { width:180px; height:200px;  color:#000; position:absolute; z-index:20; font-size:14pt; line-height:30pt; text-align:center;}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="bgContent">
        <div class="header">
            <div id="leftlogo"><img src="images/ny_logo1.png" /></div>
            <div id="rightlogo"><img src="images/ny_logo2.png" /></div>
        </div>
        <div style="color:#e2d9d9; padding:20px;">
            <div><h4>活动规则</h4></div>
            <div style="margin-left:20px;">
                <div>1、在“卢勤问答平台”公众号菜单栏点击——“礼盒”，领取您的礼盒。</div>
                <div>2、将本活动的链接分享到朋友圈或者您的好友，邀请您的好友帮您拆礼盒。</div>
                <div>3、当有10-30个好友帮您点击“帮TA拆礼盒”，您就可以开启一个礼盒。</div>
                <div>4、您共有8个小礼盒和1个大礼盒，小礼盒全部开启后可开启大礼盒，开启大礼盒后您将获得终极大奖。</div>
                <div>5、每个礼盒内均有奖品，您可以获得所有您成功开启礼盒中的奖品。</div>
            </div>
            <div style="margin-top:10px;"><h4>领奖方式</h4></div>
            <div style="margin-left:20px;">
                <div>1、本活动于2016年1月4日结束， 1月5日之后开始领取奖品。</div>
                <div>2、1月5日之后点击领奖按钮，输入您的领奖相关信息，我们将以邮寄的方式把您的奖品发放给您。</div>
            </div>
            <div style="margin-top:10px;"><h4>活动说明</h4></div>
            <div style="margin-left:20px;">
                <div>注意事项：禁止以任何不正当手段及舞弊行为参与活动，一经发现，活动发起人有权取消用户的获奖资格。</div>
                <div>本活动最终解释权归卢勤问答平台所有。</div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript">
        var shareTitle = "我想要新年礼盒，请大家帮帮我"; //标题
        var shareImg = "http://game.luqinwenda.com/newyear/images/ny_share_icon.jpg"; //图片
        var shareContent = '卢勤问答平台新年大礼盒！'; //简介
        var shareLink = 'http://game.luqinwenda.com/newyear/default.aspx'; //链接

        $(document).ready(function () {
            shareLink = 'http://game.luqinwenda.com/newyear/default.aspx?id=' + QueryString("id");
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
</asp:Content>

