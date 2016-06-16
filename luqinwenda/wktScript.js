
var ssset = 0;
var stopindex = 1;
var direction = "";
var cookieName = "voiceReaded" + QueryString('roomid');
var winWidth = document.body.clientWidth;
var winHeight = document.body.clientHeight;
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
    if ($('#audio_bg'))
        changAudioBg();
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
    //document.getElementById("bottomDiv").scrollIntoView(true);
    var movepx = $('#feed_file_list').css('height').replace("px", "");
    $wd = $('#mydiv');
    $wd.scrollTop($wd.scrollTop() + parseInt(movepx));
}

function scrollPage() {
    //document.getElementById("bottomDiv").scrollIntoView(true);
    var movepx = $('.feed_file_list li:last').css('height').replace("px", "");
    $wd = $('#mydiv');
    $wd.scrollTop($wd.scrollTop() + parseInt(movepx) + 10);
}

function after_append(content) {
    $('.feed_file_list li:last').after(content);
    scrollPage();
}

function inputText(parentid, callback) {
    if ($('#textContent').html().Trim() != "") {
        submitInput('text', encodeURIComponent($('#textContent').html()), parentid, callback);
        $('#textContent').html("");
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
            if ($("#textContent"))
                $("#textContent").html("");
            //fillAnswer();
            if (callback && callback != '')
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

//查看结果
function replace_em(str) {
    //str = str.replace(/\</g, '&lt;');
    //str = str.replace(/\>/g, '&gt;');
    //str = str.replace(/\n/g, '<br/>');
    //str = str.replace(/\[em_([0-9]*)\]/g, '<img src="face/$1.png" border="0" style="width:auto;" />');
    return str;
}

function fomatLi(chatline) {
    var nickName = chatline.nick;
    var userAvatar = chatline.avatar;
    var liItem = "";
    if (userAvatar == '')
        userAvatar = '/images/noAvatar.jpg';
    if (nickName == '')
        nickName = '家长';
    switch (chatline.message_type) {
        case "text":
            {
                //if ($.inArray(chatline.user_id.toString(), expertArr) >= 0)
                if (chatline.user_id.toString() == userid.toString())
                    liItem = String.format(textRight, userAvatar, chatline.message_content, strTohoursecond(chatline.create_date), chatline.user_id.toString());
                else
                    liItem = String.format(textLeft, userAvatar, nickName, chatline.message_content, strTohoursecond(chatline.create_date), "", "", chatline.user_id.toString());
            }
            break;
        case "voice":
            {
                var vlen = parseInt(chatline.voice_length) * 3;
                if (vlen < 80)
                    vlen = 80;
                //if ($.inArray(chatline.user_id.toString(), expertArr) >= 0)
                if (chatline.user_id.toString() == userid.toString())
                    liItem = String.format(voiceRight, userAvatar, chatline.message_content, voiceIndex, (parseInt(voiceIndex) + 1).toString(), chatline.voice_length, "width:" + vlen + "px", strTohoursecond(chatline.create_date));
                else
                    liItem = String.format(voiceLeft, userAvatar, nickName, chatline.message_content, voiceIndex, (parseInt(voiceIndex) + 1).toString(), chatline.voice_length, "width:" + vlen + "px", strTohoursecond(chatline.create_date));

                voiceIndex = (parseInt(voiceIndex) + 1).toString();
            }
            break;
        case "image":
            {
                //if ($.inArray(chatline.user_id.toString(), expertArr) >= 0)
                var content = '<a id="chat_' + chatline.id + '" title="" href="' + chatline.message_content.replace('_thumb', '_new') + '"><img src="' + chatline.message_content + '" /></a><script type="text/javascript">$(document).ready(function() { $("#chat_' + chatline.id + '").imgbox({"speedIn": 0, "speedOut": 0, "alignment": "center", "overlayShow": true, "allowMultiple": false, "padding": 0 }); });</script>';
                if (chatline.user_id.toString() == userid.toString())
                    liItem = String.format(textRight, userAvatar, content, strTohoursecond(chatline.create_date));
                else
                    liItem = String.format(textLeft, userAvatar, nickName, content, strTohoursecond(chatline.create_date), "", "");
            }
            break;
        default:
    }
    return liItem;
}


function fillHeader() {
    var headA = '<a style="background:url({0}) no-repeat; background-size:40px;"></a>';
    var headImage = "";
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
                    headImage = '/images/noAvatar.jpg';
                    if (chatuser.userinfo && chatuser.userinfo.headimgurl)
                        headImage = chatuser.userinfo.headimgurl;
                    if (chatuser.user_id == userid)
                        currentUser = String.format(headA, headImage);
                    else
                        userlist += String.format(headA, headImage);
                }
                if (currentUser == '')
                    currentUser = String.format(headA, "/images/noAvatar.jpg");
                $('.header-loginuser').html(currentUser);
                $('.header-userlist').html(userlist);
                $('#personCount').html(data.count);
            }
        }
    });
}

//function Redirect(m)
//{
//    if (m == 1)
//        location.href = 'Default.aspx?token=' + token + '&roomid=' + roomid;
//    else
//        location.href = 'QuestionList.aspx?token=' + token + '&roomid=' + roomid;;
//}

function recordUserAgent(uid, roomid) {
    if (!navigator.userAgent.match(/(iPhone|iPod|Android|ios|iPad)/i)) {
        return;
    }
    if (getCookie('userAgent') != null)
        return;
    $.ajax({
        type: "POST",
        async: false,
        url: "recordUserAgent.ashx",
        data: { userid: uid, roomid: roomid, useragent: navigator.userAgent.toString() },
        success: function (data) {
            setCookie('userAgent', '1', 60 * 10);
        }
    });
}
