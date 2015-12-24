<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    public string forward_count = "0";
    public string code = "";
    public string timeStamp = "";
    public string nonceStr = "r1y6wa1df1fd0br0sfcwb7bfep";
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
    <title>微课邀请函</title>
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
                　　卢勤和她的朋友们微课堂<br />
                　　2016年12月30日<br />
                　　给孩子一个自信的世界！<br />
                　　个人申请加入听课群，仅限 500个名额！<br />
                　　申请结束时间：2015年12月30日12:00，额满为止。<br />
                　　1. 首次报名在线讲座，请先关注卢勤问答平台微信公众号（ID：luqinwendapingtai）；<br />
                    <div style="text-align:center;"><img src="../images/dyh_code_min.jpg" width="40%" /></div>
                　　2. 在卢勤问答平台微信公众号中回复关键词：微课，领取属于自己的邀请码；<br />
                　　3. 邀请朋友，在公众号中输入您的邀请码，为您投上一票支持；<br />
                　　4.当您的支持票数超过10票后，请在12月30日12:00前将支持票数截图给卢勤问答平台小助手，然后由小助手安排您入群，额满后将不再拉人入群。<br />
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
                <div><b>加群必知：</b></div>
                <div>　　1. 上次微课报名中已集够10个支持，但未进群的朋友，请将截图直接发送给卢勤问答平台小助手，小助手将安排您入群。</div>
                <div>　　2. 已加入12月22日微课直播群（卢勤和她的朋友们微课堂001、卢勤和她的朋友们微课堂002）的朋友不用再重复申请入群，可以继续收听。</div>
            </div>
        </div>
        <div style="text-align:left; line-height:30px; background:#fff; padding:10px; margin-top:10px;">
            <p style="text-align:center;">
                <img src="../images/luqin.jpg" width="90%" /></p>
            <p><h3>卢勤老师</h3></p>
            <p>　　卢勤老师是中国少年儿童新闻出版总社首席教育专家,深受广大家长和小朋友喜爱的“知心姐姐”，中国家庭教育学会常务理事，中国关心下一代工作委员会专家委员会委员，全国“更新家庭教育观念报告团”成员，曾担任中国少年儿童新闻出版总社总编辑。中央电视台、中国教育电视台、北京电视台、腾讯、搜狐等多家传媒名牌栏目的常邀嘉宾。</p>
            <p>　　三十多年来,卢勤老师致力于对少年儿童及家长心理健康的研究。在长期主持《中国少年报》“知心姐姐”栏目过程中，积累了大量的一线家庭教育实践经验，是中国上亿家长及儿童最喜爱、最信任的权威教育专家，深受亿万家长和孩子的爱戴。</p>
        </div>
        <div style="text-align:left; line-height:30px; background:#fff; padding:10px; margin-top:10px;">
            <p><h3 style="text-align:center;">本年度最精彩的一课即将开讲！</h3></p>
            <p>　　每个孩子都像一个未被开发的宝藏，而如何挖掘，让他们发挥出应有的价值，需要我们每一个人用心去探索。而自信，是开启宝藏最重要的钥匙。一个人真正内在的自信，是从小培养出来的。那么，家长们如何培养孩子树立自信呢？本次课程，卢勤老师将带来本年度最精彩的一课，告诉您如何给孩子一个自信的世界！</p>
            <p><b>课程名称：</b>自信，让孩子喊出“我能行”！</p>
            <p><b>开课时间：</b>12月30日（周三）20:00-21:00</p>
            <p><b>课程形式：</b>卢勤和她的朋友们微课堂群</p>
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
