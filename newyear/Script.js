
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

    if ((openCount + parseInt(rC)) == 9)
        $('#progressFill').css({ width: "100%" });
    else
        $('#progressFill').css({ width: proTotal + "%" });

}

function bindGiftList() {
    var giftedStr = "";
    var giftnoStr = "";

    //$('#giftedList').html(giftedStr);
    //$('#giftnoList').html(giftnoStr);
}

var clickcount = 0;
function helpYou() {
    $('#giftCode').show();
    $('.modal-header').show();
    $('.modal-footer').show();

    if (isHelp == "0") {
        $('#giftText').html("您已帮助过TA拆礼盒，每人只能帮助一次");
        $('#giftCode').hide();
        $('.modal-header').hide();
        $('#myModal').modal('show');
        return;
    }

    var codeArr = ['http://game.luqinwenda.com/images/dyh_code_min.jpg', 'http://game.luqinwenda.com/newyear/images/zxjj_code.jpg'];
    $('#giftText').html('长按二维码，关注“卢勤问答平台”，回复礼盒号码，帮TA拆礼盒');
    $('#giftCode').attr('src', codeArr[0]);

    if (QueryString("id") != null) {
        if (openCount == 2 || openCount == 4) {
            $('#giftText').html('长按二维码，关注“知心姐姐团队”，帮TA拆礼盒');
            $('#giftCode').attr('src', codeArr[1]);
            if (clickcount == 0) {
                clickcount = 1;
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "http://game.luqinwenda.com/api/new_year_box_support.aspx",
                    data: { token: Token, id: QueryString("id") },
                    success: function (data) {
                        var obj = eval('(' + data + ')');
                        if (obj.status == 1) {
                            $('#giftText').html("您已帮助过TA拆礼盒，每人只能帮助一次");
                            $('#giftCode').hide();
                            $('.modal-header').hide();
                            $('#myModal').modal('show');
                            return;
                        }
                    }
                });
            }
        }
        $('.modal-footer').hide();
    }
    else {
        $('#giftText').html('请将当前页面发送给朋友或者发送到朋友圈，让你的朋友关注下方二维码，10-30个关注即可开启一个礼盒');
        $('#giftCode').hide();
        $('.modal-header').hide();
    }
    
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
        success: function (data) {
            var obj = eval('(' + data + ')');
            if (obj.status == 1) {
                $('#giftText').html("这是您朋友的礼盒您不能开启，请点击“领取我的礼盒”按钮");
                $('#giftCode').hide();
                $('.modal-header').hide();
                $('.modal-footer').show();
                $('#myModal').modal('show');
            }
            else {
                //$('#giftText').html("恭喜您，获得" + giftArr[openCount]);
                $('#giftCode').hide();
                $('.modal-header').hide();
                $('.modal-footer').show();
                $('#myModal').modal('show');
                openCount++;
                remainCount -= getCountArr[openCount];
                fillProgress();
                bindGiftList();
            }
        }
    });
}