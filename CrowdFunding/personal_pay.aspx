<%@ Page Title="" Language="C#" MasterPageFile="~/CrowdFunding/Master.master" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    public string token = "";
    public int userId = 0;
    public int fuserId = 0;
    public int min_price = 0;
    public string group_name = "";
    public int crowdid = 0;
    public string courseIntro = "";
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
        
        DataTable dt = Donate.getCrowdByUserid(fuserId);
        if (dt != null && dt.Rows.Count > 0)
        {
            group_name = dt.Rows[0]["crowd_name"].ToString();
            courseIntro = dt.Rows[0]["crowd_course"].ToString();
            crowdid = int.Parse(dt.Rows[0]["crowd_id"].ToString());
            min_price = (int.Parse(dt.Rows[0]["crowd_minprice"].ToString()) / 100);
        }
        else
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }

        if (Request.Form["hidIndex"] != null && Request.Form["hidIndex"].ToString().Equals("1"))
        {
            if (crowdid > 0)
            {
                int price = int.Parse(Request.Form["txtPrice"].ToString()) * 100;
                if (int.Parse(Request.Form["txtPrice"].ToString()) < min_price)
                {
                    price = min_price * 100;
                }
                int result = Donate.addDonate(crowdid, userId, price);
                
                //string payurl = "http://weixin.luqinwenda.com/payment/payment.aspx?body=卢勤问答平台微课堂&detail=听课费&userid=" + userId + "&product_id=" + result + "&total_fee=" + price.ToString()
                //    + "&callback=" + Server.UrlEncode("http://game.luqinwenda.com/CrowdFunding/paySuccess.aspx?product_id=" + result);
                
                string payurl = "http://weixin.luqinwenda.com/payment/payment.aspx?body=卢勤问答平台微课堂&detail=听课费&userid=" + userId + "&product_id=" + result + "&total_fee=1"
                    + "&callback=" + Server.UrlEncode("http://game.luqinwenda.com/CrowdFunding/paySuccess.aspx?product_id=" + result);
                Response.Redirect(payurl);
            }
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <form id="form1" runat="server" method="post">
    <div class="mainPage">
        <div id="head">
            确认支付
        </div>
        <div style="border:3px solid #E9E9E9; border-radius:15px; margin:5px;">
            <div style="background:#ECECEC; margin:5px;  padding:40px 30px;">
                <div style="background:#fff; width:100%; padding:20px 10px;">
                    <ul class="applyUL">
                        <li>　　群名： <%=group_name %></li>
                        <li>课程介绍： <%=courseIntro %></li>
                        <li style="position:relative; vertical-align:middle;">
                        　　票价： 
                            <div style="display:inline-block; clear:both; border:1px solid #ccc; height:24px; line-height:22px; margin-top:5px; ">
                                <a style="width:22px; height:22px; border-right:1px solid #ccc; line-height:22px; text-align:center; display:inline-block;" onclick="subANum();">－</a>
                                <input type="text" id="txtPrice" name="txtPrice" style="width:40px; text-align:center; border:none; display:inline-block; height:20px; line-height:20px; margin-left:-2px;" maxlength="5" value="1" onblur="updANum();" />
                                <a style="width:22px; height:22px;border-left:1px solid #ccc; line-height:22px; text-align:center; display:inline-block; margin-left:-4px;" onclick="addANum();">＋</a>
                            </div>
                        </li>
                    </ul>
                </div>
                <div style="margin:50px 0; text-align:center;">
                    <input type="hidden" id="hidIndex" name="hidIndex" value="" />
                    <input type="button" class="btn btn-success" value="确认支付" style="font-size:16pt;" onclick="submitApply();" />
                </div>
            </div>
        </div>
    </div>
    </form>
    <script type="text/javascript">
        var minPrice = parseInt('<%=min_price %>');
        $(document).ready(function () {

            shareLink = 'http://game.luqinwenda.com/CrowdFunding/group_default.aspx?fuid=<%=fuserId %>';

            $('#txtPrice').val(minPrice);
        });

        function submitApply() {
            $('#hidIndex').val('1');
            document.forms[0].submit();
        }

        var txtPrice;
        function subANum() {
            txtPrice = parseInt($("#txtPrice").val());
            if (txtPrice <= minPrice) {
                $("#txtPrice").val(minPrice);
            }
            else {
                $("#txtPrice").val(txtPrice - 1);
            }
        }

        function addANum() {
            txtPrice = parseInt($("#txtPrice").val());
            $("#txtPrice").val(txtPrice + 1);
        }

        function updANum() {
            txtPrice = parseInt($("#txtPrice").val());
            if (!isint($("#txtPrice").val())) {
                $("#txtPrice").val(minPrice);
            }
            else {
                if (txtPrice <= minPrice) {
                    $("#txtPrice").val(minPrice);
                }
            }
        }
    </script>
</asp:Content>

