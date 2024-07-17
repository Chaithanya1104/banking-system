<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
    <link rel="stylesheet" type="text/css" href="./css/AdminLogin.css">
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            background-color: #f0f0f0;
        }
        .login-container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 400px;
            text-align: center;
        }
        .login-container h2 {
            margin-bottom: 20px;
            font-size: 42px;
            color: #0010f0;
            font-style: italic;
        }
        .login-container label {
            display: block;
            margin-bottom: 5px;
            font-size: 16px;
        }
        .login-container input[type="text"], 
        .login-container input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }
        .login-container input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #0010f0;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 18px;
            cursor: pointer;
        }
        .login-container input[type="submit"]:hover {
            background-color: #0000d0;
        }
        .background-image {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: -1;
        }
    </style>
</head>
<body>

    <img src="https://t3.ftcdn.net/jpg/04/17/77/78/360_F_417777825_v7o8RvkQhxpZkE0ZBD4xwzri5hGFHkO3.jpg"  class="background-image">

    <div class="login-container">
        <h2>Admin Login</h2>
        <form action="AdminOperations.jsp" method="post">
            <label for="adminUsername">Username:</label>
            <input type="text" id="adminUsername" name="adminUsername" required><br>
            
            <label for="adminPassword">Password:</label>
            <input type="password" id="adminPassword" name="adminPassword" required><br>
            
            <input type="submit" value="Login">
        </form>
    </div>

    <script>
        history.pushState(null, null, document.URL);
        window.addEventListener('popstate', function () {
            history.pushState(null, null, document.URL);
        });
    </script>
</body>
</html>