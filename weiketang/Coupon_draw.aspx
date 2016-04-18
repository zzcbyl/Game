<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    public string code = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!Request["amount"].Equals(null) && !Request["amount"].Equals("") && !Request["code"].Equals(null) && !Request["code"].Equals(""))
            {
                this.lbl_amount.Text = (Convert.ToInt32(Request["amount"].ToString()) / 100).ToString();
                this.lbl_code.Text = Request["code"].ToString();
                code = Request["code"].ToString();
            }
            else
                Response.End();
        }
        catch
        {
            Response.End();
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>领取卢勤问答平台阅读卡</title>
    <style type="text/css">
        .btnCss { width: 100px; height: 40px; background: #E51925; color: #fff;  font-size: 14pt; border-radius: 5px; border: 0; text-indent:0; line-height:40px;}
        a { text-decoration:none; }
    </style>
</head>
<body>
    <div style="width: auto; text-align: center;  ">
        <div>
            <img src="../images/draw_banner.jpg" width="100%" />
        </div>
        <p style="text-align:center; font-size:16px; font-weight:bold; color:red; ">
            恭喜你获得了<span style="font-weight:bold; font-size:24px; padding:0 5px;"><asp:Literal ID="lbl_amount" runat="server"></asp:Literal>元</span>卢勤问答平台书城读书卡。
        </p>
        <p>
            您的读书卡码是：<span style="font-family:黑体; font-size:20px; font-weight:bold;"><asp:Literal ID="lbl_code" runat="server"></asp:Literal></span>
        </p>
        <p>
            <a id="btnSupport" class="btnCss" style="display:inline-block; margin:0 auto;" href="http://mall.luqinwenda.com/Default.aspx?couponCode=<%=code %>">去购书</a>　
        </p>
        <p><a href="http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=405844141&idx=1&sn=fb85317b54adbd207fbb7a56ffd5b4eb#rd"><img src="../images/ying_speak.jpg" style="width:100%;" /></a></p>
        <p style="color:red; text-align:left; ">现在报名“少年演说家”潜能开发营”优惠300元</p>
        <p><a id="btnSupport_ying" class="btnCss" style="display:inline-block; margin:0 auto; background:#FB6C69;" href="http://mp.weixin.qq.com/s?__biz=MzA3MTM1OTIwNg==&mid=405844141&idx=1&sn=fb85317b54adbd207fbb7a56ffd5b4eb#rd">去报名</a></p>
        <div style="text-align:left; line-height:22px;">
            <div>1．该读书卡只能在卢勤问答平台订阅号书城中使用。</div>
            <div>2．每单只能使用一张。</div>
        </div>
        <div style="margin-top:10px;"><img src="http://weixin.luqinwenda.com/dingyue/images/qrcode_dingyue.jpg" width="200" height="200" /></div>
        <div>
            扫描二维码进入商城购书。
        </div>
    </div>
</body>
</html>
