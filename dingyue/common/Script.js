
function zanDown(obj) {
    $(obj).attr('src', 'images/zan_icon_0.png');
}
function zanUp(obj) {
    $(obj).attr('src', 'images/zan_icon_1.png');
}

function showShare() {
    if (document.documentElement.scrollTop == 0) {
        $('#showShare div').eq(1).css({ top: document.body.scrollTop + "px" });
        $('#showShare div').eq(2).css({ top: document.body.scrollTop + 40 + "px" });
    }
    else {
        $('#showShare div').eq(1).css({ top: document.documentElement.scrollTop + "px" });
        $('#showShare div').eq(2).css({ top: document.documentElement.scrollTop + 40 + "px" });
    }
    $('#showShare div').eq(0).css({ 'height': bh + 'px' });
    $('#showShare').show();
}

function shareSuccess() {
    $.ajax({
        type: "GET",
        async: false,
        url: "http://game.luqinwenda.com/api/timeline_forward.aspx",
        data: { token: Token, fatheruserid: Fatheruid, actid: 1 },
        success: function (data) {
            
        }
    });
}
