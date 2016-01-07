<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string name = Request["filename"];
        Stream fs = Request.InputStream;
        byte[] b = new byte[1024 * 1024];
        fs.Read(b, 0, b.Length);
        File.WriteAllBytes(Server.MapPath("/test/" + name + ".wav"), b);
    }
</script>