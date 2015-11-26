
var resultScore = "";
var shareTitle = "你的童年完整吗？"; //标题
var imgUrl = ""; //图片
var descContent = ''; //简介
var lineLink = ""; //链接

function showResult() {
    $("#gameResult").show();

    resultScore = score;

    if (parseInt(resultScore) < 20) {
        $('#sp_content').html("经鉴定，你从来就没有过童年！");
        descContent = "得分" + resultScore + "，我没有过童年！"
    }
    else if (parseInt(resultScore) >= 20 && parseInt(resultScore) < 50) {
        $('#sp_content').html("小盆友，你有过童年吗！！！");
        descContent = "得分" + resultScore + "，我的童年让狗吃了"
    }
    else if (parseInt(resultScore) >= 50 && parseInt(resultScore) < 100) {
        $('#sp_content').html("你的童年很丰富！");
        descContent = "得分" + resultScore + "，我的童年很精彩！"
    }
    else if (parseInt(resultScore) >= 100 && parseInt(resultScore) < 150) {
        $('#sp_content').html("你的童年很完整！");
        descContent = "得分" + resultScore + "，我有个很完整的童年！"
    }
    else if (parseInt(resultScore) >= 150 && parseInt(resultScore) < 180) {
        $('#sp_content').html("经鉴定，你有个非常完美的童年！");
        descContent = "得分" + resultScore + "，我有个很完美的童年！"
    }
    else if (parseInt(resultScore) >= 180) {
        $('#sp_content').html("你的童年里除了吃喝玩乐还有别的吗？");
        descContent = "得分" + resultScore + "，我是在吃喝玩乐中长大的！"
    }

    $('#sp_score').html(resultScore);

    imgUrl = "http://game.luqinwenda.com/7080/images/" + ResultLogoArr[radNum];
    lineLink = "http://game.luqinwenda.com/7080/";
}

function shareBtn() {
    $("#showShare").show();
}



wx.config({
    debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
    appId: '<%=appId%>', // 必填，公众号的唯一标识
    timestamp: '<%=timeStamp%>', // 必填，生成签名的时间戳
    nonceStr: '<%=nonceStr%>', // 必填，生成签名的随机串
    signature: '<%=shaParam %>', // 必填，签名，见附录1
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