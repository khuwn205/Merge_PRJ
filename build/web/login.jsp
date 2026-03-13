<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập hệ thống</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #74ebd5 0%, #acb6e5 100%);
            height: 100vh;
            display: flex;
        }

        /* Layout 2 cột */
        .left-section {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px;
        }

        .left-section h1 {
            color: white;
            font-size: 42px;
            font-weight: bold;
            text-align: center;
            line-height: 1.4;
            text-shadow: 2px 4px 10px rgba(0,0,0,0.2);
        }

        .right-section {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container {
            background-color: #ffffff;
            width: 100%;
            max-width: 400px;
            padding: 40px 30px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            box-sizing: border-box;
        }

        .login-container h2 {
            text-align: center;
            color: #333333;
            margin-bottom: 30px;
            font-size: 28px;
        }

        .error-message {
            background-color: #ffe6e6;
            color: #d93025;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
            text-align: center;
            border: 1px solid #f5c6c6;
            display: ${not empty error ? 'block' : 'none'};
        }

        .input-group {
            margin-bottom: 20px;
        }

        .input-group label {
            display: block;
            margin-bottom: 8px;
            color: #555555;
            font-weight: 500;
            font-size: 14px;
        }

        .input-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #cccccc;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 15px;
            transition: border-color 0.3s ease;
        }

        .input-group input:focus {
            outline: none;
            border-color: #74ebd5;
            box-shadow: 0 0 5px rgba(116, 235, 213, 0.5);
        }

        .btn-login {
            width: 100%;
            padding: 14px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 10px;
        }

        .btn-login:hover {
            background-color: #0056b3;
        }

        .register-section {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #eeeeee;
        }

        .register-section p {
            color: #666666;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .btn-register {
            display: inline-block;
            text-decoration: none;
            color: #007bff;
            font-weight: bold;
            font-size: 15px;
            padding: 10px 20px;
            border: 2px solid #007bff;
            border-radius: 6px;
            transition: all 0.3s ease;
        }

        .btn-register:hover {
            background-color: #007bff;
            color: white;
        }

        /* Responsive cho màn hình nhỏ */
        @media (max-width: 900px) {
            body {
                flex-direction: column;
            }

            .left-section {
                padding: 20px;
            }

            .left-section h1 {
                font-size: 28px;
            }
        }
    </style>
</head>
<body>

    <!-- BÊN TRÁI -->
    <div class="left-section">
        <h1>Hệ Thống Quản Lý<br>Thất Lạc Đồ Trong Trường Học</h1>
    </div>

    <!-- BÊN PHẢI -->
    <div class="right-section">
        <div class="login-container">
            <h2>Đăng nhập</h2>

            <div class="error-message">
                ${error}
            </div>

            <form action="login" method="POST">
                <div class="input-group">
                    <label for="username">Tên đăng nhập</label>
                    <input type="text" id="username" name="username" placeholder="Nhập tên tài khoản" required>
                </div>

                <div class="input-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                </div>

                <button type="submit" class="btn-login">Đăng nhập</button>
            </form>

            <div class="register-section">
                <p>Bạn chưa có tài khoản?</p>
                <a href="register.jsp" class="btn-register">Đăng ký tài khoản</a>
            </div>
        </div>
    </div>

</body>
</html>