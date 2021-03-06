﻿<%@ Page Title="微课门票众筹申请" Language="C#" MasterPageFile="~/CrowdFunding/Master.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    public string token = "";
    public int userId = 0;
    public int courseId = 0;
    public string NickName = "匿名";
    public string groupName = "";
    public string Remark = "";
    public int minPrice = 1;
    public int crowdid = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        courseId = int.Parse(Util.GetSafeRequestValue(Request, "courseid", "0"));
        string config = Util.GetSafeRequestValue(Request, "config", "");
        
        token = Util.GetSafeRequestValue(Request, "token", "");
        userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            string currentUrl = Request.Url.ToString();
            if (token != "")
                currentUrl = currentUrl.Replace("&token=" + token, "").Replace("?token=" + token, "");
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(currentUrl), true);
        }

        if (courseId == 0)
        {
            DataTable courseDt = Donate.getNewCourseId();
            courseId = int.Parse(courseDt.Rows[0][0].ToString());
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

        if (Request.Form["hidIndex"] != null && Request.Form["hidIndex"].ToString().Equals("1"))
        {
            if (config != "" && int.Parse(Request.Form["hidCrowdid"]) > 0)
            {
                string name = Util.GetSafeRequestFormValue(Request, "groupName", "");
                int price = int.Parse(Util.GetSafeRequestFormValue(Request, "txtPrice", "0")) * 100;
                string remark = Util.GetSafeRequestFormValue(Request, "txtRemark", "");

                Donate.updCrowd(int.Parse(Request.Form["hidCrowdid"]), name, price, remark);
                Response.Redirect(Request.Url.ToString() + "&upd=1");
            }
            else
            {
                string name = Util.GetSafeRequestFormValue(Request, "groupName", "");
                string course = ""; //Util.GetSafeRequestFormValue(Request, "courseIntro", "");
                int price = int.Parse(Util.GetSafeRequestFormValue(Request, "txtPrice", "0")) * 100;
                string remark = Util.GetSafeRequestFormValue(Request, "txtRemark", "");

                int result = Donate.addCrowd(userId, name, course, price, courseId, remark);
                if (result > 0)
                    Response.Redirect("group_confirm.aspx?courseid=" + courseId + "&fuid=" + userId + "&price=" + (price / 100).ToString());
            }
        }
        else
        {
            //DataTable dt = Donate.getCrowdByUserid(userId, courseId);
            DataTable dt = Donate.getCrowdByOnlyUserid(userId);
            if (dt != null && dt.Rows.Count > 0)
            {
                //已申请
                if (config == "")
                    Response.Redirect("group_default.aspx?courseid=" + courseId + "&fuid=" + userId);
                else
                {
                    groupName = dt.Rows[0]["crowd_name"].ToString();
                    Remark = dt.Rows[0]["crowd_remark"].ToString();
                    minPrice = int.Parse(dt.Rows[0]["crowd_minprice"].ToString()) / 100;
                    crowdid = int.Parse(dt.Rows[0]["crowd_id"].ToString());
                }
            }
            
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <form id="form1" runat="server" method="post">
    <div class="mainPage">
        <img src="../images/main_head.jpg" width="100%" />
        <div style="border:3px solid #E9E9E9; border-radius:15px; margin:5px; margin-top:10px;">
            <div style="background:#ECECEC; margin:5px;  padding:30px 20px;">
                <div style="background:#fff; width:100%; padding:20px 10px;">
                    <ul class="applyUL" style="margin-left: -20px;">
                        <li>　　群名： <input id="groupName" name="groupName" type="text" maxlength="100" value="<%=groupName %>" /></li>
                        <li>　申请人： <%=NickName %></li>
                        <li style="position:relative; vertical-align:middle;">
                            最低金额： 
                            <div class="spinner_block">
                                <a class="sub-li" onclick="subANum();">－</a>
                                <input class="input-li" type="text" id="txtPrice" name="txtPrice" maxlength="3" value="<%=minPrice %>" onblur="updANum();" />
                                <a class="add-li" onclick="addANum();">＋</a>
                            </div>
                            <a style="display:inline-block; margin-left:3px;">元</a>
                        </li>
                        <li style="height:auto;">　　备注： <textarea class="form-control" style="width:95%; vertical-align:middle; " id="txtRemark" name="txtRemark" maxlength="100"  rows="3" placeholder="你想对群员说..."><%=Remark %></textarea></li>
                    </ul>
                </div>
                <div style="margin:20px 0; text-align:center;">
                    <input type="hidden" id="hidCrowdid" name="hidCrowdid" value="<%=crowdid %>" />
                    <input type="hidden" id="hidIndex" name="hidIndex" value="" />
                    <input id="btn_apply" type="button" class="btn btn-warning" value="提交申请" style="font-size:16pt;" onclick="submitApply();" />
                    <input id="btn_return" type="button" class="btn btn-warning" value="返回" style="font-size:16pt; display:none; margin-left:15px;" onclick="ReturnDefault();" />
                </div>
                <div style="margin-top:20px; line-height:25px;">
                    <div style="font-size:13pt; font-weight:bold;">卢勤微课众筹规则：</div>
                    <div>1. 由群主提交众筹申请，一次可以填写多个群名。</div>
                    <div>2. 请将众筹页面分享到您的群里，开始微课众筹，众筹所有金额将用于支付悦长大家庭教育专家问答平台付费微课。</div>
                    <div>3. 当众筹金额已足够支付当次微课，即可购买微课门票，一次可购买多个微信群。</div>
                    <div>4. 购买成功后，请将门票截图发送给悦长大家庭教育专家问答平台旭老师（ID:xulaoshi0224），安排听课事宜。</div>
                    <div><b>其他说明：</b>最低金额为众筹时群成员支持最少金额，点击众筹页面“设置”可以重新设置最低金额。</div>
                </div>
            </div>
        </div>
    </div>
    </form>
    <script type="text/javascript">
        $(document).ready(function () {
            if (QueryString("config") != null)
            {
                $('#btn_apply').val("修改申请");
                $('#btn_return').show();
            }
            if (QueryString("upd") != null)
                alert("修改成功");

            shareLink = 'http://game.luqinwenda.com/CrowdFunding/group_apply.aspx';
        });

        function submitApply() {
            if ($('#groupName').val().Trim() == "") {
                alert("请输入群名");
                return;
            }
            
            $('#hidIndex').val('1');
            document.forms[0].submit();
        }

        function ReturnDefault()
        {
            location.href = "group_default.aspx?courseid=<%=courseId %>&fuid=<%=userId %>";
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

