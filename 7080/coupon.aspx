<%@ Page Title="恭喜你获得卢勤问答平台书城代金券。" Language="C#" MasterPageFile="~/7080/Master7080.master" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!Request["amount"].Equals(null) && !Request["amount"].Equals("") && !Request["code"].Equals(null) && !Request["code"].Equals(""))
            {
                this.lbl_amount.Text = (Convert.ToInt32(Request["amount"].ToString()) / 100).ToString();
                this.lbl_code.Text = Request["code"].ToString();
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

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="width: auto; text-align: center;  ">
        <div>
            <img src="../images/couponbanner.jpg" width="100%" />
        </div>
        <p style="text-align:center; font-size:20px; font-weight:bold; color:red;">
            恭喜你获得了<asp:Literal ID="lbl_amount" runat="server"></asp:Literal>元卢勤问答平台书城代金券。
        </p>
        <p>
            您的代金券码是：<span style="font-family:长城美黑体; font-size:20px; font-weight:bold;"><asp:Literal ID="lbl_code" runat="server"></asp:Literal></span>
        </p>
        <div style="text-align:left; line-height:22px;">
            <div>1．该券只能在卢勤问答平台订阅号，书城中使用。</div>
            <div>2．每单只能使用一张。</div>
        </div>
        <div style="margin-top:10px;"><img src="http://weixin.luqinwenda.com/dingyue/images/qrcode_dingyue.jpg" width="200" height="200" /></div>
        <div>
            扫描二维码进入商城购书。
        </div>
    </div>
</asp:Content>

