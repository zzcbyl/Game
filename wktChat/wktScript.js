
var voice = {
    localId: '',
    serverId: ''
};
wx.ready(function () {

    
    // 4 音频接口
    // 4.2 开始录音
    document.querySelector('#startRecord').onclick = function () {
        startRecord();
    };

    // 4.3 停止录音
    document.querySelector('#stopRecord').onclick = function () {
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

                $.ajax({
                    type: "GET",
                    async: false,
                    url: "http://192.168.1.38:8002/wktChat/wktHandler.ashx",
                    data: { type: "insert", voiceid: voice.serverId },
                    dataType: "json",
                    success: function (data) {
                        
                    }
                });
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

