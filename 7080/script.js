var questionNO = 0;
var showTag = 1;
var score = 0;
var answer = "";
var continueAll = 0;
var continue1 = 0;
var continue2 = 0;
var continue3 = 0;
var QAJson = null;
var QAJsonArr = null;

var continueTotal = 0;
var total1 = 0;
var total2 = 0;
var total3 = 0;
var total4 = 0;
var ResultLogoArr = Array(["7080_1.jpg"], ["7080_2.jpg"], ["7080_3.jpg"], ["7080_4.jpg"], ["7080_5.jpg"], ["7080_6.jpg"], ["7080_7.jpg"], ["7080_8.jpg"], ["7080_9.jpg"]);
var radNum = 0;

var shareTitle = "你的童年完整吗？"; //标题
var shareImg = "http://game.luqinwenda.com/images/logo70.jpg"; //图片
var shareContent = '你的童年完整吗'; //简介
var shareLink = "http://game.luqinwenda.com/7080/default.aspx"; //链接

$(document).ready(function () {
    //if (!browserRedirect()) {
    //    document.write('暂不支持当前版本');
    //    document.close();
    //    return false;
    //}
    
    $.ajax({
        type: "GET",
        async: false,
        url: "http://game.luqinwenda.com/api/guess7080.aspx?season=7080",
        success: function (data) {
            var jsonData = JSON.parse(data);
            var gameData = jsonData.game;
            QAJsonArr = gameData.questions;
        }
    });
    
    //初始化数据
    QAJson = QAJsonArr[questionNO];
    fillData(QAJson);

    $("#retryA").click(function() {
        location.href = "page.aspx";
    });

    //随机结果图片logo
    radNum = Math.round(Math.random() * 8);
    $('#resultLogoImg').attr("src", "images/" + ResultLogoArr[radNum]);
});

//确定/跳过
function submitBtn() {
    $("#btnSubmit").unbind("click");
    $("#btnSubmit").css("color", "#999");
    var inputVal = '';
    $('.grid a').each(function() {
        inputVal += $(this).html();
    });

    if (inputVal == answer) {
        showInfo("<span style='color:#009933'>恭喜你,回答正确</span>");
        $('#addScore').html("＋10");
        score += 10;
        

        continueAll++;
        $('#addScore').css('display', 'block');
        $('#addScore').animate({
            top: '3px'
        }, "normal");
        $("#addScore").fadeOut(500, function () {
            $('#addScore').css('top', '30px');
            $("#scoreVal").html(parseInt($("#scoreVal").html()) + parseInt($('#addScore').html().substring(1)));
        });
        if (questionNO == 9 && continueTotal < continueAll) {
            continueTotal = continueAll;
        }
    }
    else {
        if (continueTotal < continueAll)
            continueTotal = continueAll;
        continueAll = 0;
        continue1 = 0;
        continue2 = 0;
        continue3 = 0;
        showInfo("<span style='color:#990000'>很遗憾,回答错误</span>");
    }
    questionNO++;

    $('#PromptRightLi img').attr('src', QAJson.promptimg);
    $('#Qcontent').html(QAJson.question);
    
    if (questionNO < QAJsonArr.length) {
        QAJson = QAJsonArr[questionNO];
        setTimeout('fillData(QAJson);', 1500);
    }
    else {
        showResult();
    }
}

//填充数据
function fillData(QAJson) {
    //alert(QAJson);
    $("#btnSubmit").bind('click', submitBtn);
    $("#btnSubmit").css("color", "#fff");
    var i = 0;
    showTag = 1;
    answer = QAJson.answer;
    $("#QANum").html(QAJson.id);
    $("#currentNum").html(questionNO+1);

    $('#PromptRightLi img').attr('src', QAJson.promptimg);
    $('#Qcontent').html(QAJson.question);

    var inputGrid = '';
    for (i = 0; i < QAJson.answercount; i++) {
        inputGrid += "<a onclick='delAnswer(this);'>　</a>";
    }
    $('.input_grid div').eq(0).html(inputGrid);
    var changeGrid = '';
    for (i = 0; i < QAJson.options.length; i++) {
        changeGrid += "<a id='change_" + i + "' onclick=\"changeAnswer(this);\" data=" + i + " ischange='0'>" + QAJson.options[i] + "</a>";
        if (i > 0 && (i + 1) % 8 == 0)
            changeGrid += "<br />";
    }
    $('.change_grid').html(changeGrid);
    changeButton();
}

//选择答案
function changeAnswer(changeObj) {
    var obj = $(changeObj);
    var changeVal = obj.html();
    if (obj.attr('ischange') == "0") {
        $('.grid a').each(function() {
            if ($(this).html() == '' || $(this).html() == '　') {
                $(this).html(changeVal);
                $(this).attr('data', obj.attr('data'));
                $(this).bind('click', function() {
                    delAnswer(this);
                });
                obj.css('background', '#676767');
                obj.css('color', '#fff');
                obj.attr('ischange', '1');
                return false;
            }
        });
    }
    else {
        //取消选择
        obj.css('background', '#fff');
        obj.css('color', '#000');
        obj.attr('ischange', '0');
        $('.grid a').each(function() {
            if ($(this).attr('data') == $(obj).attr('data')) {
                $(this).html("　");
                $(this).removeAttr('data');
                //$(this).removeAttr('onclick');
                return false;
            }
        });
    }
    changeButton();
}

//删除答案
function delAnswer(obj) {
    if ($(obj).html() != '' && $(obj).html() != '　' && $(obj).attr('data')) {
        $('.change_grid a').each(function() {
            if ($(this).attr('data') == $(obj).attr('data')) {
                $(this).css('background', '#fff');
                $(this).css('color', '#000');
                $(this).attr('ischange', '0');
                return false;
            }
        });
        $(obj).html('　');
        $(obj).removeAttr('data');
    }
    changeButton();
}
//提交按钮改变
function changeButton() {
    var isfull = 1;
    $('.grid a').each(function() {
        if ($(this).html() == '' || $(this).html() == '　')
            isfull = 0;
    });

    if (isfull == 1) {
        $("#btnSubmit").css('background', '#990000');
        $("#btnSubmit").css('border', '1px solid #990000');
        $("#btnSubmit").html("确认");
    }
    else {
        $("#btnSubmit").css('background', '#676767');
        $("#btnSubmit").css('border', '1px solid #676767');
        $("#btnSubmit").html("跳过");
    }
}

//加分效果
function showInfo(info) {
    $('.openInfo a').eq(0).html(info);
    $('.openInfo').fadeIn(800);
    $('.openInfo').fadeOut(800);
}


function shareBtn() {
    $("#showShare").show();
}

function showResult() {
    $("#gameResult").show();
    var str_content = '';
    if (score < 10) {
        $('#sp_content').html("经鉴定，你从来就没有过童年！<br/>80分以上有惊喜呦！");
        str_content = "得分" + score + "，我没有过童年！"
    }
    else if (score >= 10 && score < 30) {
        $('#sp_content').html("小盆友，你有过童年吗！！！<br/>80分以上有惊喜呦！");
        str_content = "得分" + score + "，我的童年让狗吃了"
    }
    else if (score >= 30 && score < 60) {
        $('#sp_content').html("你的童年很丰富！<br/>80分以上有惊喜呦！");
        str_content = "得分" + score + "，我的童年很精彩！"
    }
    else if (score >= 60 && score < 70) {
        $('#sp_content').html("你的童年很完整！<br/>80分以上有惊喜呦！");
        str_content = "得分" + score + "，我有个很完整的童年！"
    }
    else if (score >= 70 && score < 90) {
        
        if (score == 80) {
            $('#sp_content').html("经鉴定，你有个非常完美的童年！<br/>恭喜你获得2元抵用券<br/>分享至朋友圈<br/>并截图发到“卢勤问答”订阅号，领用抵用券。");
        }
        else {
            $('#sp_content').html("经鉴定，你有个非常完美的童年！<br/>80分以上有惊喜呦！");
        }
        str_content = "得分" + score + "，我有个很完美的童年！"
    }
    else if (score >= 90) {
        $('#sp_content').html("你的童年里除了吃喝玩乐还有别的吗？<br/>恭喜你获得2元抵用券<br/>分享至朋友圈<br/>并截图发到“卢勤问答”订阅号，领用抵用券。");
        str_content = "得分" + score + "，我是在吃喝玩乐中长大的！"
    }
    else if (score == 100) {
        $('#sp_content').html("你的童年里除了吃喝玩乐还有别的吗？<br/>恭喜你获得5元抵用券<br/>分享至朋友圈<br/>并截图发到“卢勤问答”订阅号，领用抵用券。");
        str_content = "得分" + score + "，我是在吃喝玩乐中长大的！"
    }

    $('#sp_score').html(score);
    shareImg = 'http://game.luqinwenda.com/7080/images/' + ResultLogoArr[radNum];
    shareContent = str_content;
}

