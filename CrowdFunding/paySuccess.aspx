﻿<%@ Page Title="" Language="C#" MasterPageFile="~/CrowdFunding/Master.master" %>

<script runat="server">
    public string token = "";
    public int userId = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        token = Util.GetSafeRequestValue(Request, "token", "");
        userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(Request.Url.ToString()), true);
        }

        if (Request["product_id"] != null && Request["product_id"] != "" && int.Parse(Request["product_id"]) > 0)
        {
            int result = Donate.updPayState(int.Parse(Request["product_id"]));
            if (result > 0)
            {
                Donate.setTotal(int.Parse(Request["product_id"]));
            }
        }
        else
        {
            //Response.Write("参数错误");
            Response.End();
        }
        
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <form id="form1" runat="server" method="post">
    <div class="mainPage">
        <div id="head">
            支付成功
        </div>
        <div style="border:3px solid #E9E9E9; border-radius:15px; margin:5px;">
            <div style="background:#ECECEC; margin:5px;  padding:40px 30px;">
                <div style="background:#fff; width:100%; padding:20px 10px; text-align:center;">
                    <img src="../images/ico-success.png" /> <h3>恭喜您！支付成功</h3>
                </div>
                <div style="margin:50px 0; text-align:center;">
                    
                </div>
            </div>
        </div>
    </div>
    </form>
</asp:Content>

