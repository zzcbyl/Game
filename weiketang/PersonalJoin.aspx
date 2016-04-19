<%@ Page Language="C#" %>

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
                <div style="text-align:center; font-weight:bold; ">
                    <h3 style="color:#CC3333;">【卢勤和她的朋友们微课堂】</h3>
                    2016年4月21日<br />
                    让孩子学会自己奔跑，从哈佛父母的育儿经讲起…<br /><br />
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
                <div>　　已加入卢勤问答平台微课直播群（卢勤和她的朋友们微课堂群）的朋友不用再重复申请入群，可以继续收听。</div>
            </div>
        </div>
        
        <%--<div style="text-align:left; line-height:30px; background:#fff; padding:10px; margin-top:10px;">
            <p style="text-align:center;">
               <img src="../images/luqin.jpg" width="90%" /></p>
            <p><h3>卢勤老师</h3></p>
            <p>　　中国少年儿童新闻出版总社首席教育专家,深受广大家长和小朋友喜爱的“知心姐姐”，中国家庭教育学会常务理事，中国关心下一代工作委员会专家委员会委员，曾担任中国少年儿童新闻出版总社总编辑。中央电视台、中国教育电视台、北京电视台、腾讯、搜狐等多家传媒名牌栏目的常邀嘉宾。</p>
            <p>　　三十多年来,卢勤老师致力于对少年儿童及家长心理健康的研究。在长期主持《中国少年报》“知心姐姐”栏目过程中，积累了大量的一线家庭教育实践经验，是中国上亿家长及儿童最喜爱、最信任的权威教育专家，深受亿万家长和孩子的爱戴。</p>
        </div>--%>
        <div style="text-align:left; line-height:30px; background:#fff; padding:10px; margin-top:10px;">
            <p style="text-align:center;">
               <img src="../images/yangqingxia.jpg" width="90%" /></p>
            <p><h3>杨清瑕老师</h3></p>
            <p>　　杨清瑕老师是中国教育学会家庭教育专业委员会理亊和专家讲师团成员。曾担任中国少年报培训中心校长，中国少年儿童新闻出版总社知心姐姐教育服务中心培训部负责人、知心家庭学校校长。有过多年一线教育教学经验，多次领衔国家级重点教育课程。为全国各地教师、学生、家长做过近千场精彩报告，深受欢迎。</p>
            <p>　　清瑕老师赴美多年，研究了中美基础教育、家庭教育的差异。并通过中美媒体发表多篇有影响力的美文，为促进中国家庭教育起到积极的推动作用。现已成为中美多家网络公众号的特约作者。</p>
        </div>
        <div style="text-align:left; line-height:30px; background:#fff; padding:10px; margin-top:10px;">
            <p>　　孟雨晴（Damon Meng）七岁来到美国，2009年以所有毕业生课业总评（GPA）第一名的成绩从麦迪逊高中毕业，同时被哈佛大学、普林斯顿大学、耶鲁大学、哥伦比亚大学、茱丽亚音乐学院、新英格兰音乐学院及其双大学的双学位项目（Join-Program）录取。2013年他哈佛经济专业毕业后，担任华尔街世界最大独立另类资产管理机构佰仕通集团（Blackstone Group ）金融分析师。</p>
            <p>　　“马拉松队员比赛的时候，他前面有个引领人。这个人既不能靠他太近，也不能在他旁边，而是需要一定的超前量。如果引领人挡住了跑步人的路，或者跑步的人根本看不见引领者，或者引领人过来具体指导跑步人，都会影响选手的发挥。怎样做到既不影响跑步速度，又能保持一定距离的引导，是引领者的责任。”</p>
            <p>　　孟雨晴父亲M爸这样比喻父母的作用，更道出了孩子教育中，家长的真正责任。尊重孩子的选择，从小就把他当成一个独立的人格来陪伴，让他一开始就学会自我奔跑。</p>
            <p>　　<b>4月21日，中国教育学会家庭教育专业委员会理亊和专家讲师团成员杨清瑕老师做客卢勤微课堂，和各位家长分享：《让孩子学会自己奔跑，从哈佛父母的育儿经讲起…》。</b></p>
            <p><b>课程名称：</b>让孩子学会自己奔跑，从哈佛父母的育儿经讲起…</p>
            <p><b>开课时间：</b>4月21日（周四）20:00-21:00</p>
            <p><b>课程形式：</b>卢勤和她的朋友们微课堂群（免费）<br />　　　　　合作转播群（付费）</p>
            <p><b>适合人群：</b>愿意为孩子创造良好家庭教育环境的家长、准家长、教育工作者。建议家长和孩子一起收听。</p>
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
