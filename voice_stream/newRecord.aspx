<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    public string timeStamp = "";
    public string nonceStr = "3y2wsafsda11fqf2ad0bfswf90fqs6cw7fb";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid_dingyue"];
    
    protected void Page_Load(object sender, EventArgs e)
    {
        timeStamp = Util.GetTimeStamp();
        string jsonStrForTicket = Util.GetWebContent("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token="
            + Util.GetToken() + "&type=jsapi", "get", "", "form-data");
        ticket = Util.GetSimpleJsonValueByKey(jsonStrForTicket, "ticket");
        //ticket = Util.GetTicket();
        string shaString = "jsapi_ticket=" + ticket.Trim() + "&noncestr=" + nonceStr.Trim()
            + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
        shaParam = Util.GetSHA1(shaString);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <title>微信音频接口</title>
    <link href="style.css" rel="stylesheet" />
</head>
<body ontouchstart="">
<div class="wxapi_container">
    <div class="lbox_close wxapi_form">
      <h3 id="menu-basic">基础接口</h3>
      <span class="desc">判断当前客户端是否支持指定JS接口</span>
      <button class="btn btn_primary" id="checkJsApi">checkJsApi</button>


      <h3 id="menu-voice">音频接口</h3>
      <span class="desc">开始录音接口</span>
      <button class="btn btn_primary" id="startRecord">startRecord</button>
      <span class="desc">停止录音接口</span>
      <button class="btn btn_primary" id="stopRecord">stopRecord</button>
      <span class="desc">播放语音接口</span>
      <button class="btn btn_primary" id="playVoice">playVoice</button>
      <span class="desc">暂停播放接口</span>
      <button class="btn btn_primary" id="pauseVoice">pauseVoice</button>
      <span class="desc">停止播放接口</span>
      <button class="btn btn_primary" id="stopVoice">stopVoice</button>
      <span class="desc">上传语音接口</span>
      <button class="btn btn_primary" id="uploadVoice">uploadVoice</button>
      <span class="desc">下载语音接口</span>
      <button class="btn btn_primary" id="downloadVoice">downloadVoice</button>
     
    </div>
  </div>
</body>
    <script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script>
  /*
   * 注意：
   * 1. 所有的JS接口只能在公众号绑定的域名下调用，公众号开发者需要先登录微信公众平台进入“公众号设置”的“功能设置”里填写“JS接口安全域名”。
   * 2. 如果发现在 Android 不能分享自定义内容，请到官网下载最新的包覆盖安装，Android 自定义分享接口需升级至 6.0.2.58 版本及以上。
   * 3. 常见问题及完整 JS-SDK 文档地址：http://mp.weixin.qq.com/wiki/7/aaa137b55fb2e0456bf8dd9148dd613f.html
   *
   * 开发中遇到问题详见文档“附录5-常见错误及解决办法”解决，如仍未能解决可通过以下渠道反馈：
   * 邮箱地址：weixin-open@qq.com
   * 邮件主题：【微信JS-SDK反馈】具体问题
   * 邮件内容说明：用简明的语言描述问题所在，并交代清楚遇到该问题的场景，可附上截屏图片，微信团队会尽快处理你的反馈。
   */
    wx.config({
        debug: false,
        appId: '<%=appId%>', // 必填，公众号的唯一标识
        timestamp: '<%=timeStamp%>', // 必填，生成签名的时间戳
        nonceStr: '<%=nonceStr%>', // 必填，生成签名的随机串
        signature: '<%=shaParam %>', // 必填，签名，见附录1
        jsApiList: [
          'checkJsApi',
          'onMenuShareTimeline',
          'onMenuShareAppMessage',
          'onMenuShareQQ',
          'onMenuShareWeibo',
          'onMenuShareQZone',
          'hideMenuItems',
          'showMenuItems',
          'hideAllNonBaseMenuItem',
          'showAllNonBaseMenuItem',
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
          'downloadImage',
          'getNetworkType',
          'openLocation',
          'getLocation',
          'hideOptionMenu',
          'showOptionMenu',
          'closeWindow',
          'scanQRCode',
          'chooseWXPay',
          'openProductSpecificView',
          'addCard',
          'chooseCard',
          'openCard'
        ]
    });


    wx.ready(function () {
        // 1 判断当前版本是否支持指定 JS 接口，支持批量判断
        document.querySelector('#checkJsApi').onclick = function () {
            wx.checkJsApi({
                jsApiList: [
                  'getNetworkType',
                  'previewImage'
                ],
                success: function (res) {
                    alert(JSON.stringify(res));
                }
            });
        };


        // 3 智能接口
        var voice = {
            localId: '',
            serverId: ''
        };
        // 4 音频接口
        // 4.2 开始录音
        document.querySelector('#startRecord').onclick = function () {
            alert('asdf');
            wx.startRecord({
                cancel: function () {
                    alert('用户拒绝授权录音');
                }
            });
        };

        // 4.3 停止录音
        document.querySelector('#stopRecord').onclick = function () {
            wx.stopRecord({
                success: function (res) {
                    voice.localId = res.localId;
                },
                fail: function (res) {
                    alert(JSON.stringify(res));
                }
            });
        };

        // 4.4 监听录音自动停止
        wx.onVoiceRecordEnd({
            complete: function (res) {
                voice.localId = res.localId;
                alert('录音时间已超过一分钟');
            }
        });

        // 4.5 播放音频
        document.querySelector('#playVoice').onclick = function () {
            if (voice.localId == '') {
                alert('请先使用 startRecord 接口录制一段声音');
                return;
            }
            wx.playVoice({
                localId: voice.localId
            });
        };

        // 4.6 暂停播放音频
        document.querySelector('#pauseVoice').onclick = function () {
            wx.pauseVoice({
                localId: voice.localId
            });
        };

        // 4.7 停止播放音频
        document.querySelector('#stopVoice').onclick = function () {
            wx.stopVoice({
                localId: voice.localId
            });
        };

        // 4.8 监听录音播放停止
        wx.onVoicePlayEnd({
            complete: function (res) {
                alert('录音（' + res.localId + '）播放结束');
            }
        });

        // 4.8 上传语音
        document.querySelector('#uploadVoice').onclick = function () {
            if (voice.localId == '') {
                alert('请先使用 startRecord 接口录制一段声音');
                return;
            }
            wx.uploadVoice({
                localId: voice.localId,
                success: function (res) {
                    alert('上传语音成功，serverId 为' + res.serverId);
                    voice.serverId = res.serverId;
                }
            });
        };

        // 4.9 下载语音
        document.querySelector('#downloadVoice').onclick = function () {
            if (voice.serverId == '') {
                alert('请先使用 uploadVoice 上传声音');
                return;
            }
            wx.downloadVoice({
                serverId: voice.serverId,
                success: function (res) {
                    alert('下载语音成功，localId 为' + res.localId);
                    voice.localId = res.localId;
                }
            });
        };

    });

    wx.error(function (res) {
        alert(res.errMsg);
    });

</script>

</html>
