
var ssset = 0;
var stopindex = 1;
var direction = "";
var cookieName = "voiceReaded" + roomid;
var winWidth = document.body.clientWidth;
function changePlay(id, fx) {
    if ($('#a_jp_stop_' + id).css('display') == 'none') {
        stopindex = 1;
        direction = fx;
        playA();
        clearInterval(ssset)
        ssset = setInterval("playA()", 500);
        $('.jp-stop').hide();
        $('.jp-play').show();
        $('#a_jp_stop_' + id).show();
        $('#a_jp_play_' + id).hide();
        setVoiceCookie(id);
    }
    else {
        $('#a_jp_play_' + id).show();
        $('#a_jp_stop_' + id).hide();
        clearInterval(ssset)
    }
}

function playA() {
    if (stopindex == 4) stopindex = 1;
    if (direction == "R")
        $(".jplay_stop_right").attr("class", "jplay_stop_right jp-stop_right_" + stopindex);
    else
        $(".jplay_stop").attr("class", "jplay_stop jp-stop_" + stopindex);
    stopindex++;
}

function changeInput() {
    if ($('#input_voice').css("display") == "none") {
        $('#input_voice').show();
        $('#input_text').hide();
    }
    else {
        $('#input_voice').hide();
        $('#input_text').show();
    }
}

function setVoiceCookie(id) {
    $("#dot_" + id).hide();
    var cookieVal = getCookie(cookieName);
    if (cookieVal == null) {
        cookieVal = id + ",";
    }
    else {
        cookieVal += id + ",";
    }
    setCookieT(cookieName, cookieVal, 10000000000);
}

function setDots() {
    var cookieVal = getCookie(cookieName);
    //alert(cookieVal);
    if (cookieVal != null) {
        var dataID = cookieVal.split(',');
        $(".dots").each(function () {
            for (var i = 0; i < dataID.length; i++) {
                //alert($(this).attr("id"));
                if ($(this).attr("id") == "dot_" + dataID[i]) {
                    $(this).hide();
                }
            }
        });
    }
}

function scrollPage() {
    var movepx = $('.feed_file_list li:last div').css('height').replace("px", "");
    $wd = $(window);
    $wd.scrollTop($wd.scrollTop() + parseInt(movepx) + 10);
}

function inputText(parentid) {
    if ($('#textContent').val().Trim() != "") {
        submitInput('text', encodeURI($('#textContent').val()), parentid);
        $('#textContent').val("");
    }
}

function submitInput(type, content, parentid) {
    alert(token)
    $.ajax({
        type: "POST",
        async: false,
        url: "http://" + domainName + "/api/chat_timeline_publish.aspx",
        data: { type: type, token: token, roomid: roomid, content: content, parentid: parentid },
        dataType: "json",
        success: function (data) {
            fillAnswer();
        }
    });
}

function strTohoursecond(str) {
    //var currentdate = new Date(Date.parse(str.replace(/-/g, "/")));
    //return currentdate.getHours() + ":" + currentdate.getMinutes();
    var timeArr = str.split(' ')[1].split(':');
    return timeArr[0] + ":" + timeArr[1];
}


