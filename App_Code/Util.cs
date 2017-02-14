using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Security.Cryptography;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;
using System.Drawing;
using System.Drawing.Drawing2D;
/// <summary>
/// Summary description for Util
/// </summary>
public class Util
{

    public static string ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["constr"].Trim();
    public static string ConnectionStringMall = System.Configuration.ConfigurationSettings.AppSettings["constrMall"].Trim();
    public static string ConnectionStringWX = System.Configuration.ConfigurationSettings.AppSettings["constrWX"].Trim();
    protected static string token = "";
    protected static DateTime tokenTime = DateTime.MinValue;
    public static string DomainName = System.Configuration.ConfigurationSettings.AppSettings["domain_name"].Trim();
    //public static int LuqinwendaRoomId = int.Parse(System.Configuration.ConfigurationSettings.AppSettings["Luqinwenda_Chat_RoomId"].Trim());
    //public static string LuqinwendaExpertList = System.Configuration.ConfigurationSettings.AppSettings["Luqinwenda_expert_Idlist"].Trim();

	public Util()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static string GetSHA1(string str)
    {
        SHA1 sha = SHA1.Create();
        ASCIIEncoding enc = new ASCIIEncoding();
        byte[] bArr = enc.GetBytes(str);
        bArr = sha.ComputeHash(bArr);
        string validResult = "";
        for (int i = 0; i < bArr.Length; i++)
        {
            validResult = validResult + bArr[i].ToString("x").PadLeft(2, '0');
        }
        return validResult.Trim();
    }

    public static string GetMd5(string str)
    {
        System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create();
        byte[] bArr = md5.ComputeHash(Encoding.UTF8.GetBytes(str));
        string ret = "";
        foreach (byte b in bArr)
        {
            ret = ret + b.ToString("x").PadLeft(2, '0');
        }
        return ret;
    }

    public static string GetLongTimeStamp(DateTime currentDateTime)
    {
        TimeSpan ts = currentDateTime - new DateTime(1970, 1, 1, 0, 0, 0, 0);
        return Convert.ToInt64(ts.TotalMilliseconds).ToString();
    }

    public static string GetTimeStamp()
    {
        TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
        return Convert.ToInt64(ts.TotalSeconds).ToString();
    }
    public static string GetWebContent(string url, string method, string content, string contentType)
    {
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
        req.Method = method.Trim();
        req.ContentType = contentType;
        if (!content.Trim().Equals(""))
        {
            StreamWriter sw = new StreamWriter(req.GetRequestStream());
            sw.Write(content);
            sw.Close();
        }
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        Stream s = res.GetResponseStream();
        StreamReader sr = new StreamReader(s);
        string str = sr.ReadToEnd();
        sr.Close();
        s.Close();
        res.Close();
        req.Abort();
        return str;
    }


    public static string GetToken()
    {
        try
        {
            return GetWebContent("http://weixin.luqinwenda.com/dingyue/get_token.aspx", "get", "", "html/xml");
        }
        catch
        {
            System.Threading.Thread.Sleep(500);
            return GetWebContent("http://weixin.luqinwenda.com/dingyue/get_token.aspx", "get", "", "html/xml");
        }
    }
    /*
    public static string ForceGetToken()
    {
        DateTime nowDate = DateTime.Now;
        token = GetAccessToken(System.Configuration.ConfigurationManager.AppSettings["wxappid"].Trim(),
                System.Configuration.ConfigurationManager.AppSettings["wxappsecret"].Trim());
        tokenTime = nowDate;
        return token;

    }*/

    public static string GetAccessToken(string appId, string appSecret)
    {
        string token = "";
        string url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" + appId.Trim() + "&secret=" + appSecret.Trim();
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        Stream s = res.GetResponseStream();
        string ret = (new StreamReader(s)).ReadToEnd();
        s.Close();
        res.Close();
        req.Abort();

        JavaScriptSerializer serializer = new JavaScriptSerializer();
        Dictionary<string, object> json = (Dictionary<string, object>)serializer.DeserializeObject(ret);
        object v;
        json.TryGetValue("access_token", out v);
        token = v.ToString();

        return token;
    }

    public static string GetSimpleJsonValueByKey(string jsonStr, string key)
    {
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        Dictionary<string, object> json = (Dictionary<string, object>)serializer.DeserializeObject(jsonStr);
        object v;
        json.TryGetValue(key, out v);
        return v.ToString();
    }

    public static string ConvertDataTableToJson(DataTable dt)
    {
        string json = "";
        foreach (DataRow dr in dt.Rows)
        {
            string jsonItem = "";
            foreach (DataColumn dc in dt.Columns)
            {
                if (jsonItem.Trim().Equals(""))
                {
                    jsonItem = " \"" + dc.Caption.Trim() + "\" : \"" + dr[dc].ToString().Trim().Replace("\r","").Replace("\n","").Replace("\t","").Replace("\"","\\\"").Trim() + "\" ";
                }
                else
                {
                    jsonItem = jsonItem + ", \"" + dc.Caption.Trim() + "\" : \"" + dr[dc].ToString().Trim().Replace("\r", "").Replace("\n", "").Replace("\t","").Replace("\"", "\\\"").Trim() + "\" ";
                }
            }
            if (json.Trim().Equals(""))
            {
                json = "{" + jsonItem + "}";
            }
            else
            {
                json = json + ",{" + jsonItem + "}";
            }
        }
        return " [" + json + "] ";
    }

    public static string GetSafeRequestValue(HttpRequest request, string parameterName, string defaultValue)
    {
        return ((request[parameterName] == null || request[parameterName] == "") ? defaultValue : request[parameterName].Trim()).Replace("'", "");
    }

    public static string GetSafeRequestFormValue(HttpRequest request, string parameterName, string defaultValue)
    {
        return ((request.Form[parameterName] == null || request.Form[parameterName] == "") ? defaultValue : request.Form[parameterName].Trim()).Replace("'", "");
    }

    /// <summary>创建规定大小的图像 
    /// </summary> 
    /// <param name="oPath">源图像绝对路径</param> 
    /// <param name="tPath">生成图像绝对路径</param> 
    /// <param name="width">生成图像的宽度</param> 
    /// <param name="height">生成图像的高度</param> 
    public static void CreateImageOutput(int width, int height, string oPath, string tPath)
    {
        Bitmap originalBmp = new Bitmap(oPath);
        //originalBmp = new Bitmap(System.Drawing.Image.FromFile(oPath));
        // 源图像在新图像中的位置 
        int left, top;

        // 新图片的宽度和高度，如400*200的图像，想要生成160*120的图且不变形， 
        // 那么生成的图像应该是160*80，然后再把160*80的图像画到160*120的画布上 
        int newWidth, newHeight;
        if (width * originalBmp.Height < height * originalBmp.Width)
        {
            newWidth = (int)Math.Round((decimal)originalBmp.Width * height / originalBmp.Height);
            newHeight = height;
            
            // 缩放成宽度跟预定义的宽度相同的，即left=0，计算top 
            left = (int)Math.Round((decimal)(width - newWidth) / 2);
            top = 0;
        }
        else
        {
            newWidth = width;
            newHeight = (int)Math.Round((decimal)originalBmp.Height * width / originalBmp.Width);
            // 缩放成高度跟预定义的高度相同的，即top=0，计算left 
            left = 0;
            top = (int)Math.Round((decimal)(height - newHeight) / 2); ;
        }

        // 生成按比例缩放的图，如：160*80的图 
        Bitmap bmpOut2 = new Bitmap(newWidth, newHeight);
        using (Graphics graphics = Graphics.FromImage(bmpOut2))
        {
            graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
            graphics.FillRectangle(Brushes.White, 0, 0, newWidth, newHeight);
            graphics.DrawImage(originalBmp, 0, 0, newWidth, newHeight);
        }

        // 再把该图画到预先定义的宽高的画布上，如160*120 
        Bitmap lastbmp = new Bitmap(width, height);
        using (Graphics graphics = Graphics.FromImage(lastbmp))
        {
            // 设置高质量插值法 
            graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
            // 清空画布并以白色背景色填充 
            graphics.Clear(Color.White);
            //加上边框 
            //Pen pen = new Pen(ColorTranslator.FromHtml("#cccccc")); 
            //graphics.DrawRectangle(pen, 0, 0, width - 1, height - 1); 
            // 把源图画到新的画布上 
            graphics.DrawImage(bmpOut2, left, top);
        }

        lastbmp.Save(tPath);//保存为文件，tpath 为要保存的路径 
        //this.OutputImgToPage(bmpOut2);//直接输出到页面 
        originalBmp.Dispose();
        bmpOut2.Dispose();
        lastbmp.Dispose();
    }

    public static string ticket = string.Empty;
    public static DateTime ticketTime = DateTime.MinValue;
    public static string GetTicket()
    {
        if (ticketTime == DateTime.MinValue || ticketTime < DateTime.Now)
        {
            try
            {
                string jsonStrForTicket = Util.GetWebContent("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token="
                        + Util.GetToken() + "&type=jsapi", "get", "", "form-data");
                ticket = Util.GetSimpleJsonValueByKey(jsonStrForTicket, "ticket");
                ticketTime = DateTime.Now.AddMinutes(10);
            }
            catch { }
        }
        return ticket;
    }



    public static void DownloadMedia(string currentConvertMediaId, string filePath)
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

    /**/
    /// <summary> 
    /// 生成缩略图 
    /// </summary> 
    /// <param name="originalImagePath">源图路径（物理路径）</param> 
    /// <param name="thumbnailPath">缩略图路径（物理路径）</param> 
    /// <param name="width">缩略图宽度</param> 
    /// <param name="height">缩略图高度</param> 
    /// <param name="mode">生成缩略图的方式</param>     
    public static void MakeThumbnail(string originalImagePath, string thumbnailPath, int width, int height, string mode)
    {
        Image originalImage = Image.FromFile(originalImagePath);

        int towidth = width;
        int toheight = height;

        int x = 0;
        int y = 0;
        int ow = originalImage.Width;
        int oh = originalImage.Height;

        switch (mode)
        {
            case "HW"://指定高宽缩放（可能变形）                 
                break;
            case "W"://指定宽，高按比例                     
                toheight = originalImage.Height * width / originalImage.Width;
                break;
            case "H"://指定高，宽按比例 
                towidth = originalImage.Width * height / originalImage.Height;
                break;
            case "Cut"://指定高宽裁减（不变形）                 
                if ((double)originalImage.Width / (double)originalImage.Height > (double)towidth / (double)toheight)
                {
                    oh = originalImage.Height;
                    ow = originalImage.Height * towidth / toheight;
                    y = 0;
                    x = (originalImage.Width - ow) / 2;
                }
                else
                {
                    ow = originalImage.Width;
                    oh = originalImage.Width * height / towidth;
                    x = 0;
                    y = (originalImage.Height - oh) / 2;
                }
                break;
            default:
                break;
        }

        //新建一个bmp图片 
        Image bitmap = new System.Drawing.Bitmap(towidth, toheight);

        //新建一个画板 
        Graphics g = System.Drawing.Graphics.FromImage(bitmap);

        //设置高质量插值法 
        g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;

        //设置高质量,低速度呈现平滑程度 
        g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;

        //清空画布并以透明背景色填充 
        g.Clear(Color.Transparent);

        //在指定位置并且按指定大小绘制原图片的指定部分 
        g.DrawImage(originalImage, new Rectangle(0, 0, towidth, toheight),
            new Rectangle(x, y, ow, oh),
            GraphicsUnit.Pixel);

        try
        {
            //以jpg格式保存缩略图 
            bitmap.Save(thumbnailPath, System.Drawing.Imaging.ImageFormat.Jpeg);
        }
        catch (System.Exception e)
        {
            throw e;
        }
        finally
        {
            originalImage.Dispose();
            bitmap.Dispose();
            g.Dispose();
        }
    }
}