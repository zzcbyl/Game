
function fillProgress() {
    var proCount = 0;
    var tolCount = 0;
    var rC = 0;
    var lsCount = remainCount;
    for (var i = openCount; i < getCountArr.length; i++) {
        var SubCount = parseInt(lsCount) - getCountArr[i];
        if (SubCount >= 0) {
            lsCount = parseInt(lsCount) - getCountArr[i];
            rC++;
        }
        else {
            tolCount = getCountArr[i];
            proCount = getCountArr[i] + SubCount;
            $('#needCount').html(parseInt(0 - SubCount));
            break;
        }
    }

    if (parseInt(rC) != 0)
        $('#spCount').html("X" + parseInt(rC));
    else
        $('#spCount').html('X0');

    var proTotal = 0;
    var maxLength = 0;
    if (tolCount == getCountArr[0]) {
        maxLength = parseInt(proCount * 2);
    }
    else {
        maxLength = parseInt(proCount / (tolCount / 10));
    }
    for (var i = 0; i < maxLength; i++) {
        proTotal += percent[i];
    }

    if ((openCount + parseInt(rC)) == 7)
        $('#progressFill').css({ width: "100%" });
    else
        $('#progressFill').css({ width: proTotal + "%" });

}

function bindGiftList() {
    var giftedStr = "";
    var giftnoStr = "";
    for (var i = 0; i < alljson.opened_box.length; i++) {
        if (i == 0 && openCount == 7)
            giftedStr += "<div style='color:#FF3C00;text-decoration:underline;' onclick='showAward();'><img style='height:15px;' src='images/gift_max.png' /> ";
        else
            giftedStr += "<div><img style='height:15px;' src='images/gift_yellow.png' /> ";
        giftedStr += alljson.opened_box[i].award_name;
        giftedStr += "</div>";
    }
    

    for (var i = alljson.un_aquire_awards.length - 1; i >= 0 ; i--) {
        if (i == alljson.un_aquire_awards.length - 1 && openCount != 9)
            giftnoStr += "<div style='color:#FF3C00;text-decoration:underline;' onclick='showAward();'><img style='height:15px;' src='images/gift_max.png' /> ";
        else
            giftnoStr += "<div><img style='height:15px;' src='images/gift_yellow.png' /> ";
        var awardlist = alljson.un_aquire_awards[i].award_list;
        for (var j = 0; j < awardlist.length; j++) {
            giftnoStr += awardlist[j].award_name;
            if (j == 0 && awardlist.length > 1)
                giftnoStr += "<br />　 ";
        }
        giftnoStr += "</div>";
    }

    $('#giftedList').html(giftedStr);
    $('#giftnoList').html(giftnoStr);
}

var clickcount = 0;
function helpYou() {
    var codeArr = ['http://game.luqinwenda.com/images/dyh_code_min.jpg', 'http://game.luqinwenda.com/newyear/images/zxjj_code.jpg'];
    

    if (QueryString("id") != null) {
        //if (openCount == 2 || openCount == 4) {
        //    $('#giftText').html('长按二维码，关注“知心姐姐团队”，帮TA拆礼盒');
        //    $('#giftCode').attr('src', codeArr[1]);
        //    if (clickcount == 0) {
        //        clickcount = 1;
        //        $.ajax({
        //            type: "GET",
        //            async: false,
        //            url: "http://game.luqinwenda.com/api/new_year_box_support.aspx",
        //            data: { token: Token, id: QueryString("id") },
        //            success: function (data) {
        //                var obj = eval('(' + data + ')');
        //                if (obj.status == 1) {
        //                    $('#giftText').html("您已帮助过TA拆礼盒，每人只能帮助一次");
        //                    $('#giftCode').hide();
        //                    $('.modal-header').hide();
        //                    $('.modal-footer').show();
        //                    $('#myModal').modal('show');
        //                    return;
        //                }
        //            }
        //        });
        //    }
        //}
        $('#giftText').html('长按二维码，关注“卢勤问答平台”，回复礼盒号码，帮TA拆礼盒');
        $('#giftCode').attr('src', codeArr[0]);
        $('.modal-header').show();
        $('.modal-footer').hide();
    }
    else {
        $('#giftText').html('请将当前页面发送给朋友或者发送到朋友圈，让你的朋友关注下方二维码，回复你的礼盒号码');
        $('#giftCode').attr('src', codeArr[0]);
        $('.modal-header').show();
        $('.modal-footer').hide();
    }
    
    $('#myModal').modal('show');
}

function showAward() {
    $('#giftText').html('<div>你需要把6个小盒子都打开才能开启这个终极大礼盒！</div><div><img src="images/award2.jpg" style="width:100%;" /></div><div>　　外观方面，“小钢炮”采用了43寸4K RGBW高清屏，LG进口IPS硬屏材质，拥有4倍于FHD、8倍于HD的像素点，4K(3840*2160)分辨率画质能达到视网膜级的视觉体验，并延续WUI的瀑布桌面设计。同时，“小钢炮”配备的遥控器支持蓝牙4.0语音，方便用户搜索节目。</div><div>　　配置方面，微鲸“小钢炮”电视采用64位四核Mstar 6A828处理器，配备Mali-450四核高端图像处理器，支持64位操作系统和软件，在线与本地4K视频硬解码能力高达每秒60帧，观看体验更加流畅。“小钢炮”机身内置独家专利的独立腔体Hi-Fi音响，它采用羊毛振膜，让音质更加真实细腻。</div><div>　　在内容方面，微鲸整合了阿里、腾讯、CMC等多家资源，还与芒果TV的综艺内容打包进微鲸会员。目前，微鲸片库已收录超8500部电影，每年在线更新超600部新片，覆盖各大卫视热播剧、热门综艺节目，中超、欧冠等精彩赛事同步。</div>');
    $('#giftCode').hide();
    $('.modal-header').show();
    $('.modal-footer').hide();
    $('#myModal').modal('show');
}

function getMyGift() {
    $('#giftCode').show();
    $('.modal-header').show();
    $('#giftText').html('长按指纹识别二维码，关注“卢勤问答平台”，点击下方菜单“商城”-“礼盒”领取属于你的新年礼盒');
    $('#giftCode').attr('src', "http://game.luqinwenda.com/images/dyh_code1.jpg");
    $('.modal-footer').hide();
    $('#myModal').modal('show');
}

function OpenBox(boxid) {
    $.ajax({
        type: "GET",
        async: false,
        url: "http://game.luqinwenda.com/api/new_year_box_open_box.aspx",
        data: { token: Token, boxId: boxid },
        dataType: "json",
        success: function (data) {
            var obj = data;
            if (obj.status == 1) {
                $('#giftText').html("这是您朋友的礼盒您不能开启，请点击“领取我的礼盒”按钮");
                $('#giftCode').hide();
                $('.modal-header').hide();
                $('.modal-footer').show();
                $('#myModal').modal('show');
            }
            else {
                alljson = obj;
                if (openCount == 6)
                    $('#giftText').html("恭喜您，获得 <span style='color:#FF3C00; font-weight:bold; font-size: 20pt;'>" + obj.opened_box[0].award_name + "</span>");
                else
                    $('#giftText').html("恭喜您，获得 <span style='color:#FF3C00; font-weight:bold; font-size: 12pt;'>" + obj.opened_box[0].award_name + "</span>");
                $('#giftCode').hide();
                $('.modal-header').hide();
                $('.modal-footer').show();
                $('#myModal').modal('show');
                remainCount -= getCountArr[openCount];
                openCount++;
                fillProgress();
                bindGiftList();
            }
        }
    });
}