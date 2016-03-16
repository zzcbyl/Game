<%@ Page Title="" Language="C#" MasterPageFile="~/CrowdFunding/Master.master" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    public string token = "";
    public int userId = 0;
    public int fuserId = 0;
    public int crowd_balance = 0;
    public string group_name = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        fuserId = int.Parse(Util.GetSafeRequestValue(Request, "fuid", "0"));
        if (fuserId == 0)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
        
        token = Util.GetSafeRequestValue(Request, "token", "");
        userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(Request.Url.ToString()), true);
        }

        int donateid = 0;
        DataTable dt = Donate.getCrowdByUserid(fuserId);
        if (dt != null && dt.Rows.Count > 0)
        {
            group_name = dt.Rows[0]["crowd_name"].ToString();
            donateid = int.Parse(dt.Rows[0]["crowd_id"].ToString());
            crowd_balance = (int.Parse(dt.Rows[0]["crowd_balance"].ToString()) / 100);
        }
        else
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <form id="form1" runat="server" method="post">
        <div class="mainPage">
            <div id="head" style="color:#7e3766; font-weight:normal;">
                <div style="float:left; margin-left:15px; ">群名：<%=group_name %></div>
                <div style="float:right; margin-right:15px; ">申请人：</div>
            </div>
            <div style="border: 1px solid #E9E9E9; border-radius: 10px; padding:15px; margin:5px;">
                啊岁的法撒旦啊岁的法撒旦<br />
                啊岁的法撒旦啊岁的法撒旦<br />
            </div>
            <div style="color:#7e3766; font-size:14pt; text-align:center; height:50px; line-height:50px;">
                现已有总金额：<%=crowd_balance %>元
            </div>
            <div style="text-align:center; height:50px; line-height:50px;">
                <input type="button" class="btn btn-warning" value="点击交费听课" style="font-size:16pt;" onclick="submitApply();" />
            </div>
            <div style="border: 1px solid #E9E9E9; border-radius: 15px; margin:20px 5px 5px; padding:0 15px; min-height:100px;">
                <div style="background:#7e3766; height:1px; margin:5px 0 0;"></div>
                <div style="margin-top:5px;"><img src="../images/record_head.jpg" width="35%" /></div>
                <div style="margin-top:10px;">
                    <div style="height:55px; line-height:55px; border-bottom:dashed 1px #ccc;">
                        <div style="width:30%; float:left; text-align:center;"><a style="width:50px; height:50px; border-radius:5px; display:inline-block; background:url(http://wx.qlogo.cn/mmopen/M13tqMABLia0mbuQSR36GgqxLRqK0ExSLIj8cEVy2pMQYR7xVwxAg5Is6Y3SiaHP03iciaQZJW1PicHhC4122Va5DSw/0); background-size:50px 50px;"></a></div>
                        <div style="width:40%; float:left; text-align:center;">11</div>
                        <div style="width:30%; float:left; text-align:center;">3元</div>
                        <div style="clear:both;"></div>
                    </div>
                </div>
                <div style="clear:both; height:50px;"></div>
            </div>
        </div>
    </form>
</asp:Content>

