﻿<%@ Page Title="支付成功" Language="C#" MasterPageFile="~/luqinwenda/Master.master" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">
    public string token = "";
    public int userId = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        token = Util.GetSafeRequestValue(Request, "token", "");
        userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            string currentUrl = Request.Url.ToString();
            if (token != "")
                currentUrl = currentUrl.Replace("&token=" + token, "").Replace("?token=" + token, "");
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(currentUrl), true);
        }

        if (Request["product_id"] != null && Request["product_id"] != "" && int.Parse(Request["product_id"]) > 0)
        {
            Donate.setBuyTicketState(int.Parse(Request["product_id"]));
            DataTable ticketDt = Donate.getTicket(int.Parse(Request["product_id"]));
            if (ticketDt != null && ticketDt.Rows.Count > 0)
            {
                if (ticketDt.Rows[0]["paystate"].ToString().Equals("1"))
                {
                    UserChatRoomRights.SetUserChatRoom(userId, int.Parse(ticketDt.Rows[0]["roomid"].ToString()));
                    this.Response.Redirect("HomePage.aspx?roomid=" + int.Parse(ticketDt.Rows[0]["roomid"].ToString()));
                }
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
    <div class="mainPage">
        <img src="../images/main_head.jpg" width="100%" />
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
</asp:Content>

