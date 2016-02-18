<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    public string timeStamp = "";
    public string nonceStr = "3y2dwsafsda11afqf2ad0bfswsf90fqs6cw7fb";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid_dingyue"];
    protected void Page_Load(object sender, EventArgs e)
    {

        timeStamp = Util.GetTimeStamp();
        ticket = Util.GetTicket();
        string shaString = "jsapi_ticket=" + ticket.Trim() + "&noncestr=" + nonceStr.Trim()
            + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
        shaParam = Util.GetSHA1(shaString);

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="../script/jquery-2.1.1.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <input id="uploadImg" type="button" value="上传图片" />
    </div>
    </form>
</body>
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

        var image = {
            localId: '',
            serverId: ''
        };

        wx.ready(function () {
            // 4 音频接口
            // 4.2 开始录音
            document.querySelector('#uploadImg').onclick = function () {
                
                wx.chooseImage({
                    count: 1, // 默认9
                    sizeType: ['original'], // 可以指定是原图还是压缩图，默认二者都有
                    sourceType: ['album'], // 可以指定来源是相册还是相机，默认二者都有
                    success: function (res) {
                        image.localId = res.localIds[0]; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
                        upImage();
                    }
                });
            };

            function upImage()
            {
                wx.uploadImage({
                    localId: image.localId, // 需要上传的图片的本地ID，由chooseImage接口获得
                    isShowProgressTips: 1, // 默认为1，显示进度提示
                    success: function (res) {
                        image.serverId = res.serverId; // 返回图片的服务器端ID
                        alert(image.serverId);
                    }
                });
            }
        });

    </script>
</html>
