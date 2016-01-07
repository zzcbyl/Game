<?php

  if(!isset($_REQUEST['filename']))
   {
     exit('No file');
   }

   $upload_path = 'http://127.0.0.1:882/';

   $filename = $_REQUEST['filename'];

   $fp = fopen("./".$filename.".wav", "wb");

   fwrite($fp, file_get_contents('php://input'));

   fclose($fp);

   exit('done');


?>