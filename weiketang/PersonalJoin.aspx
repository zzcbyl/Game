﻿<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    public string forward_count = "0";
    public string code = "";
    public string timeStamp = "";
    public string nonceStr = "r1y6wa1df1fd0bfr0sfcwb7bfep";
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
        catch { }
        if (Request["id"] != null && Request["id"] != "" && Request["code"] != null && Request["code"] != "")
        {
            try
            {
                code = Request["code"].ToString();
                System.Web.Script.Serialization.JavaScriptSerializer json = new System.Web.Script.Serialization.JavaScriptSerializer();
                string getNumUrl = "http://weixin.luqinwenda.com/dingyue/api/group_master_get_vote_num.aspx?id=" + Request["id"].ToString();
                string resultNum = HTTPHelper.Get_Http(getNumUrl);
                Dictionary<string, object> dicNum = json.Deserialize<Dictionary<string, object>>(resultNum);
                if (dicNum["status"].Equals(0))
                {
                    forward_count = dicNum["num"].ToString();
                }
            }
            catch { }
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>个人申请进入听课群</title>
    <script src="../script/jquery-1.3.2.min.js"></script>
    <script src="../script/common.js"></script>
    <style type="text/css">
        div { line-height:25px; }
        p { line-height:25px; }
        .promptDiv { width:180px; height:200px;  color:#000; position:absolute; z-index:20; font-size:14pt; line-height:30pt; text-align:center;}
    </style>
</head>
<body style="background:#ac1616">
    <div style="max-width: 640px; margin: 0 auto;">
        <img src="../images/personaljoinBanner.jpg" width="100%" />
        <div style="text-align:center; line-height:30px; background:#fff; padding:10px 10px 20px;">
            <div style="margin-top:10px;">邀请码：<span style="font-family:微软雅黑; font-size:14pt; font-weight:bold;"><%=code %></span></div>
            <div style="text-align:center; font-size:11pt; color:#808080; font-family:微软雅黑;">已有<span id="spCount"><%=forward_count %></span>票支持</div>
            <div style="text-align:left; margin-top:10px;">
                <div style="text-align:center; ">
                    <h2 style="color:#CC3333;">【卢勤和她的朋友们微课堂】</h2>
                    阳春三月幸福开讲！<br />    
                    《贺淑曼---站在人才的高度务教育》<br />
                </div>
                <span style="font-weight:bold; background:#ccc; display:inline-block; padding:5px; margin:3px 0;">个人申请进入听课群资格：</span><br />
                <%--● 申请活动截止时间：2016年1月21日12:00，之后将不再接受申请；<br />--%>
                　　● 仅限500个席位，满额之后将不再接受申请。<br />
                <span style="font-weight:bold; background:#ccc; display:inline-block; padding:5px; margin:3px 0;">个人申请进入听课群细则：</span><br />
                　　1. 报名在线讲座，请先关注卢勤问答平台微信公众号（ID：luqinwendapingtai）；<br />
                    <div style="text-align:center;"><img src="../images/dyh_code_min.jpg" width="40%" /></div>
                　　2. 在卢勤问答平台微信公众号中回复关键词：微课，领取属于自己的邀请码；<br />
                　　3. 将含有邀请码的支持页面转发到100人以上的微信群或者您的朋友圈，邀请朋友，在公众号中回复您的邀请码（<b><%=code %></b>），为您投上一票支持；<br />
                　　4. 当您的支持票数超过10票后，将支持票数截图给卢勤问答平台小助手，然后由小助手安排您入群，额满后将不再拉人入群。<br />
                　　卢勤问答平台小助手微信（luqinwenda001）。<br />
                    <div style="text-align:center;"><img src="../images/xiaozhushou.jpg" width="40%" /></div>
            </div>
            <div style="margin-top:10px;">邀请码：<span style="font-family:微软雅黑; font-size:14pt; font-weight:bold;"><%=code %></span></div>
            <div style="text-align:center; font-size:11pt; color:#808080; font-family:微软雅黑;">已有<span id="spCount"><%=forward_count %></span>票支持</div>
            <div style="margin-top:10px;">
                <a id="ASupported" style="display:none;">您已支持，谢谢！</a>
                <button id="btnSupport" style="width:90px; height:40px; background:#E51925; color:#fff; display:block; line-height:40px; margin:0px auto; font-size:14pt; border-radius:5px; border:0;" onclick="SupportVote(this);">支 持</button>
            </div>
            <div style="margin-top:20px; text-align:left;">
                <div><b style="color:red;">加群必知：</b></div>
                <div>　　卢勤问答平台微课直播群（卢勤和她的朋友们微课堂群）的朋友不用再重复申请入群，可以继续收听。</div>
            </div>
        </div>
        <div style="text-align:left; line-height:30px; background:#fff; padding:10px; margin-top:10px;">
            <p style="text-align:center;">
                <img src="../images/heshuman.jpg" width="90%" /></p>
            <h3>卢勤老师的朋友——著名学者贺淑曼教授</h3>
            <p>　　<b>贺淑曼</b>，教授 ，出身于教育世家，从教近50年，教过数以万计的学生，已遍及海内外。1993年由中国科技大学（少年班）调北京工业大学。先后开创了北工大心理咨询中心及青少年发展心理教研室的工作，均历任主任。1995年牵头创建了中国人才研究会超常人才专业委员会，现任名誉会长。2000年前后曾在全国心理教育界兼职20余项。先后八次担任英才（超常）教育国际论坛会、国际天才儿童教育研讨会及海峡两岸超常人才教育研讨会的大会主席及副主席，多次率团赴台湾学术交流。</p>
            <p>　　<b>荣誉：</b>约10余种，如 ：“五个一工程奖”（国家文化最高奖）、人事部“人才科研优秀奖”，北京市教委“心理素质教育突出贡献奖”、中国科大少年班“优秀班主任奖”等。</p>
            <p>　　<b>著作：</b>20余部，如：《创新素养与人才发展》、《创新与超常发展---像天才一样思维》，《让孩子赢在网络时代》《天生我材必有用  英才教育学》等。</p>
            <p>　　<b>原创理念：</b>她是国内笫一位倡导：英才教育两条腿走路（针对英才儿童的狭义英才教育和普及性的英才全人教育）。及囯内第一位倡导：幸福力教育，站在人才的高度务教育的著名学者。</p>
        </div>
        <div style="text-align:left; line-height:30px; background:#fff; padding:10px; margin-top:10px;">
            <p>　　所谓成“人”，就是要知道社会人的行为规范和道德底线，成“人”的过程就是社会化的过程。这是一个不被教育重视的教育。</p>
            <p>　　教育把我们引进了，为升学、为职称、为财富等的成功上了。其实更重要的是幸福。因为幸福对每个人来说，都是必须品，而不是什么奢侈品。人必须有知不足而常乐的意识，才能学会创造幸福的能力！3月4日，贺淑曼教授将带来幸福第一讲《基本幸福力教育--成“人”教育必修课  》，生动讲述学习的“四大支柱”。</p>
            <p><b>课程名称：</b>贺淑曼---站在人才的高度务教育</p>
            <p><b>开课时间：</b>3月4日（周五）20:00-21:00</p>
            <p><b>课程形式：</b>卢勤和她的朋友们微课堂群<br />　　　　　合作转播群</p>
            <p><b>适合人群：</b>愿意为孩子创造良好家庭教育环境的家长、准家长、教育工作者等。</p>
        </div>
    </div>
    <div id="showShare" style="display:none;" onclick="javascript:document.getElementById('showShare').style.display='none';">
        <div class="bgDiv" style="width:100%; height:100%; background:#ccc; color:#000; position:absolute; top:-10px; left:0px; text-align:center; filter:alpha(opacity=90); -moz-opacity:0.9;-khtml-opacity: 0.9; opacity: 0.9;  z-index:9;"></div>
        <div class="promptDiv" style="font-size:12pt; width:80%; top:20pt; left:10%; background:#fff;">
            <div style="line-height:20px; text-align:left; padding:10px;">长按指纹识别二维码，关注“卢勤问答平台”，回复邀请码进行支持</div>
            <img src="../images/dyh_code1.jpg" style="width:100%; " />
        </div>
    </div>
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript">
        var shareTitle = "请大家支持我，完成我的心愿，分享最棒的资源"; //标题
        var shareImg = "http://game.luqinwenda.com/images/wkt_share30.jpg"; //图片
        var shareContent = '我要参加卢勤公益微课堂报名，请大家支持我，这是我盼望已久的事情！'; //简介
        var shareLink = document.URL; //链接

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

        $(document).ready(function () {
            shareLink = document.URL;

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

        function SupportVote()
        {
            if (document.documentElement.scrollTop == 0) {
                $(".bgDiv").css({ height: document.body.scrollHeight + 30 + "px" });
                $(".promptDiv").css({ top: document.body.scrollTop + 80 + "px" });
            }
            else {
                $(".bgDiv").css({ height: document.body.scrollHeight + 30 + "px" });
                $(".promptDiv").css({ top: document.documentElement.scrollTop + 80 + "px" });
            }
            $("#showShare").show();
        }
    </script>
</body>
</html>
