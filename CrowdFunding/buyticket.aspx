<%@ Page Title="购买门票" Language="C#" MasterPageFile="~/CrowdFunding/Master.master" %>
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
            string currentUrl = Request.Url.ToString();
            if (token != "")
                currentUrl = currentUrl.Replace("&token=" + token, "").Replace("?token=" + token, "");
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(currentUrl), true);
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
        
        DataTable dt = Donate.getCrowdByOnlyUserid(fuserId);
        if (dt != null && dt.Rows.Count > 0)
        {
            group_name = dt.Rows[0]["crowd_name"].ToString();
            group_name = (group_name.Length > 12 ? group_name.Substring(0, 12) + "..." : group_name);
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
            DataTable donateCrowdDt = Donate.getDonateByCrowdid(crowdid, courseId, 2);
            if (donateCrowdDt != null && donateCrowdDt.Rows.Count > 0)
                courseprice = int.Parse(crouseDt.Rows[0]["course_priceadd"].ToString()) / 100;
            else
            {
                DataTable donateUserDt = Donate.getDonateByUserid(fuserId, 2);
                if (donateUserDt != null && donateUserDt.Rows.Count > 0)
                    courseprice = int.Parse(crouseDt.Rows[0]["course_price"].ToString()) / 100 / 2;
                else
                    courseprice = int.Parse(crouseDt.Rows[0]["course_price"].ToString()) / 100;
            }
            coursepriceadd = int.Parse(crouseDt.Rows[0]["course_priceadd"].ToString()) / 100;
        }
        else
        {
            courseprice = 498;
            coursepriceadd = 50;
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
            <div style="background:#ECECEC; margin:5px;  padding:20px;">
                <div style="height:35px; line-height:35px; font-size:13pt;">购买门票</div>
                <div style="background:#fff; width:100%; padding:20px 10px;">
                    <ul class="applyUL" style="margin-left: -20px;">
                        <li>　　群名： <%=group_name %></li>
                        <li>　申请人： <%=NickName %></li>
                        <li>众筹金额： ￥<%=userBalance %> 元</li>
                        <li style="position:relative; vertical-align:middle;">
                        　群数量： 
                            <div class="spinner_block">
                                <a class="sub-li" onclick="subANum();">－</a>
                                <input class="input-li" type="text" id="txtCount" name="txtCount" maxlength="3" value="1" onblur="updANum();" />
                                <a class="add-li" onclick="addANum();">＋</a>
                            </div>
                            <a style="display:inline-block; margin-left:3px;">个</a>
                        </li>
                        <li>　　总价：<span id="sp_price" style="color:#ff0000;"></span> 元</li>
                    </ul>
                </div>
                <div style="margin:50px 0; text-align:center;">
                    <input type="hidden" id="hidIndex" name="hidIndex" value="" />
                    <input type="button" class="btn btn-success" value="确认购买" style="font-size:16pt;" onclick="submitBuy();" />
                </div>
            </div>
        </div>
    </div>
    </form>
    <script type="text/javascript">
        var userbalance = '<%=userBalance %>';
        var price = '<%=courseprice %>';
        var perprice = '<%=coursepriceadd %>';
        $(document).ready(function () {
            filltotal();
        });
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
        var totalPrice = 0;
        function filltotal()
        {
            txtCount = parseInt($("#txtCount").val());
            if (txtCount == 1) {
                totalPrice = parseInt(price);
            }
            else if (txtCount > 1) {
                totalPrice = (txtCount - 1) * parseInt(perprice) + parseInt(price);
            }
            $('#sp_price').html("￥" + totalPrice.toString());
        }

        function submitBuy() {
            if (confirm("确定要购买吗？")) {
                if (totalPrice > parseInt(userbalance)) {
                    location.href = 'balance_error.aspx';
                }
                else {
                    location.href = 'buy_success.aspx?courseid=<%=courseId %>&fuid=<%=userId %>&count=' + parseInt($("#txtCount").val());
                }
            }
        }
    </script>
</asp:Content>

