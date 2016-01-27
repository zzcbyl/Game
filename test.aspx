<%@ Page Language="C#" %>
<%@ Import Namespace="System.Threading" %>
<!DOCTYPE html>

<script runat="server">

    public static string path = "";


    

    protected void Page_Load(object sender, EventArgs e)
    {
        
        /*
        path = Server.MapPath("amr");
        
        ThreadStart threadStart = new ThreadStart(ConverAmrToMp3);
        Thread thread = new Thread(threadStart);
        thread.Start();

        for (; thread.ThreadState == ThreadState.Running; )
        {
            Thread.Sleep(100);
        }
         * 
         */ 
        
    }

    public static void ConverAmrToMp3()
    {
        string command = path + @"\ffmpeg" + " -i "
                + path + @"\sounds\ring.amr" + "  " + path + @"\sounds\ring.mp3";

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

       // System.IO.StreamReader reader = process.StandardOutput;//截取输出流           

        //string str = reader.ReadToEnd();

        //reader.Close();

        //Response.Write(str);

        process.WaitForExit();
    }
    
    
    
</script>
<html>
    <head>
        <script type="text/javascript" >

           
        </script>
    </head>
    <body>
        <audio id="media" src="http://game.luqinwenda.com/amr/sounds/ci-bzqVL7zdNMd_CL0KOyb9kY6kaHrBuTuAOzNRsTUURzuVJfeCJoQCbq_uSdFW4.mp3" loop="true" ></audio>
        <script type="text/javascript" >
            var m = document.getElementById("media");
            m.pause();

        </script>
    </body>
</html>