<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <audio controls="controls" autoplay="autoplay" id="audio_player" >
            <source src="http://game.luqinwenda.com/upload/voice/luqinwenda-wkt_0614.mp3" type="audio/mpeg">
            Your browser does not support the audio element.
        </audio>
    </div>
    </form>
    <script type="text/javascript" >

        var broadcast_start_date = new Date(2016, 5, 27, 15, 0, 0, 0);
        var current_time = new Date();
        //alert(broadcast_start_date);
        //alert(current_time);
        //alert((current_time - broadcast_start_date)/1000);
        current_time = (current_time - broadcast_start_date) / 1000;
        var can_play = true;
        
        var audio_player = document.getElementById("audio_player");
      
        audio_player.onplay = function () {
            audio_player.currentTime = current_time;
            //alert(audio_player.duration);
            if (!can_play) {
                audio_player.pause();
            }
        }
    </script>
</body>
</html>
