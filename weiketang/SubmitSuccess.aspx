<%@ Page Language="C#" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<!DOCTYPE html>

<script runat="server">
    //public string actid = "6";
    //public string bookName = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        //if (Request["openid"] == null || Request["id"] == null)
        //{
        //    Response.Write("参数错误");
        //    Response.End();
        //}
        //string openid = Request["openid"].ToString();
        //string id = Request["id"].ToString();
        //JavaScriptSerializer json = new JavaScriptSerializer();
        //string getUrl = "http://game.luqinwenda.com/api/awards_get_info.aspx?actid=" + actid + "&id=" + id + "&openid=" + openid;
        //string result = HTTPHelper.Get_Http(getUrl);
        //Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(result);
        //if (dic["status"].Equals(0))
        //{
        //    bookName = "卢勤老师所著新书《" + dic["award"].ToString() + "》一本";
        //}
        //else
        //{
        //    Response.Write("您没有中奖");
        //    Response.End();
        //}
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>卢勤问答平台</title>
    <script src="../script/jquery-1.3.2.min.js"></script>
    <script src="../script/common.js"></script>
</head>
<body style="background: #C81623;">
    <div style="max-width: 640px; margin: 0 auto;">
        <img src="../images/draw_banner.jpg" width="100%" />
        <div style="margin-top: 5px; text-indent: 20px; line-height: 28px; background: #fff; padding: 10px;">
            <div>恭喜您，获得<span id="bookName"></span>，邮寄地址我们已经收到，活动结束后由卢勤问答平台统一发出。</div>
            <div>了解更多活动信息请关注“卢勤问答平台”。</div>
            <div style="margin-top:10px; padding:0;">
                <img src="../images/dyh_code.jpg" style="width:90%; padding:0;" />
            </div>
        </div>    
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#bookName').html(decodeURI(QueryString("name")));
        });
    </script>
</body>
</html>
