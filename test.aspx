<%@ Page Language="C#" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html>

<script runat="server">

    public static string path = "";


    

    protected void Page_Load(object sender, EventArgs e)
    {

        string path = Server.MapPath("amr/sounds/FJezE4AD_o_6yY2hY7o3TUMAZnv3_CM3rKRfQmcaubcx3qusSueMPUtH4QiifoS2.mp3");
        NAudio.Wave.Mp3FileReader reader = new NAudio.Wave.Mp3FileReader(path);

        Response.Write(reader.TotalTime.ToString());
        
        /*
        using (FileStream fs = File.OpenRead(path))
        {
            NAudio.Wave.Mp3Frame frame = NAudio.Wave.Mp3Frame.LoadFromStream(fs);
            while (frame != null)
            {
                if (frame.ChannelMode == NAudio.Wave.ChannelMode.Mono)
                {
                    duration += frame.SampleCount / frame.SampleRate;
                }
                else
                {
                    duration += frame.SampleCount * 2 / frame.SampleRate;
                } 
            }
        }*/

        //Response.Write(duration.ToString());
        
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
           
            function show_duration() {
                
                alert(m.duration);
            }
           
        </script>
    </head>
    <body>
        <audio id="media" controls="controls"  loop="true" oncanplay="show_duration()" >
            <source src="http://game.luqinwenda.com/amr/sounds/ci-bzqVL7zdNMd_CL0KOyb9kY6kaHrBuTuAOzNRsTUURzuVJfeCJoQCbq_uSdFW4.mp3" type="audio/mp3" />
        </audio><br />
        <input type="button" onclick="show_duration()" value="show duration" />
        <script type="text/javascript" >
            var m = document.getElementById("media");
            //alert(m.duration);
        </script>
    </body>
</html>