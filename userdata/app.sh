#!/bin/bash
apt update -y
apt install apache2 php php-mysql mysql-client -y
systemctl enable apache2
systemctl start apache2

cat <<EOF > /var/www/html/submit.php
<?php
\$host = "REPLACE_RDS_ENDPOINT";
\$user = "admin";
\$pass = "Pass12345";
\$db   = "userdb";

\$conn = new mysqli(\$host, \$user, \$pass, \$db);

if (\$conn->connect_error) {
    die("Connection failed: " . \$conn->connect_error);
}

\$name  = \$_POST['name'];
\$email = \$_POST['email'];
\$phone = \$_POST['phone'];

\$sql = "INSERT INTO users (name, email, phone) VALUES ('\$name', '\$email', '\$phone')";

if (\$conn->query(\$sql) === TRUE) {
    echo "<h2>Registration Successful!</h2>";
} else {
    echo "Error: " . \$conn->error;
}

\$conn->close();
?>
EOF