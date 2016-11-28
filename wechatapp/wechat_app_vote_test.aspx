<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string avatar = Util.GetSafeRequestValue(Request, "avatar", "unknown");
        string nick = Util.GetSafeRequestValue(Request, "nick", "whoknows");
        string content = Util.GetSafeRequestValue(Request, "content", "美国大大削弱，对中国有利。");
        string[,] insertParam = { { "nick", "varchar", nick }, { "avatar", "varchar", avatar }, { "content", "varchar", content } };
        int i = DBHelper.InsertData("wechatapp_vote_test", insertParam, Util.ConnectionString);
        if (i == 1)
        {
            Response.Write("{\"message\" : \"投票成功！\"}");
        }
        else
        {
            Response.Write("{\"message\" : \"您已经投过票了！\"}");
        }
    }
</script>