
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

function scrollPageBottom() {
    var movepx = $('#mydiv').css('height').replace("px", "");
    $wd = $(window);
    $wd.scrollTop($wd.scrollTop() + parseInt(movepx));
}

function scrollPage() {
    var movepx = $('.feed_file_list li:last').css('height').replace("px", "");
    $wd = $(window);
    $wd.scrollTop($wd.scrollTop() + parseInt(movepx) + 10);
}

function inputText(parentid, callback) {
    if ($('#textContent').val().Trim() != "") {
        submitInput('text', encodeURI($('#textContent').val()), parentid, callback);
        $('#textContent').val("");
    }
}

function submitInput(type, content, parentid, callback) {
    $.ajax({
        type: "POST",
        async: false,
        url: "http://" + domainName + "/api/chat_timeline_publish.aspx",
        data: { type: type, token: token, roomid: roomid, content: content, parentid: parentid },
        dataType: "json",
        success: function (data) {
            //fillAnswer();
            eval(callback + "()");
        }
    });
}

function strTohoursecond(str) {
    //var currentdate = new Date(Date.parse(str.replace(/-/g, "/")));
    //return currentdate.getHours() + ":" + currentdate.getMinutes();
    var timeArr = str.split(' ')[1].split(':');
    return timeArr[0] + ":" + timeArr[1];
}


function fomatLi(chatline) {
    var liItem = "";
    switch (chatline.message_type) {
        case "text":
            {
                if ($.inArray(chatline.user_id.toString(), expertArr) >= 0)
                    liItem = String.format(textRight, chatline.avatar, chatline.message_content, strTohoursecond(chatline.update_date));
                else
                    liItem = String.format(textLeft, chatline.avatar, chatline.nick, chatline.message_content, strTohoursecond(chatline.update_date), "", "");
            }
            break;
        case "voice":
            {
                var vlen = parseInt(chatline.voice_length) * 3;
                if (vlen < 60)
                    vlen = 60;
                if ($.inArray(chatline.user_id.toString(), expertArr) >= 0)
                    liItem = String.format(voiceRight, chatline.avatar, chatline.message_content, voiceIndex, (parseInt(voiceIndex) + 1).toString(), chatline.voice_length, "width:" + vlen + "px", strTohoursecond(chatline.update_date));
                else
                    liItem = String.format(voiceLeft, chatline.avatar, chatline.nick, chatline.message_content, voiceIndex, (parseInt(voiceIndex) + 1).toString(), chatline.voice_length, "width:" + vlen + "px", strTohoursecond(chatline.update_date));

                voiceIndex = (parseInt(voiceIndex) + 1).toString();
            }
            break;
        default:
    }
    return liItem;
}


function fillHeader() {
    var headA = '<a style="background:url({0}) no-repeat; background-size:40px;"></a>';
    var currentUser = '';
    var userlist = '';
    $.ajax({
        type: "GET",
        async: false,
        url: "http://" + domainName + "/api/chat_room_userlist.aspx",
        data: { roomid: roomid, token: token, random: Math.random() },
        dataType: "json",
        success: function (data) {
            if (data.status == 0) {
                for (var i = 0; i < data.chatUserList.length; i++) {
                    var chatuser = data.chatUserList[i];
                    if (chatuser.user_id == userid) {
                        currentUser = String.format(headA, chatuser.userinfo.headimgurl);

                    }
                    userlist += String.format(headA, chatuser.userinfo.headimgurl);
                }

                $('.header-loginuser').html(currentUser);
                $('.header-userlist').html(userlist);
                $('#personCount').html(data.count);
            }
        }
    });
}

function Redirect(m)
{
    if (m == 1)
        location.href = 'Default.aspx?token=' + token;
    else
        location.href = 'QuestionList.aspx?token=' + token;
}
