<%@ Page Language="C#" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<!DOCTYPE html>

<script runat="server">
    public string actid = "3";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["openid"] == null || Request["id"] == null)
        {
            Response.Write("参数错误");
            Response.End();
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string openid = Request["openid"].ToString();
        string id = Request["id"].ToString();
        int isAward = 0;
        JavaScriptSerializer json = new JavaScriptSerializer();
        string getUrl = "http://game.luqinwenda.com/api/awards_get_info.aspx?actid=" + actid + "&id=" + id + "&openid=" + openid;
        string result = HTTPHelper.Get_Http(getUrl);
        Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(result);
        if (dic["status"].Equals(0))
        {
            isAward = 1;
        }
        else
            isAward = 0;
        

        if (isAward == 1)
        {
            string address = Request.Form["hidprovince"].ToString() + Request.Form["hidcity"].ToString() + Request.Form["address"].ToString();
            string consignee = Request.Form["consignee"].ToString();
            string mobile = Request.Form["mobile"].ToString();
            getUrl = "http://game.luqinwenda.com/api/awards_set_address.aspx?actid=" + actid + "&openid=" + openid
                + "&name=" + Server.UrlEncode(consignee) + "&cell=" + Server.UrlEncode(mobile) + "&address=" + Server.UrlEncode(address);
            result = HTTPHelper.Get_Http(getUrl);
            dic = json.Deserialize<Dictionary<string, object>>(result);
            if (dic.Keys.Contains("status") && dic["status"].ToString() == "0")
            {
                Response.Redirect("SubmitSuccess.aspx?name=" + Request["name"].ToString());
            }
            else
            {
                Response.Write("提交失败");
                Response.End();
            }
        }
        else
        {
            Response.Write("很遗憾，您没有中奖！");
            Response.End();
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <title>卢勤微课堂幸运抽奖活动</title>
    <style type="text/css">
        .rel { position:relative; }
        .add_list_p { padding:5px 20px 5px 10px; text-indent:0px; margin:0; }
        .add_list_p label { position:absolute; left:10px; top:10px; margin-bottom:0; }
        .add_list_p input,.add_list_p select { width:100%; margin-bottom:0; height:30px; line-height:30px; font-size:16px; box-shadow:none; padding:2px 5px;}
        .add_list_p input:focus { box-shadow:none;}
        .btnCss { width: 100px; height: 40px; background: #E51925; color: #fff;  font-size: 14pt; border-radius: 5px; border: 0;}
    </style>
    
    <script src="../script/jquery-2.1.1.min.js"></script>
    <script src="../script/common.js"></script>
</head>
<body style="background: #C81623;">
    <form id="form1" runat="server" method="post">
        <div style="max-width: 640px; margin: 0 auto;">    
            <img src="../images/draw_banner.jpg" width="100%" />
            <div style="margin-top: 5px; text-indent: 20px; line-height: 28px; background: #fff; padding: 10px;">
                恭喜您，获得<span id="bookName"></span>，请您仔细填写邮寄地址，活动结束后由卢勤问答平台统一发出。
            </div>
            <div style="margin-top: 5px; text-indent: 20px; line-height: 28px; background: #fff; padding: 10px 0 30px;">
                <p class="add_list_p rel">
                    <input type="text" id="consignee" name="consignee" placeholder="请输入收货人姓名" />
                </p>
                <p class="add_list_p rel">
                    <input type="text" id="mobile" name="mobile" placeholder="请输入手机号" />
                </p>
                <p class="add_list_p rel">
                    <select id="province" name="province"></select>
                </p>
                <p class="add_list_p rel">
                    <select id="city" name="city"></select>
                </p>
                <p class="add_list_p rel">
                    <input type="text" id="address" name="address" placeholder="请输入详细地址" />
                </p>
                <div style="margin-top:10px; text-align:center;">
                    <div style="padding-bottom:10px;"><span id="errorMsg" style="color:red;"></span></div>
                    <asp:Button ID="Button1" runat="server" Text="提交" CssClass="btnCss" OnClientClick="return SubOrder();" OnClick="Button1_Click" />
                    <input type="hidden" id="hidprovince" name="hidprovince" />
                    <input type="hidden" id="hidcity" name="hidcity" />
                </div>
            </div>
        </div>
    </form>
    <script type="text/javascript">
        $(document).ready(function () {
            so_fillProvince();
            $("#city").append("<option value='0' >请选择城市……</option>");
            $("#province").change(function () {
                so_fillCity($(this).val());
            });

            $('#bookName').html(decodeURI(QueryString("name")));
        });

        function SubOrder() {

            if ($("#consignee").val().Trim() == "") {
                $("#errorMsg").html("请输入收件人姓名");
                return false;
            }
            if ($("#mobile").val().Trim() == "") {
                $("#errorMsg").html("请输入手机号");
                return false;
            }
            if (!$("#mobile").val().isMobile()) {
                $("#errorMsg").html("请输入正确的手机号");
                return false;
            }
            if ($("#province").val().Trim() == "0") {
                $("#errorMsg").html("请选择省份");
                return false;
            }
            if ($("#city").val().Trim() == "0") {
                $("#errorMsg").html("请选择城市");
                return false;
            }
            if ($("#address").val().Trim() == "") {
                $("#errorMsg").html("请输入详细地址");
                return false;
            }

            $("#hidprovince").val($("#province option:selected").text());
            $("#hidcity").val($("#city option:selected").text());
        }

        function so_fillProvince() {
            $.ajax({
                type: "get",
                async: false,
                url: 'http://game.luqinwenda.com/api/area_get_subarea_by_parentid.aspx',
                data: { random: Math.random() },
                success: function (data, textStatus) {
                    var obj = eval('(' + data + ')');
                    if (obj.status == 1) {
                        so_fillProvince();
                    }
                    else {
                        $("#province").empty();
                        $("#province").append("<option value='0' >请选择省份……</option>");
                        for (var i = 0; i < obj.area.length; i++) {
                            $("#province").append("<option value='" + obj.area[i].id + "'>" + obj.area[i].name + "</option>");
                        }
                    }
                }
            });
        }
        function so_fillCity(pid, city) {
            $.ajax({
                type: "get",
                async: false,
                url: 'http://game.luqinwenda.com/api/area_get_subarea_by_parentid.aspx',
                data: { parentid: pid, random: Math.random() },
                success: function (data, textStatus) {
                    var obj = eval('(' + data + ')');
                    if (obj.status == 1) {
                        so_fillCity(pid, city);
                    }
                    else {
                        $("#city").empty();
                        $("#city").append("<option value='0' >请选择城市……</option>");
                        var seltxt = "";
                        for (var i = 0; i < obj.area.length; i++) {
                            if (city != "" && obj.area[i].name == city)
                                seltxt = " selected='true'"
                            else
                                seltxt = "";
                            $("#city").append("<option value='" + obj.area[i].id + "'" + seltxt + ">" + obj.area[i].name + "</option>");
                        }
                    }
                }
            });
        }

    </script>
</body>
</html>
