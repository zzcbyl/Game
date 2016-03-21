<%@ Page Title="" Language="C#" MasterPageFile="~/CrowdFunding/Master.master" %>
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
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(Request.Url.ToString()), true);
        }
        DataTable dt = Donate.getCrowdByUserid(userId);
        if (dt != null && dt.Rows.Count > 0)
        {
            //已申请
            Response.Redirect("group_default.aspx?fuid=" + userId);
        }

        if (Request.Form["hidIndex"] != null && Request.Form["hidIndex"].ToString().Equals("1"))
        {
            string name = Util.GetSafeRequestFormValue(Request, "groupName", "");
            string course = Util.GetSafeRequestFormValue(Request, "courseIntro", "");
            int price = int.Parse(Util.GetSafeRequestFormValue(Request, "txtPrice", "0")) * 100;
            string remark = Util.GetSafeRequestFormValue(Request, "txtRemark", "");

            int result = Donate.addCrowd(userId, name, course, price, remark);
            if (result > 0)
                Response.Redirect("group_default.aspx?fuid=" + userId);
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <form id="form1" runat="server" method="post">
    <div class="mainPage">
        <div id="head">
            申请详情设置
        </div>
        <div style="border:3px solid #E9E9E9; border-radius:15px; margin:5px;">
            <div style="background:#ECECEC; margin:5px;  padding:40px 30px;">
                <div style="background:#fff; width:100%; padding:20px 10px;">
                    <ul class="applyUL">
                        <li>　　群名： <input id="groupName" name="groupName" type="text" maxlength="100" /></li>
                        <li>课程介绍： <input id="courseIntro" name="courseIntro" type="text" maxlength="100" /></li>
                        <li style="position:relative; vertical-align:middle;">
                            票价设置： 
                            <div style="display:inline-block; clear:both; border:1px solid #ccc; height:24px; line-height:22px; margin-top:5px; ">
                                <a style="width:22px; height:22px; border-right:1px solid #ccc; line-height:22px; text-align:center; display:inline-block;" onclick="subANum();">－</a>
                                <input type="text" id="txtPrice" name="txtPrice" style="width:40px; text-align:center; border:none; display:inline-block; height:22px; line-height:22px; margin-left:-4px;" maxlength="5" value="1" onblur="updANum();" />
                                <a style="width:22px; height:22px;border-left:1px solid #ccc; line-height:22px; text-align:center; display:inline-block; margin-left:-4px;" onclick="addANum();">＋</a>
                            </div>
                        </li>
                        <li>　　备注： <input id="txtRemark" name="txtRemark" type="text" maxlength="200" /></li>
                    </ul>
                </div>
                <div style="margin:50px 0; text-align:center;">
                    <input type="hidden" id="hidIndex" name="hidIndex" value="" />
                    <input type="button" class="btn btn-warning" value="提交申请" style="font-size:16pt;" onclick="submitApply();" />
                </div>
            </div>
        </div>
    </div>
    </form>
    <script type="text/javascript">
        function submitApply() {
            if ($('#groupName').val().Trim() == "") {
                alert("请输入群名");
                return;
            }
            
            $('#hidIndex').val('1');
            document.forms[0].submit();
        }

        var txtPrice;
        function subANum() {
            txtPrice = parseInt($("#txtPrice").val());
            if (txtPrice <= 1) {
                $("#txtPrice").val("1");
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
                $("#txtPrice").val("1");
            }
            else {
                if (txtPrice <= 1) {
                    $("#txtPrice").val("1");
                }
            }
        }

    </script>
</asp:Content>

