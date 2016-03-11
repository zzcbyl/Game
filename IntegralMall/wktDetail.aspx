<%@ Page Title="卢勤和她的朋友们视频微课堂" Language="C#" MasterPageFile="~/IntegralMall/Master.master" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .line_main { height:70px; width:auto; border-bottom:1px solid #A89390; }
        .line_left { float:left; background:#6ED4D6; width:70px; height:70px; text-align:center; }
        .line_left img { height:30px; margin-top:20px; }
        .line_middle { float:left; width:auto; height:50px; margin-left:10px; line-height:25px; margin-top:10px; font-weight:bold; margin-right:10px; }
        .line_middle div { width:auto; height:25px; overflow:hidden; }
        .line_right { float:right; width:40px;}
        .line_right img { height:30px; margin-top:20px; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="max-width:640px; background:#FFFDEA; margin:0 auto;">
        <div style="height:300px; width:auto; background:#D04131; text-align:center;">
            <a href="wktConfirm.aspx"><img src="../images/wkt_head.jpg" style="height:70%; margin-top:10%;"/></a>
        </div>
        <div class="line_main" onclick="location.href='http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=405301163&idx=2&sn=ed872e7bb159b354769e1f33422483cc#rd';">
            <div class="line_left">
                <img src="../images/wkt_icon1.jpg" />
            </div>
            <div class="line_middle">
                <div>讲课主题：心灵的成长需要肯定</div>
                <div>3月14日（周一）15:00-14:00</div>
            </div>
            <div class="line_right">
                <img src="../images/wkt_icon6.jpg" />
            </div>
        </div>
        <div class="line_main" onclick="location.href='http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=405302165&idx=1&sn=44c598a9c8bf672d19d923e6d4fdf88a&scene=1&srcid=0311U2FwDUMRydc0QIhe63C8#wechat_redirect';">
            <div class="line_left" style="background:#D66E93;">
                <img src="../images/wkt_icon2.jpg" />
            </div>
            <div class="line_middle">
                <div>主讲老师：卢勤</div>
                <div>中国少年儿童出版总社首席教育专家</div>
            </div>
            <div class="line_right">
                <img src="../images/wkt_icon6.jpg" />
            </div>
        </div>
        <div class="line_main" onclick="location.href='http://game.luqinwenda.com/dingyue/default.aspx';">
            <div class="line_left" style="background:#7D4C84;">
                <img src="../images/wkt_icon3.jpg" />
            </div>
            <div class="line_middle">
                <div>听课资格</div>
                <div>30积分可以兑换【卢勤视频微课堂】门票</div>
            </div>
            <div class="line_right">
                <img src="../images/wkt_icon6.jpg" />
            </div>
        </div>
        <div class="line_main" onclick="location.href='http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=404790715&idx=2&sn=ae0c64da8d02002e0172303c1625ca21#rd';">
            <div class="line_left" style="background:#EACB61;">
                <img src="../images/wkt_icon4.jpg" />
            </div>
            <div class="line_middle">
                <div>历史回顾</div>
                <div>【卢勤和她的朋友们微课堂】精彩微课回顾</div>
            </div>
            <div class="line_right">
                <img src="../images/wkt_icon6.jpg" />
            </div>
        </div>
        <div style="height:100px;"></div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            var bw = document.body.clientWidth;
            if (bw > 640)
                bw = 640;
            $('.line_middle').css('width', (bw - 130).toString() + "px");
        });
    </script>
</asp:Content>

