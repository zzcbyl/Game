<%@ Page Title="" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>

<script runat="server">
    public string token = "89970452e9cf12c3dfe576e0eef8c47a10fc94a4a36a8ac60a51e9a4488bb3027e9d1499";
    public string roomid = "2";
    public int userid = 0;
    public int voiceIndex = 1;
    public string maxid = "0";
    public string domainName = System.Configuration.ConfigurationManager.AppSettings["domain_name"].ToString();

    public string timeStamp = "";
    public string nonceStr = "wsa11fiqfs2ad0ewf90fqmcwbb";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid_dingyue"];
    protected void Page_Load(object sender, EventArgs e)
    {
        token = Util.GetSafeRequestValue(Request, "token", "");
        userid = Users.CheckToken(token);
        if (userid <= 0)
        {
            string currentUrl = Request.Url.ToString();
            if (token != "")
                currentUrl = currentUrl.Replace("&token=" + token, "").Replace("?token=" + token, "");
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(currentUrl), true);
        }

        timeStamp = Util.GetTimeStamp();
        ticket = Util.GetTicket();
        string shaString = "jsapi_ticket=" + ticket.Trim() + "&noncestr=" + nonceStr.Trim()
            + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
        shaParam = Util.GetSHA1(shaString);
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="mydiv">
        <div>
            <ul id="feed_file_list" class="feed_file_list">
                <li>                    <div class="text-li">                        <div class="left-head">                            <img src="http://wx.qlogo.cn/mmopen/M13tqMABLia0mbuQSR36GgqxLRqK0ExSLIj8cEVy2pMQYR7xVwxAg5Is6Y3SiaHP03iciaQZJW1PicHhC4122Va5DSw/0" /></div>                        <div class="right-content">                            <div class="text-nick">老莫</div>                            <div class="text-content">啊岁的法撒旦2314234</div>                            <div style="position:absolute; left:65px; top:28px;"><img src="images/jt_icon_left.png" /></div>
                        </div>                        <div class="clear"></div>
                    </div>
                </li>                <li>                    <div class="text-li">                        <div class="left-head"><img src="http://wx.qlogo.cn/mmopen/M13tqMABLia0mbuQSR36GgqxLRqK0ExSLIj8cEVy2pMQYR7xVwxAg5Is6Y3SiaHP03iciaQZJW1PicHhC4122Va5DSw/0" /></div>                        <div class="right-content">                            <div class="text-nick">老莫</div>                            <div class="text-content">1234123这次vzxcvasdfasqweradfasd啊岁的法撒旦发射</div>                            <div style="position:absolute; left:65px; top:28px;"><img src="images/jt_icon_left.png" /></div>
                        </div>                        <div class="clear"></div>
                    </div>
                </li>      
                <div style="clear:both;"></div>
            </ul>
        </div>

        <div id="bottomDiv" style="height:60px; clear:both;"></div>
        <div style="position:fixed; bottom:0; left:0; width:100%; text-align:center; line-height:55px; background:#fff; z-index:100;">
            <div id="input_voice">
                <input type="button" value="开始录音" id="startRecord" style="width:100px; height:40px;" />
                <input type="button" value="停止录音" id="stopRecord" style="width:100px; height:40px; display:none;" />
            </div>
        </div>
    </div>
    <script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript">
        wx.config({
            debug: false,
            appId: '<%=appId%>', // 必填，公众号的唯一标识
            timestamp: '<%=timeStamp%>', // 必填，生成签名的时间戳
            nonceStr: '<%=nonceStr%>', // 必填，生成签名的随机串
            signature: '<%=shaParam %>', // 必填，签名，见附录1
            jsApiList: [
              'translateVoice',
              'startRecord',
              'stopRecord',
              'onVoiceRecordEnd',
              'playVoice',
              'onVoicePlayEnd',
              'pauseVoice',
              'stopVoice',
              'uploadVoice',
              'downloadVoice',
              'chooseImage',
              'previewImage',
              'uploadImage',
              'downloadImage'
            ]
        });
    </script>
</asp:Content>

