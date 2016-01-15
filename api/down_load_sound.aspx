<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">
    public static string currentConvertMediaId = "";

    public static string currentLocalPath;

    protected void Page_Load(object sender, EventArgs e)
    {

        currentConvertMediaId = Util.GetSafeRequestValue(Request, "mediaid", "FJezE4AD_o_6yY2hY7o3TUMAZnv3_CM3rKRfQmcaubcx3qusSueMPUtH4QiifoS2");
        currentLocalPath = Server.MapPath("../amr/");
        //if (!File.Exists(currentLocalPath + @"\sounds\" + currentConvertMediaId + ".wav"))
        //{
            DownloadMedia();
            ConverAmrToMp3(int.Parse(Util.GetSafeRequestValue(Request,"vol","1")), int.Parse(Util.GetSafeRequestValue(Request,"nr","500")));
        //}
        Response.Write("{\"status\": 0 , \"mp3_url\" : \"http://game.luqinwenda.com/amr/sounds/" + currentConvertMediaId + ".mp3\" }");
    }

    public static void DownloadMedia()
    {
        string token = Util.GetToken();
        string amrUrl = "http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=" + token.Trim() + "&media_id=" + currentConvertMediaId.Trim();
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(amrUrl);
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        Stream s = res.GetResponseStream();
        byte[] byteArr = new byte[1024 * 1024 * 10];
        int i = 0;
        int b = s.ReadByte();
        for (; b != -1; i++)
        {
            byteArr[i] = (byte)b;
            b = s.ReadByte();
        }
        string filePath = currentLocalPath + @"\sounds\" + currentConvertMediaId + ".amr";
        FileStream fs;
        if (!File.Exists(filePath))
        {
            fs = File.Create(filePath);
        }
        else
        {
            File.Delete(filePath);
            fs = File.Create(filePath);
        }
        for (int j = 0; j < i; j++)
        {
            fs.WriteByte(byteArr[j]);
        }
        fs.Close();
        
    }



    public static void ConverAmrToMp3(int vol, int nr)
    {
	
        if (File.Exists(currentLocalPath + @"\sounds\" + currentConvertMediaId + ".mp3"))
            File.Delete(currentLocalPath + @"\sounds\" + currentConvertMediaId + ".mp3");
        
        
        string command = currentLocalPath  + @"\ffmpeg" + " -i "
                + currentLocalPath + @"\sounds\" + currentConvertMediaId + ".amr   "
                + "  -af volume=" + vol.ToString() + "        " + currentLocalPath + @"\sounds\" + currentConvertMediaId + ".mp3";
        System.Diagnostics.Process process = new System.Diagnostics.Process();
        process.StartInfo.FileName = "cmd.exe";
        process.StartInfo.UseShellExecute = false;
        process.StartInfo.CreateNoWindow = true;
        process.StartInfo.RedirectStandardOutput = true;
        process.StartInfo.RedirectStandardInput = true;
        process.Start();
        process.StandardInput.WriteLine(command);
        process.StandardInput.AutoFlush = true;
        process.StandardInput.WriteLine("exit");
        process.WaitForExit();
    }
    
</script>