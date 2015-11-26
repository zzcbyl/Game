
var resultScore = "";
var rate = "50%";
var shareContent = '';
var scoreid = 0;

function showResult() {
    $("#gameResult").show();

    resultScore = score;

    if (parseInt(resultScore) < 20) {
        $('#sp_content').html("经鉴定，你从来就没有过童年！");
        shareContent = "得分" + resultScore + "，我没有过童年！"
    }
    else if (parseInt(resultScore) >= 20 && parseInt(resultScore) < 50) {
        $('#sp_content').html("小盆友，你有过童年吗！！！");
        shareContent = "得分" + resultScore + "，我的童年让狗吃了"
    }
    else if (parseInt(resultScore) >= 50 && parseInt(resultScore) < 100) {
        $('#sp_content').html("你的童年很丰富！");
        shareContent = "得分" + resultScore + "，我的童年很精彩！"
    }
    else if (parseInt(resultScore) >= 100 && parseInt(resultScore) < 150) {
        $('#sp_content').html("你的童年很完整！");
        shareContent = "得分" + resultScore + "，我有个很完整的童年！"
    }
    else if (parseInt(resultScore) >= 150 && parseInt(resultScore) < 180) {
        $('#sp_content').html("经鉴定，你有个非常完美的童年！");
        shareContent = "得分" + resultScore + "，我有个很完美的童年！"
    }
    else if (parseInt(resultScore) >= 180) {
        $('#sp_content').html("你的童年里除了吃喝玩乐还有别的吗？");
        shareContent = "得分" + resultScore + "，我是在吃喝玩乐中长大的！"
    }

    $('#sp_score').html(resultScore);


    window.shareData.imgUrl = "http://game.luqinwenda.com/7080/images/" + ResultLogoArr[radNum];
    window.shareData.timeLineLink = "http://game.luqinwenda.com/7080/";
    window.shareData.sendFriendLink = "http://game.luqinwenda.com/7080/";
    window.shareData.weiboLink = "http://game.luqinwenda.com/7080/"

    window.shareData.tTitle = shareContent;
    window.shareData.tContent = shareContent;
    window.shareData.fTitle = shareContent;
    window.shareData.fContent = shareContent;
    window.shareData.wContent = shareContent;
}

function shareBtn() {
    $("#showShare").show();
}

document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
    window.shareData = {
        "imgUrl": "http://game.luqinwenda.com/7080/images/" + ResultLogoArr[radNum],
        "timeLineLink": "http://game.luqinwenda.com/7080/",
        "sendFriendLink": "http://game.luqinwenda.com/7080/",
        "weiboLink": "http://game.luqinwenda.com/7080/",
        "tTitle": shareContent,
        "tContent": shareContent,
        "fTitle": shareContent,
        "fContent": shareContent,
        "wContent": shareContent
    };

    // 发送给好友 
    WeixinJSBridge.on('menu:share:appmessage', function (argv) {
        WeixinJSBridge.invoke('sendAppMessage', {
            "img_url": window.shareData.imgUrl, // 
            "img_width": "640", // 
            "img_height": "640",
            "link": window.shareData.sendFriendLink,
            "desc": window.shareData.fContent,
            "title": window.shareData.fTitle
        }, function (res) {
            //_report('send_msg', res.err_msg);
        });
    });

    // 分享到朋友圈 
    WeixinJSBridge.on('menu:share:timeline', function (argv) {
        WeixinJSBridge.invoke('shareTimeline', {
            "img_url": window.shareData.imgUrl,
            "img_width": "640",
            "img_height": "640",
            "link": window.shareData.timeLineLink,
            "desc": window.shareData.tContent,
            "title": window.shareData.tTitle
        }, function (res) {
            //_report('timeline', res.err_msg);
        });
    });

}, false);


