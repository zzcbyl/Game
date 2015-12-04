using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.IO;
using System.Text;

/// <summary>
///HTTPHelper
/// </summary>
public class HTTPHelper
{
    //以GET方式获取内容
    public static string Get_Http(string tUrl)
    {
        string strResult;
        try
        {
            HttpWebRequest hwr = (HttpWebRequest)HttpWebRequest.Create(tUrl);
            hwr.Timeout = 19600;
            HttpWebResponse hwrs = (HttpWebResponse)hwr.GetResponse();
            Stream myStream = hwrs.GetResponseStream();
            StreamReader sr = new StreamReader(myStream, Encoding.UTF8);
            StringBuilder sb = new StringBuilder();
            while (-1 != sr.Peek())
            {
                sb.Append(sr.ReadLine() + "\r\n");
            }
            strResult = sb.ToString();
            hwrs.Close();
        }
        catch (Exception ee)
        {
            strResult = ee.Message;
        }
        return strResult;
    }

}