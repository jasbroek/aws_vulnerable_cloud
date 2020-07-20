<?php
/*
 * Vulnerable SSRF proxy script. 
 * DO NOT USE IN PRODUCTION! 
 */
$content = '';
$placeholder = 'http://...';
if (isset($_POST['url']) && !empty($_POST['url'])){
    //Check if URL format is valid
    if (filter_var($_POST['url'], FILTER_VALIDATE_URL)){
            // Fetch the URL
            // Put response in $content
            $content = file_get_contents($_POST['url']);
            $placeholder = $_POST['url'];
    } else {
        $content = "This URL seems to be malformed...";
    }
}
?>

<head>
    <title>Secret internal proxy</title>
</head>
<body>
<h1>Useful internal proxy</h1>
<h2>Please use this fairly...</h2>

<form action="#" method='POST'>
  <label for="url">Please enter your URL</label><br>
  <input type="text" id="url" name="url" autocomplete="off" value="<?php echo $placeholder ?>"><br>
  <input type="submit" value="Submit">
</form> 

<hr>

<pre>
<?php echo $content ?>
</pre>

</body>