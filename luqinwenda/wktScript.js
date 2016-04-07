
var ssset = 0;
var stopindex = 1;
var direction = "";
var cookieName = "voiceReaded" + roomid;
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

var lasttime = '';
var index = 1;
function fillList() {
    $.ajax({
        type: "GET",
        async: false,
        url: "http://" + domainName + "/api/chat_timeline_list.aspx",
        data: { roomid: roomid, token: token, maxid: maxid, parentid: parentid },
        dataType: "json",
        success: function (data) {
            var inHtml = '';
            if (data.status == 0 && data.count > 0) {
                maxid = data.max_id;
                for (var i = 0; i < data.chat_time_line.length; i++) {
                    inHtml = "";
                    var liItem = '';
                    var chatline = data.chat_time_line[i];
                    switch (chatline.message_type) {
                        case "text":
                            {
                                liItem = String.format(textLeft, chatline.avatar, chatline.nick, chatline.message_content);
                            }
                            break;
                        case "voice":
                            {
                                var vlen = parseInt(chatline.voice_length) * 3;
                                if (vlen < 60)
                                    vlen = 60;
                                liItem = String.format(voiceLeft, chatline.avatar, chatline.nick, chatline.message_content, voiceIndex, (parseInt(voiceIndex) + 1).toString(), chatline.voice_length, "width:" + vlen + "px");
                            }
                            break;
                        default:
                    }
                    voiceIndex = (parseInt(voiceIndex) + 1).toString();
                    inHtml += "<li>" + liItem.replace("&lt;", "<").replace("&gt;", ">") + "</li>";
                    if ($('.feed_file_list li').length == 0)
                        $('.feed_file_list').html(inHtml);
                    else
                        $('.feed_file_list li:last').after(inHtml);
                    scrollPage();
                }
            }
        }
    });
}

function scrollPage() {
    var movepx = $('.feed_file_list li:last div').css('height').replace("px", "");
    $wd = $(window);
    $wd.scrollTop($wd.scrollTop() + parseInt(movepx) + 10);
}

function inputText() {
    if ($('#textContent').val().Trim() != "") {
        submitInput('text', $('#textContent').val(), 0);
        $('#textContent').val("");
    }
}

function submitInput(type, content, parentid) {
    $.ajax({
        type: "GET",
        async: false,
        url: "http://" + domainName + "/api/chat_timeline_publish.aspx",
        data: { type: type, token: token, roomid: roomid, content: content, parentid: parentid },
        dataType: "json",
        success: function (data) {
            fillList();
        }
    });
}



