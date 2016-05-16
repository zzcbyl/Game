
var voice = {
    localId: '',
    serverId: ''
};
var image = {
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
            $("#stopRecord").hide();
            $("#startRecord").show();
            uploadVoice();
        }
    });

    function startRecord() {
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

                submitInput('voice', voice.serverId, feedid, callback);
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

    document.querySelector('#uploadImg').onclick = function () {

        wx.chooseImage({
            count: 1, // 默认9
            sizeType: ['original'], // 可以指定是原图还是压缩图，默认二者都有
            sourceType: ['album'], // 可以指定来源是相册还是相机，默认二者都有
            success: function (res) {
                image.localId = res.localIds[0]; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
                upImage();
            }
        });
    };

    function upImage() {
        wx.uploadImage({
            localId: image.localId, // 需要上传的图片的本地ID，由chooseImage接口获得
            isShowProgressTips: 1, // 默认为1，显示进度提示
            success: function (res) {
                image.serverId = res.serverId; // 返回图片的服务器端ID

                submitInput('image', image.serverId);
            }
        });
    }

});

wx.error(function (res) {
    alert(res.errMsg);
});