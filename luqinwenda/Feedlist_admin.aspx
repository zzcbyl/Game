<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html>

<script runat="server">
    public int roomid = 0;
    public DataTable FeedListDt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["admin"] != "admin_123")
        {
            Response.End();
            return;
        }
        roomid = int.Parse(Util.GetSafeRequestValue(Request, "roomid", "0"));
        if (roomid <= 0)
        {
            Response.Write("参数错误");
            Response.End();
        }
        if (Request["hidAction"] != null && Request["hidID"] != "")
        {
            int auditstate = 0;
            if (Request["hidAction"].Trim() == "pass")
                auditstate = 1;
            else if (Request["hidAction"].Trim() == "refuse")
                auditstate = 2;

            ChatTimeLine.Audit_State(int.Parse(Request["hidID"].ToString()), auditstate);
        }

        FeedListDt = ChatTimeLine.GetChatList_Admin_Audit(roomid, "text", 1);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="../style/bootstrap.min.css" rel="stylesheet" />
    <script src="../script/jquery-2.1.1.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width:80%; margin:20px auto; padding:10px; background:#e6e4e4;">
        <% foreach (DataRow row in FeedListDt.Rows)
           {
               %>
        <div style="line-height:30px; border-bottom:1px dashed #fff; padding:10px 0;">
            <div style="width:70%; float:left;">
                 <%=row["message_content"].ToString() %>
            </div>
            <div style="width:30%; float:left; text-align:center">
                <%--<input type="button" value="通过" class="btn btn-success" onclick='pass(<%=row["id"].ToString() %>)' />　　--%>
                <input type="button" value="删除" class="btn btn-danger" onclick='refuse(<%=row["id"].ToString() %>)' />
            </div>
            <div style="clear:both;"></div>
        </div>
        <% } %>
        <input type="hidden" id="hidID" name="hidID" value="" />
        <input type="hidden" id="hidAction" name="hidAction" value="" />
    </div>
    </form>
    <script type="text/javascript">

        $(document).ready(function () {
            setInterval(function(){location.href=document.URL.toString();},10000);
        });

        function pass(id)
        {
            
            $('#hidID').val(id.toString());
            $('#hidAction').val("pass");
            document.forms[0].submit();
        }
        function refuse(id)
        {
            $('#hidID').val(id);
            $('#hidAction').val("refuse");
            document.forms[0].submit();
        }
    </script>
</body>
</html>
