
var lasttime = '';
var index = 1;
function fillList() {
    $.ajax({
        type: "GET",
        async: false,
        url: "http://192.168.1.38:8002/api/chat_timeline_list.aspx",
        data: { roomid: 1, token: token },
        dataType: "json",
        success: function (data) {
            var inHtml = '';
            for (var i = 0; i < data.chat_data.length; i++) {
                if (data.chat_data[i].chat_voice_mp3 != '') {
                    inHtml += '<li><div id="jquery_jplayer_' + index + '" class="jp-jplayer"></div><div style="background:url(images/jplayerleft.png); width: 6px; height: 36px; float: left; position: absolute;"></div><div id="jp_container_' + index
                        + '" class="jp-audio" role="application" aria-label="media player" onclick=\'changePlay("' + index + '");\' style="float:left;"><a id="a_jp_play_' + index + '" class="jp-play" role="button" tabindex="0"><span class="jplay_play"></span></a><a id="a_jp_stop_' + index
                        + '" class="jp-stop" style="display: none;" role="button" tabindex="0"><span class="jplay_stop"></span></a><div class="jp-duration" dataid="' + index + '" role="timer" aria-label="duration" style="display: none;"></div></div><div id="time_' + index + '" style="float:left; line-height:36px; margin-left:8px;"></div><div style="clear:both;"></div><script type="text/javascript">$("#jquery_jplayer_' + index
                        + '").jPlayer({ready: function () {$(this).jPlayer("setMedia", {mp3: "' + data.chat_data[i].chat_voice_mp3 + '"});},play: function () {$(this).jPlayer("stopOthers");},ended: function () { changePlay("' + index + '"); $("#jquery_jplayer_' + (index + 1) + '").jPlayer("play"); changePlay("' + (index + 1)
                        + '"); },swfPath: "__THEME__/js",supplied: "mp3",cssSelectorAncestor: "#jp_container_' + index + '",wmode: "window",globalVolume: true,useStateClassSkin: true,autoBlur: false,smoothPlayBar: true,keyEnabled: true});</script></li>';
                    index++;
                }
            }
            lasttime = data.chat_data[data.chat_data.length - 1].chat_createtime;
            //$('.feed_file_list li:last').after(inHtml);

        }
    });
}

function showTime() {
    $('.jp-duration').each(function () {
        alert($(this).html());
        //alert($(this).attr('dataid'));
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



function inputText()
{
    if ($('#textContent').val().Trim() != "") {
        alert("123");
        submitInput('text', $('#textContent').val());
    }
}

function submitInput(type,content) {
    $.ajax({
        type: "GET",
        async: false,
        url: "http://192.168.1.38:8002/api/chat_timeline_publish.aspx",
        data: { type: type, token: token, roomid: roomid, content: content },
        dataType: "json",
        success: function (data) {

        }
    });
}