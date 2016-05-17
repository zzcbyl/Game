<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="NAudio.Wave" %>
<script runat="server">
    public  string currentConvertMediaId = "";

    public static string currentLocalPath;

    protected void Page_Load(object sender, EventArgs e)
    {

        currentConvertMediaId = Util.GetSafeRequestValue(Request, "mediaid", "FY_L-3szd_Pfwx8WC6_x5bEtpnEY6E_zk_Z8AapfbX4u-O9s64JXT0GAmsbxsuPJ");
        currentLocalPath = Server.MapPath("../download/");
        if (!File.Exists(currentLocalPath + @"\images\" + currentConvertMediaId + ".jpg"))
        {
            string filePath = currentLocalPath + @"\images\" + currentConvertMediaId + ".jpg";
            Util.DownloadMedia(currentConvertMediaId, filePath);
            Util.MakeThumbnail(filePath, currentLocalPath + @"\images\" + currentConvertMediaId + "_thumb.jpg", 200, 200, "H");
            Util.MakeThumbnail(filePath, currentLocalPath + @"\images\" + currentConvertMediaId + "_new.jpg", 1000, 1000, "W");
        }
        Response.Write("{\"status\": 0   ,  \"images_url\" : \"http://game.luqinwenda.com/download/images/" + currentConvertMediaId + ".jpg\"  }");
    }

</script>