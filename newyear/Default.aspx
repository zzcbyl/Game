<%@ Page Language="C#" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<!DOCTYPE html>

<script runat="server">
    public string token = "";// "40cb055dfc2f090fe90426dc15e571300a1bc2a99575eac106f50bd04febf4031bcb13ac";
    public string id = "";
    public string totalCount = "0";
    public string surplusCount = "0";
    public string openedBoxList = "";
    
    public string timeStamp = "";
    public string nonceStr = "3y2wsqsa121fqad0bfw0sf90fq6cw7fb";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid_dingyue"];
    protected void Page_Load(object sender, EventArgs e)
    {
        token = Util.GetSafeRequestValue(Request, "token", "");
        if (token == null || token == "")
        {
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Request.Url.ToString());
        }
        
        try
        {
            timeStamp = Util.GetTimeStamp();
            string jsonStrForTicket = Util.GetWebContent("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token="
                + Util.GetToken() + "&type=jsapi", "get", "", "form-data");
            ticket = Util.GetSimpleJsonValueByKey(jsonStrForTicket, "ticket");
            string shaString = "jsapi_ticket=" + ticket.Trim() + "&noncestr=" + nonceStr.Trim()
                + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
            shaParam = Util.GetSHA1(shaString);
        }
        catch { }

        try
        {
            JavaScriptSerializer json = new JavaScriptSerializer();
            string getUrl = "http://game.luqinwenda.com/api/new_year_box_get_info.aspx?token=" + token;
            string result = HTTPHelper.Get_Http(getUrl);
            Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(result);
            if (dic["status"].Equals(0))
            {
                id = dic["id"].ToString();
                surplusCount = dic["current_support_num"].ToString();
                ArrayList supportList = (ArrayList)dic["support_list"];
                totalCount = supportList.Count.ToString();
                ArrayList boxList = (ArrayList)dic["opened_box"];
                foreach (var box in boxList)
                {
                    Dictionary<string, object> ddd = (Dictionary<string, object>)box;
                    openedBoxList += ddd["box_id"].ToString() + ",";
                }
                openedBoxList = openedBoxList.Length > 0 ? openedBoxList.Substring(0, openedBoxList.Length - 1) : "";
            }
        }
        catch { }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>大家都来拆礼盒</title>
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <script src="../script/jquery-1.3.2.min.js"></script>
    <script src="../script/common.js"></script>
    <style type="text/css">
        body, div { font-family:SimSun;}
        .bgContent { background:#595167; max-width: 640px; margin: 0 auto; min-height:600px; padding-bottom:10px; }
        .header { min-height:150px; background:#B6092F; }
        .header #leftlogo { float:left; width:50%; max-height:150px;  }
        .header #rightlogo { float:right; width:45%; max-height:150px; margin-top:5%; margin-right:5%; }
        .header img { width:100%; }
        .maincontent { padding:0 20px 20px; }
        .maincontent div { margin-top:10px;  }
        .maincontent .tab1 { width:33%; float:left; text-align:center; }
        .maincontent .tab2 { width:33%; float:left; text-align:center; }
        .maincontent .tab3 { width:33%; float:left; text-align:center; }
        .maincontent .tab1 img, .maincontent .tab2 img, .maincontent .tab3 img { width:50%; margin:5px auto; }
        .progress { width:40%; float:left; height:20px; border:2px solid #332942; }
        .giftList { margin-left:20px;}
        .giftList div { margin:0; font-size:16px; color:#392D4C; width:100%; height:25px; line-height:25px; overflow:hidden;}
        .promptDiv { width:180px; height:200px;  color:#000; position:absolute; z-index:20; font-size:14pt; line-height:30pt; text-align:center;}
    </style>
</head>
<body>
    <form runat="server">
    <div class="bgContent">
        <div class="header">
            <div id="leftlogo"><img src="images/ny_logo1.png" /></div>
            <div id="rightlogo"><img src="images/ny_logo2.png" /></div>
        </div>
        <div style="color:#fff; text-align:center; padding:20px;">
            <img src="images/ny_text1.png" style="width:50%;" />
        </div>
        <div class="maincontent">
            <div class="tab1"><img src="images/gift_yellow.png" hiddata="0" /></div>
            <div class="tab2"><img src="images/gift_yellow.png" hiddata="1" /></div>
            <div class="tab3"><img src="images/gift_yellow.png" hiddata="2" /></div>
            <div style="clear:both"></div>
            <div class="tab1" style="margin-top:25px;"><img src="images/gift_yellow.png" hiddata="3" /></div>
            <div class="tab2"><img src="images/gift_max.png" hiddata="4" style="width:70%;" /></div>
            <div class="tab3" style="margin-top:25px;"><img src="images/gift_yellow.png" hiddata="5" /></div>
            <div style="clear:both"></div>
            <div class="tab1"><img src="images/gift_yellow.png" hiddata="6" /></div>
            <div class="tab2"><img src="images/gift_yellow.png" hiddata="7" /></div>
            <div class="tab3"><img src="images/gift_yellow.png" hiddata="8" /></div>
            <div style="clear:both"></div>
        </div>
        <div style="padding:20px 20px; margin-top:10px;">
            <div style="color:#fff; float:left; width:30%; margin-left:8%; margin-right:1%; margin-top:3px; text-align:right;">
                <img src="images/ny_text4.png" style="width:80%;" />
            </div>
            <div class="progress">
                <div id="progressFill" style="height:100%; background:#84B822;"></div>
            </div>
            <div style="width:10%; margin-left:10px; float:left; font-weight:bold; font-size:22px; color:#332942;"><span id="spCount"></span></div>
            <div style="clear:both"></div>
        </div>
        <div style="margin-top:30px; text-align:center;">
            <img src="images/btn_help.png" style="width:40%; border:0;" onclick="helpYou();" />
        </div>
        <div style="margin-top:10px;  text-align:center;">
            <img src="images/btn_mygift.png" style="width:40%; border:0;" onclick="getMyGift();" />
        </div>
        <div style="margin:30px 20px 20px;">
            <div style="padding:10px 30px;">
                <div style="color:#473D56;"><img src="images/ny_text2.png" style="width:37%" /></div>
                <div id="giftedList" class="giftList">
                </div>
            </div>
            <div style="padding:10px 30px;">
                <div style="color:#473D56;"><img src="images/ny_text3.png" style="width:50%" /></div>
                <div id="giftnoList" class="giftList">
                </div>
            </div>
        </div>
        <div style="clear:both"></div>
    </div>
    <div id="showShare" style="display:none;" onclick="javascript:document.getElementById('showShare').style.display='none';">
        <div class="bgDiv" style="width:100%; height:100%; background:#ccc; color:#000; position:absolute; top:-10px; left:0px; text-align:center; filter:alpha(opacity=90); -moz-opacity:0.9;-khtml-opacity: 0.9; opacity: 0.9;  z-index:9;"></div>
        <div class="promptDiv" style="font-size:12pt; width:80%; top:20pt; left:10%; background:#fff;">
            <div id="shareText" style="line-height:20px; text-align:left; padding:10px;">长按指纹识别二维码，关注“卢勤问答平台”，帮TA拆礼盒</div>
            <img id="erweima" src="../images/dyh_code1.jpg" style="width:100%; " />
        </div>
    </div>
    </form>
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript">
        var Token = '<%=token %>';
        var ZxjjgiftArr = ['011', '122', '233', '344', '455', '566', '677', '788', '899', '900'];
        var ZxjjgiftImgArr = ['011', '122', '233', '344', '455', '566', '677', '788', '899', '900'];
        var ZxdygiftArr = ['001', '112', '223', '334', '445', '556', '667', '778', '889', '990'];
        var ZxdygiftImgArr = ['001', '112', '223', '334', '445', '556', '667', '778', '889', '990'];
        var LqwdgiftArr = ['000', '111', '222', '333', '444', '555', '666', '777', '888', '999'];
        var LqwdgiftImgArr = ['000', '111', '222', '333', '444', '555', '666', '777', '888', '999'];
        var giftArr = ['000', '111', '222', '333', '444', '555', '666', '777', '888', '999'];
        var giftImgArr = ['000', '111', '222', '333', '444', '555', '666', '777', '888', '999'];
        var percent = [8, 12, 18, 4, 9, 14, 5, 17, 7, 6];
        var openCount = 0;
        var remainCount = parseInt('<%=surplusCount %>');
        var openedBox = '<%=openedBoxList %>';

        var shareTitle = "我想要新年礼盒，请大家帮帮我"; //标题
        var shareImg = "http://game.luqinwenda.com/newyear/images/ny_share_icon.jpg"; //图片
        var shareContent = '我想要新年礼盒，请大家帮帮我！'; //简介
        var shareLink = document.URL; //链接

        wx.config({
            debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
            appId: '<%=appId%>', // 必填，公众号的唯一标识
            timestamp: '<%=timeStamp%>', // 必填，生成签名的时间戳
            nonceStr: '<%=nonceStr%>', // 必填，生成签名的随机串
            signature: '<%=shaParam %>', // 必填，签名，见附录1
            jsApiList: [
                    'onMenuShareTimeline',
                    'onMenuShareAppMessage']
        });

        $(document).ready(function () {
            shareLink = document.URL;

            wx.ready(function () {
                //分享到朋友圈
                wx.onMenuShareTimeline({
                    title: shareTitle, // 分享标题
                    link: shareLink, // 分享链接
                    imgUrl: shareImg, // 分享图标
                    success: function () {
                        // 用户确认分享后执行的回调函数

                    }
                });

                //分享给朋友
                wx.onMenuShareAppMessage({
                    title: shareTitle, // 分享标题
                    desc: shareContent, // 分享描述
                    link: shareLink, // 分享链接
                    imgUrl: shareImg, // 分享图标
                    success: function () {
                        // 用户确认分享后执行的回调函数

                    }
                });
            });

            for (var i = 0; i < LqwdgiftArr.length; i++) {
                var m = Math.floor(Math.random() * 3);
                if (i == 0 || i == 9 || i == 8 || i == 7) {
                    m = 0;
                }
                if (m == 0) {
                    giftArr[i] = LqwdgiftArr[i];
                    giftImgArr[i] = LqwdgiftImgArr[i];
                }
                else if (m == 1) {
                    giftArr[i] = ZxjjgiftArr[i];
                    giftImgArr[i] = ZxjjgiftImgArr[i];
                }
                else if (m == 2) {
                    giftArr[i] = ZxdygiftArr[i];
                    giftImgArr[i] = ZxdygiftImgArr[i];
                }
                else {
                    giftArr[i] = LqwdgiftArr[i];
                    giftImgArr[i] = LqwdgiftImgArr[i];
                }
            }

            var boxArr = openedBox.split(',');
            openCount = boxArr.length;
            for (var i = 0; i < boxArr.length; i++) {
                if (boxArr[i] == '4')
                    $('.maincontent img').eq(boxArr[i]).attr("src", "images/gift_max_gray.png");
                else
                    $('.maincontent img').eq(boxArr[i]).attr("src", "images/gift_gray.png");
            }

            bindGiftList();
            fillProgress();

            $('.maincontent img').click(function () {
                if ($(this).attr("src") != "images/gift_gray.png" && $(this).attr("src") != "images/gift_max_gray.png") {
                    var cStr = $('#spCount').html();
                    if (cStr != "" && parseInt(cStr.substr(1, 1)) > 0) {
                        OpenBox($(this).attr("hiddata"));
                        if ($(this).attr("hiddata") == "4")
                            $(this).attr("src", "images/gift_max_gray.png");
                        else
                            $(this).attr("src", "images/gift_gray.png");
                    }
                    else {
                        alert("快去找您的朋友帮你来拆礼盒吧！");
                    }
                }
            });
        });

        function fillProgress() {
            var proCount = 0;
            if (openCount < 8) {
                var rC = parseInt(remainCount / 20);
                if ((8 - openCount) > rC) {
                    if (parseInt(rC) != 0)
                        $('#spCount').html("X" + parseInt(rC));
                    else
                        $('#spCount').html('');
                    proCount = remainCount % 20;

                    var proTotal = 0;
                    for (var i = 0; i < parseInt(proCount / 2) ; i++) {
                        proTotal += percent[i];
                    }
                    $('#progressFill').css({ width: proTotal + "%" });
                }
                else {
                    var lastCount = remainCount - ((8 - openCount) * 20);
                    if (lastCount < 200) {
                        $('#spCount').html("X" + parseInt(8 - openCount));
                        proCount = lastCount;

                        var proTotal = 0;
                        for (var i = 0; i < parseInt(proCount / 20) ; i++) {
                            proTotal += percent[i];
                        }
                        $('#progressFill').css({ width: proTotal + "%" });
                    }
                    else {
                        $('#spCount').html("X" + parseInt(8 - openCount + 1));
                        proCount = 200;
                        $('#progressFill').css({ width: "100%" });
                    }
                }
            }
            else if (openCount == 8) {
                var lastCount = remainCount;
                if (lastCount < 200) {
                    $('#spCount').html('');
                    proCount = lastCount;

                    var proTotal = 0;
                    for (var i = 0; i < parseInt(proCount / 20) ; i++) {
                        proTotal += percent[i];
                    }
                    $('#progressFill').css({ width: proTotal + "%" });
                }
                else {
                    $('#spCount').html("X1");
                    proCount = 200;
                    $('#progressFill').css({ width: "100%" });
                }
            }
        }

        function bindGiftList() {
            var giftedStr = "";
            var giftnoStr = "";
            for (var i = 0 ; i < giftArr.length; i++) {
                if (i < openCount) {
                    giftedStr += "<div>" + giftArr[i] + "</div>";
                }
                else {
                    giftnoStr += "<div>" + giftArr[i] + "</div>";
                }
            }
            $('#giftedList').html(giftedStr);
            $('#giftnoList').html(giftnoStr);
        }
        
        function helpYou() {
            if (QueryString("id") != null) {
                $('#shareText').html('长按指纹识别二维码，关注“卢勤问答平台”，帮TA拆礼盒');
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "http://game.luqinwenda.com/api/new_year_box_support.aspx",
                    data: { token: Token, id: QueryString("id") },
                    success: function (data) {
                    }
                });
            }
            else {
                $('#shareText').html('请将当前页面发送给朋友或者朋友圈，请他们来帮你拆礼盒');
            }

            var codeArr = ['../images/dyh_code1.jpg', 'images/di8jie.jpg'];
            var n = Math.floor(Math.random() * 2);
            $('#erweima').attr('src', codeArr[n]);

            showShare();
        }

        function getMyGift() {
            $('#shareText').html('长按指纹识别二维码，关注“卢勤问答平台”，点击下方菜单“新年礼物”获取你的礼物盒子');
            showShare();
        }

        function showShare() {
            if (document.documentElement.scrollTop == 0) {
                $(".bgDiv").css({ height: document.body.scrollHeight + 30 + "px" });
                $(".promptDiv").css({ top: document.body.scrollTop + 80 + "px" });
            }
            else {
                $(".bgDiv").css({ height: document.body.scrollHeight + 30 + "px" });
                $(".promptDiv").css({ top: document.documentElement.scrollTop + 80 + "px" });
            }
            $("#showShare").show();
        }

        function OpenBox(boxid) {
            $.ajax({
                type: "GET",
                async: false,
                url: "http://game.luqinwenda.com/api/new_year_box_open_box.aspx",
                data: { token: Token, boxId: boxid },
                success: function (data) {
                    alert("恭喜您，获得 " + giftArr[openCount]);
                    openCount++;
                    if (openCount < 9)
                        remainCount -= 20;
                    fillProgress();
                }
            });
        }
    </script>
</body>
</html>
