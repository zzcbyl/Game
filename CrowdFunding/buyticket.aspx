﻿<%@ Page Title="购买门票" Language="C#" MasterPageFile="~/CrowdFunding/Master.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = "";
    public int userId = 0;
    public int fuserId = 0;
    public string NickName = "匿名";
    public string group_name = "";
    public int crowdid = 0;
    public int courseId = 0;
    public int userBalance = 0;
    public int courseprice = 0;
    public int coursepriceadd = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        fuserId = int.Parse(Util.GetSafeRequestValue(Request, "fuid", "0"));
        courseId = int.Parse(Util.GetSafeRequestValue(Request, "courseid", "0"));
        if (fuserId == 0 || courseId == 0)
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

        if (fuserId != userId)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }

        JavaScriptSerializer json = new JavaScriptSerializer();
        Users user = new Users(userId);
        try
        {
            Dictionary<string, object> dicUser = json.Deserialize<Dictionary<string, object>>(user.GetUserAvatarJson());
            if (dicUser.Keys.Contains("nickname"))
                NickName = dicUser["nickname"].ToString();
            //if (dicUser.Keys.Contains("headimgurl"))
            //    UserHeadImg = dicUser["headimgurl"].ToString();
        }
        catch
        {

        }
        
        DataTable dt = Donate.getCrowdByUserid(fuserId, courseId);
        if (dt != null && dt.Rows.Count > 0)
        {
            group_name = dt.Rows[0]["crowd_name"].ToString();
            userBalance = int.Parse(dt.Rows[0]["crowd_balance"].ToString()) / 100;
            crowdid = int.Parse(dt.Rows[0]["crowd_id"].ToString());
        }
        else
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }

        DataTable crouseDt = Donate.getCourse(courseId);
        if (crouseDt != null && crouseDt.Rows.Count > 0)
        {
            courseprice = int.Parse(crouseDt.Rows[0]["course_price"].ToString()) / 100;
            coursepriceadd = int.Parse(crouseDt.Rows[0]["course_priceadd"].ToString()) / 100;
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <form id="form1" runat="server" method="post">
    <div class="mainPage">
        <img src="../images/main_head.jpg" width="100%" />
        <div style="border:3px solid #E9E9E9; border-radius:15px; margin:5px;">
            <div style="background:#ECECEC; margin:5px;  padding:30px 20px;">
                <div style="background:#fff; width:100%; padding:20px 10px;">
                    <ul class="applyUL">
                        <li>　　群名： <%=group_name %></li>
                        <li>　申请人： <%=NickName %></li>
                        <li style="position:relative; vertical-align:middle;">
                        　群数量： 
                            <div style="display:inline-block; clear:both; border:1px solid #ccc; height:23px; line-height:23px; margin-top:5px; ">
                                <a style="width:22px; height:22px; border-right:1px solid #ccc; line-height:22px; text-align:center; display:inline-block;" onclick="subANum();">－</a>
                                <input type="text" id="txtCount" name="txtCount" style="width:40px; text-align:center; border:none; display:inline-block; height:20px; line-height:20px; margin-left:-2px;" maxlength="5" value="1" onblur="updANum();" />
                                <a style="width:22px; height:22px;border-left:1px solid #ccc; line-height:22px; text-align:center; display:inline-block; margin-left:-4px;" onclick="addANum();">＋</a>
                            </div>
                            <a style="display:inline-block; margin-left:3px;">个</a>
                        </li>
                        <li>　　总价：<span id="sp_price"></span></li>
                    </ul>
                </div>
                <div style="margin:50px 0; text-align:center;">
                    <input type="hidden" id="hidIndex" name="hidIndex" value="" />
                    <input type="button" class="btn btn-success" value="确认支付" style="font-size:16pt;" onclick="" />
                </div>
            </div>
        </div>
    </div>
    </form>
    <script type="text/javascript">
        var userbalance = '<%=userBalance %>';
        var price = '<%=courseprice %>';
        var perprice = '<%=coursepriceadd %>';

        var txtCount;
        function subANum() {
            txtCount = parseInt($("#txtCount").val());
            if (txtCount <= 1) {
                $("#txtCount").val("1");
            }
            else {
                $("#txtCount").val(txtCount - 1);
            }
            filltotal();
        }

        function addANum() {
            txtCount = parseInt($("#txtCount").val());
            $("#txtCount").val(txtCount + 1);
            filltotal();
        }

        function updANum() {
            txtCount = parseInt($("#txtCount").val());
            if (!isint($("#txtCount").val())) {
                $("#txtCount").val("1");
            }
            else {
                if (txtCount <= 1) {
                    $("#txtCount").val("1");
                }
            }
            filltotal();
        }
        function filltotal()
        {
            txtCount = parseInt($("#txtCount").val());
            if (txtCount == 1)
                $('#sp_price').html("￥" + price);
            else if (txtCount > 1) {
                $('#sp_price').html("￥" + ((txtCount - 1) * parseInt(perprice) + parseInt(price)).toString());
            }
        }
    </script>
</asp:Content>

