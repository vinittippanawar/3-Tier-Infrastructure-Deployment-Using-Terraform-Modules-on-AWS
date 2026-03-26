#!/bin/bash
apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
    <style>
        body {
            font-family: Arial;
            background-color: #f4f4f4;
            padding: 50px;
        }
        .container {
            width: 400px;
            background: white;
            padding: 20px;
            margin: auto;
            border-radius: 10px;
            box-shadow: 0 0 10px gray;
        }
        input {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
        }
        button {
            padding: 10px 15px;
            background: green;
            color: white;
            border: none;
            width: 100%;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Registration Form</h2>
        <form action="http://${app_private_ip}/submit.php" method="POST">
            <input type="text" name="name" placeholder="Enter Name" required>
            <input type="email" name="email" placeholder="Enter Email" required>
            <input type="text" name="phone" placeholder="Enter Phone" required>
            <button type="submit">Register</button>
        </form>
    </div>
</body>
</html>
EOF