wx.config({
    debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
    appId: appid, // 必填，公众号的唯一标识
    timestamp: timestamp, // 必填，生成签名的时间戳
    nonceStr: noncestr, // 必填，生成签名的随机串
    signature: shaparam, // 必填，签名，见附录1
    jsApiList: [
            'onMenuShareTimeline',
            'onMenuShareAppMessage',
            'onMenuShareQQ',
            'onMenuShareWeibo']
});

wx.ready(function () {

    //分享到朋友圈
    wx.onMenuShareTimeline({
        title: descContent, // 分享标题
        link: lineLink, // 分享链接
        imgUrl: imgUrl, // 分享图标
        success: function () {
            // 用户确认分享后执行的回调函数
            //alert("asdf");
            //location.href = "shareResult.aspx?openid=" + QueryString("openid") + "&preopenid=" + QueryString("preopenid");
        }
    });

    //分享给朋友
    wx.onMenuShareAppMessage({
        title: shareTitle, // 分享标题
        desc: descContent, // 分享描述
        link: lineLink, // 分享链接
        imgUrl: imgUrl, // 分享图标
        success: function () {
            // 用户确认分享后执行的回调函数
            //alert("asdf");
            //location.href = "shareResult.aspx?openid=" + QueryString("openid") + "&preopenid=" + QueryString("preopenid");
        }
    });

    //分享到QQ
    wx.onMenuShareQQ({
        title: shareTitle, // 分享标题
        desc: descContent, // 分享描述
        link: lineLink, // 分享链接
        imgUrl: imgUrl // 分享图标
    });

    //分享到腾讯微博
    wx.onMenuShareWeibo({
        title: shareTitle, // 分享标题
        desc: descContent, // 分享描述
        link: lineLink, // 分享链接
        imgUrl: imgUrl // 分享图标
    });
});