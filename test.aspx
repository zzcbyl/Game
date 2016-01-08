<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string command = Server.MapPath(@"amr\ffmpeg") +" -i "
            + Server.MapPath(@"amr\sounds\ring.amr") +"  " + Server.MapPath(@"amr\sounds\ring.mp3");
   
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

        System.IO.StreamReader reader = process.StandardOutput;//截取输出流           

        string str = reader.ReadToEnd();

        reader.Close();

        Response.Write(str);
        
        process.WaitForExit();
    }
    
    
    
</script>