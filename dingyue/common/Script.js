
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

}
