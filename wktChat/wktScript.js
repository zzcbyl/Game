

$(document).ready(function () {
    var movepx = $('#mydiv').css('height').replace("px", "");
    $wd = $(window);
    $wd.scrollTop($wd.scrollTop() + parseInt(movepx));
    
    var wh = document.body.clientWidth;
    $("#textContent").css("width", (wh - 130).toString() + "px");

    setInterval("fillList()", 5000);
});

var ssset = 0;
var stopindex = 1;
var direction = "";
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

var lasttime = '';
var index = 1;
function fillList() {
    $.ajax({
        type: "GET",
        async: false,
        url: "http://" + domainName + "/api/chat_timeline_list.aspx",
        data: { roomid: 1, token: token, maxid: maxid },
        dataType: "json",
        success: function (data) {
            var inHtml = '';
            if (data.status == 0 && data.count > 0) {
                maxid = data.max_id;
                for (var i = 0; i < data.chat_time_line.length; i++) {
                    var liItem = '';
                    var chatline = data.chat_time_line[i];
                    switch (chatline.message_type) {
                        case "text":
                            {
                                if (chatline.user_id == userid) {
                                    liItem = String.format(textRight, chatline.avatar, chatline.message_content);
                                } else {
                                    liItem = String.format(textLeft, chatline.avatar, chatline.nick, chatline.message_content);
                                }
                            }
                            break;
                        case "voice":
                            {
                                var vlen = parseInt(chatline.voice_length) * 3;
                                if (vlen < 80)
                                    vlen = 80;
                                if (chatline.user_id == userid) {
                                    liItem = String.format(voiceRight, chatline.avatar, chatline.message_content, voiceIndex, (parseInt(voiceIndex) + 1).toString(), chatline.voice_length, "width:" + vlen + "px");
                                } else {
                                    liItem = String.format(voiceLeft, chatline.avatar, chatline.nick, chatline.message_content, voiceIndex, (parseInt(voiceIndex) + 1).toString(), chatline.voice_length, "width:" + vlen + "px");
                                }
                            }
                            break;
                        default:
                    }
                    inHtml += "<li>" + liItem.replace("&lt;", "<").replace("&gt;", ">") + "</li>";
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
        submitInput('text', $('#textContent').val());
        $('#textContent').val("");
    }
}

function submitInput(type, content) {
    $.ajax({
        type: "GET",
        async: false,
        url: "http://" + domainName + "/api/chat_timeline_publish.aspx",
        data: { type: type, token: token, roomid: roomid, content: content },
        dataType: "json",
        success: function (data) {
            fillList();
        }
    });
}


var voice = {
    localId: '',
    serverId: ''
};
wx.ready(function () {
    // 4 音频接口
    // 4.2 开始录音
    document.querySelector('#startRecord').onclick = function () {
        $("#stopRecord").show();
        $("#startRecord").hide();
        startRecord();
    };

    // 4.3 停止录音
    document.querySelector('#stopRecord').onclick = function () {
        $("#stopRecord").hide();
        $("#startRecord").show();
        stopRecord();
    };

    // 4.4 监听录音自动停止
    wx.onVoiceRecordEnd({
        complete: function (res) {
            voice.localId = res.localId;
            //alert('录音时间已超过一分钟');
            uploadVoice();
        }
    });

    function startRecord()
    {
        wx.startRecord({
            cancel: function () {
                alert('用户拒绝授权录音');
            }
        });
    }

    function stopRecord() {
        wx.stopRecord({
            success: function (res) {
                voice.localId = res.localId;
                //alert(res.localId);
                uploadVoice();
            },
            fail: function (res) {
                alert(JSON.stringify(res));
            }
        });
    }

    function uploadVoice() {
        wx.uploadVoice({
            localId: voice.localId,
            success: function (res) {
                //alert('上传语音成功，serverId 为' + res.serverId);
                voice.serverId = res.serverId;

                submitInput('voice', voice.serverId);
            }
        });
    }

    function downVoice() {
        wx.downloadVoice({
            serverId: voice.serverId,
            success: function (res) {
                alert('下载语音成功，localId 为' + res.localId);
                voice.localId = res.localId;
            }
        });
    }

    function playVoice() {
        wx.playVoice({
            localId: voice.localId
        });
    }

    function stopVoice() {
        wx.stopVoice({
            localId: voice.localId
        });
    }


    // 4.8 监听录音播放停止
    wx.onVoicePlayEnd({
        complete: function (res) {
            //alert('录音（' + res.localId + '）播放结束');
        }
    });

    //// 4.5 播放音频
    //document.querySelector('#playVoice').onclick = function () {
    //    if (voice.localId == '') {
    //        alert('请先使用 startRecord 接口录制一段声音');
    //        return;
    //    }
    //    wx.playVoice({
    //        localId: voice.localId
    //    });
    //};

    //// 4.6 暂停播放音频
    //document.querySelector('#pauseVoice').onclick = function () {
    //    wx.pauseVoice({
    //        localId: voice.localId
    //    });
    //};

    //// 4.7 停止播放音频
    //document.querySelector('#stopVoice').onclick = function () {
    //    wx.stopVoice({
    //        localId: voice.localId
    //    });
    //};

    

    //// 4.8 上传语音
    //document.querySelector('#uploadVoice').onclick = function () {
    //    if (voice.localId == '') {
    //        alert('请先使用 startRecord 接口录制一段声音');
    //        return;
    //    }
    //    wx.uploadVoice({
    //        localId: voice.localId,
    //        success: function (res) {
    //            alert('上传语音成功，serverId 为' + res.serverId);
    //            voice.serverId = res.serverId;
    //        }
    //    });
    //};

    //// 4.9 下载语音
    //document.querySelector('#downloadVoice').onclick = function () {
    //    if (voice.serverId == '') {
    //        alert('请先使用 uploadVoice 上传声音');
    //        return;
    //    }
    //    wx.downloadVoice({
    //        serverId: voice.serverId,
    //        success: function (res) {
    //            alert('下载语音成功，localId 为' + res.localId);
    //            voice.localId = res.localId;
    //        }
    //    });
    //};

});

wx.error(function (res) {
    alert(res.errMsg);
});

