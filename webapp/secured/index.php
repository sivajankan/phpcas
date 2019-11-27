<?php
  $email_tmp = $_SERVER['REMOTE_USER'];
  $name = substr($email_tmp, 0, strpos($email_tmp, "@"));

  $cas_server = $_SERVER['CAS_SERVER'];

  print_r($_SERVER);

  echo "<pre>";

    if (array_key_exists('REMOTE_USER', $_SERVER)) {
        echo "REMOTE_USER = " . $_SERVER['REMOTE_USER'] . "<br>";
    }

    $headers = getallheaders();
    foreach ($headers as $key => $value) {
        if (strpos($key, 'CAS_') === 0) {
            echo substr($key, 4) . " = " . $value . "<br>";
        }
    }

  echo "</pre>";
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

    <title>phpCas Test</title>
    <link href="/static/css/cas.css" rel="stylesheet" th:href="@{${#themes.code('cas.standard.css.file')}}" />
</head>

<body>

<div><?= $name; ?></div>
<h3>Welcome</h3>

</body>
</html>