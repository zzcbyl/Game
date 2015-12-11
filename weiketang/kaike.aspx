<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    public string forward_count = "0";
    public string code = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["id"] != null && Request["id"] != "")
        {
            code = Request["id"].ToString();
            code = code.PadLeft(4, '0');
            code = "K" + code;
            System.Web.Script.Serialization.JavaScriptSerializer json = new System.Web.Script.Serialization.JavaScriptSerializer();
            string getNumUrl = "http://weixin.luqinwenda.com/dingyue/api/group_master_get_vote_num.aspx?id=" + Request["id"].ToString();
            string resultNum = HTTPHelper.Get_Http(getNumUrl);
            Dictionary<string, object> dicNum = json.Deserialize<Dictionary<string, object>>(resultNum);
            if (dicNum["status"].Equals(0))
            {
                forward_count = dicNum["num"].ToString();
            }
        }
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>微课堂邀请函</title>
    <script src="../script/jquery-1.3.2.min.js"></script>
</head>
<body>
    <div style="max-width: 640px; margin: 0 auto;">
        <img src="../images/wkt_invite.jpg" width="100%" />
        <div style="text-align:center; line-height:30px;">
            <div>群邀请码：<span style="font-family:微软雅黑; font-size:14pt; font-weight:bold;"><%=code %></span></div>
            <div>
                身为父母，你是否遇到过以下问题：
            </div>
            <div>
                孩子总是拖拉、磨蹭；
            </div>
            <div>
                孩子成绩突然下降；
            </div>
            <div>
                孩子总是在顶嘴；
            </div>
            <div>
                还有更多和孩子沟通中出现的问题，
            </div>
            <div>
                到底该怎么办？
            </div>
            <div>
                现在，终于有机会解开这些困惑！
            </div>
            <div>
                我们将有机会邀请著名教育专家卢勤老师，
            </div>
            <div>
                来到群里授课！
            </div>
            <div>
                卢勤老师是最懂孩子心灵的家庭教育专家，
            </div>
            <div>
                她是影响了千万家庭的“知心姐姐”。
            </div>
            <div>
                如果你支持“知心姐姐”卢勤老师来群里授课，
            </div>
            <div>
                请点击下面的支持按钮哦！
            </div>
            <div>群邀请码：<span style="font-family:微软雅黑; font-size:14pt; font-weight:bold;"><%=code %></span></div>
            <div>
                <a style="width:90px; height:40px; background:#E51925; color:#fff; display:block; line-height:40px; margin:30px auto 0; font-size:14pt; border-radius:5px;" onclick="SupportVote(this);">支 持</a>
            </div>
            <div style="text-align:center; font-size:11pt; color:#808080; font-family:微软雅黑;">已有<%=forward_count %>人支持</div>
        </div>
        <br /><br /><br />
    </div>
    <script type="text/javascript">
        function SupportVote(obj)
        {
            $(obj).css({ background: "#999", color: "#ccc" });
            alert("谢谢支持！");
        }
    </script>
</body>
</html>
