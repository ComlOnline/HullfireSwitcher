<?php
// maximum error verbosity
error_reporting(E_ALL);


$sys = strtolower($_SERVER['SERVER_SOFTWARE']);
$ctlPort = 1234;


// Function to get # of processors, and load, if both are available
// RETURNS:
//   string with status/info if we can get it
//   FALSE if we can't get info/status
function cpu_stat() {
  if (!file_exists('/bin/grep'))
    return(false);
  if (!is_readable('/bin/grep'))
    return(false);
  if (!file_exists('/proc/cpuinfo'))
    return(false);
  if (!is_readable('/proc/cpuinfo'))
    return(false);
  if (!file_exists('/proc/loadavg'))
    return(false);
  if (!is_readable('/proc/loadavg'))
    return(false);
  $dum = explode('.',`hostname`);
  $a = trim($dum[0]);
  $dun = explode("\n",rtrim(`/bin/grep 'processor' /proc/cpuinfo`));
  $b = strval(count($dun));
  $tmp = explode(" ",file_get_contents('/proc/loadavg'));
  $c = strval($tmp[0]);
  $d = strval($tmp[1]);
  $e = strval($tmp[2]);
  $command="/sbin/ifconfig | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' | tr '\n' ' '";
  $localIP = exec ($command);
  if ($b != 1)
    return("On Linux-compatible host &quot;$a&quot;<br>with $b processors, <b style=\"font-style: normal;\">loads: $c $d $e</b>");
  return("On Linux-compatible host &quot;$a&quot;<br>with $b processor, <b style=\"font-style: normal;\">loads: $c $d $e</b>");
}
?>



<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8">
<title>Hullfire Switcher</title>
</head>
<body bgcolor="#ffffff" text="#ff0000" link="red" alink="red" vlink="purple">




<?php
 function soap_radio() {
        global $ctlPort;
    $fp = stream_socket_client("tcp://localhost:$ctlPort", $errno, $errstr, 20);
    if (!$fp) {
                return("<b><u>TELNET FAILURE:</u> $errstr ($errno)</b><br>");
    }   else {
                fwrite($fp, "var.set unionautodj = false\nquit\n");
                $eat = '';
                while (!feof($fp)) {
                        $eat .= fgets($fp, 1024);
                }
                fclose($fp);
                return("<b><u>GREAT:</u> Sent the Telnet command!  STUDIO 1 is set as ON-AIR</b><br>");
    }
  }

  function soap_autodj() {
        global $ctlPort;
    $fp = stream_socket_client("tcp://localhost:$ctlPort", $errno, $errstr, 20);
    if (!$fp) {
                return("<b><u>TELNET FAILURE:</u> $errstr ($errno)</b><br>");
    }   else {
                fwrite($fp, "var.set unionautodj = true\nquit\n");
                $eat = '';
                while (!feof($fp)) {
                        $eat .= fgets($fp, 1024);
                }
                fclose($fp);
                return("<b><u>GREAT:</u> Sent the Telnet command!  The AutoDJ is set as ON-AIR</b><br>");
    }
  }


  function stl($aString) {
    return(strtolower($aString));
  }
  
  $msg = '';
  if (isset($_REQUEST['act'])) {
    $act = $_REQUEST['act'];
  } else {
    $act = '';
  }
  if ($act == 'radio') {
      $msg .= soap_radio();
	}elseif($act == 'AutoDJ') {
      $msg .= soap_autodj();
	}else {
      if ($act != '') {
        $msg .= '<b><u>ERROR:</u> The Command Given Is Unknown!</b><br>';
      }
    }
  
?>
<table width="100%" border="16" cellspacing="4" cellpadding="1">
<tr>
<td valign="middle" align="center">
<p><img src="hflogo.png" alt="Smiley face" style="float:left;width:450px;height:150px;">
<h2>Welcome to the UNION Hullfire Audio switcher.<br>Please contact Colm if it goes wrong.<br>This is for Joes use only!</h2></p>

</td>
<td valign="middle" align="center">
<h4 style="font-weight: normal; font-style: italic;">
<?php
if (cpu_stat())
  echo(cpu_stat());
?>
<br>
<?php
$command="/sbin/ifconfig | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' | tr '\n' ' '";
$localIP = exec ($command);
echo $localIP;
?>
<br>
<a href="http://hfr-vh1-centswitch.hull.ac.uk/union.php">Refresh</a>
</h4>

</td>
</tr>
<tr>
<td colspan="2" valign="top" align="left">
<h2 align="center">
<?php
    echo date('l jS \of F Y H:i:s');
?>
</h2>
</td>
</tr>
<tr>
<td colspan="2" valign="top" align="left">
<h2 align="center">Please select a Source</h2>

</td>
</tr>

<tr>
<td colspan="2" valign="top" align="left">
<?php
    echo($msg);
?>
<form action="<?php echo(basename(__FILE__)); ?>" method=POST>
<input type="submit" name="Clear This" value="Clear This">
</form>
</td>
</tr>
<?php
  

{echo('<tr><td colspan="2" valign="top" align="center">'
        .'<a href="'.basename(__FILE__).'?act=radio">'
        .'Click Here to Activate radio output'
        .'</a></td></tr>'."\n");
}
{echo('<tr><td colspan="2" valign="top" align="center">'
        .'<a href="'.basename(__FILE__).'?act=AutoDJ">'
        .'Click Here to Activate AutoDJ'
        .'</a></td></tr>'."\n");
}
?>
<tr>
<td colspan="2" valign="middle" align="center">
This script is a product of <a href="http://www.quinnebert.net/">Quinn Ebert</a> Software Creations   ...But has been brutally modified for this purpose by Colm Simpson<br>
<span>Liquidsoap Requester</span> by <a href="http://www.quinnebert.net/" rel="cc:attributionURL">Quinn Ebert</a> (and this modification) is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/us/">Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License</a></p>
</td>
</tr>
</table>
</body>
</html>
<?php
  // My work here is done!
  die();
