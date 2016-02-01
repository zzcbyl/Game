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
        currentLocalPath = Server.MapPath("../amr/");
        if (!File.Exists(currentLocalPath + @"\sounds\" + currentConvertMediaId + ".mp3"))
        {
            DownloadMedia();
            ConverAmrToMp3(int.Parse(Util.GetSafeRequestValue(Request,"vol","1")));
        }
       
        FileStream mp3Stream = File.OpenRead(currentLocalPath + @"\sounds\" + currentConvertMediaId + ".mp3");
        long length = mp3Stream.Length / 1000;
        mp3Stream.Close();
        Response.Write("{\"status\": 0   ,  \"duration\" : " + length.ToString() + " , \"mp3_url\" : \"http://game.luqinwenda.com/amr/sounds/" + currentConvertMediaId + ".mp3\"  }");
    }

    public  void DownloadMedia()
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


    public  void UpdateMp3Size(string mp3Path)
    {
        if (File.Exists(mp3Path))
        {
            FileStream mp3Stream = File.OpenRead(mp3Path);
            long length = mp3Stream.Length/1000;
            mp3Stream.Close();
            string[,] updateParameter = { { "voice_length", "int", length.ToString() } };
            string[,] keyParameter = { { "message_content", "varchar", currentConvertMediaId.Trim() } };
            DBHelper.UpdateData("chat_list", updateParameter, keyParameter, Util.ConnectionString.Trim());
        }
    }


    public  void ConverAmrToMp3(int vol)
    {
	
        if (File.Exists(currentLocalPath + @"\sounds\" + currentConvertMediaId + ".mp3"))
            File.Delete(currentLocalPath + @"\sounds\" + currentConvertMediaId + ".mp3");
        
        
        string command = currentLocalPath  + @"\ffmpeg" + " -i "
                + currentLocalPath + @"\sounds\" + currentConvertMediaId + ".amr   "
                + "  -af volume=" + vol.ToString() + "        " + currentLocalPath + @"\sounds\" + currentConvertMediaId + ".mp3";
        System.Diagnostics.Process process = new System.Diagnostics.Process();
        
        
        process.StartInfo.FileName = currentLocalPath + @"\ffmpeg.exe";
        process.StartInfo.Arguments = " -i "
                + currentLocalPath + @"\sounds\" + currentConvertMediaId + ".amr   "
                + "  -af volume=" + vol.ToString() + "        " + currentLocalPath + @"\sounds\" + currentConvertMediaId + ".mp3";
         
       
        process.StartInfo.UseShellExecute = false;
        process.StartInfo.RedirectStandardOutput = true;
        process.Start();
        
        StreamReader reader = process.StandardOutput;
       
        process.WaitForExit();
        process.Close();
        UpdateMp3Size(currentLocalPath + @"\sounds\" + currentConvertMediaId + ".mp3");
    }
    
</script>