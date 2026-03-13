<%-- 
    Document   : register
    Created on : Mar 2, 2026, 10:08:14 AM
    Author     : HungKNHE194779
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản</title>
    <style>
        /* CSS Thuần đồng bộ với trang Đăng nhập */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #74ebd5 0%, #acb6e5 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .register-container {
            background-color: #ffffff;
            width: 100%;
            max-width: 500px; /* Rộng hơn trang login một chút vì có nhiều trường */
            padding: 35px 30px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            box-sizing: border-box;
            margin: 20px 0;
        }

        .register-container h2 {
            text-align: center;
            color: #333333;
            margin-bottom: 25px;
            font-size: 28px;
            margin-top: 0;
        }

        /* Khung hiển thị lỗi từ request.setAttribute("ERROR", ...) */
        .error-message {
            background-color: #ffe6e6;
            color: #d93025;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
            text-align: center;
            border: 1px solid #f5c6c6;
            display: ${not empty ERROR ? 'block' : 'none'};
        }

        .form-row {
            display: flex;
            gap: 15px;
        }

        .input-group {
            margin-bottom: 18px;
            flex: 1;
        }

        .input-group label {
            display: block;
            margin-bottom: 6px;
            color: #555555;
            font-weight: 500;
            font-size: 14px;
        }

        .input-group input {
            width: 100%;
            padding: 11px 15px;
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

        .btn-register-submit {
            width: 100%;
            padding: 14px;
            background-color: #28a745; /* Màu xanh lá cho hành động Đăng ký */
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 10px;
        }

        .btn-register-submit:hover {
            background-color: #218838;
        }

        .login-section {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #eeeeee;
        }

        .login-section p {
            color: #666666;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .btn-login-link {
            display: inline-block;
            text-decoration: none;
            color: #28a745;
            font-weight: bold;
            font-size: 15px;
            padding: 10px 20px;
            border: 2px solid #28a745;
            border-radius: 6px;
            transition: all 0.3s ease;
        }

        .btn-login-link:hover {
            background-color: #28a745;
            color: white;
        }

        /* Đảm bảo responsive tốt trên điện thoại di động */
        @media (max-width: 480px) {
            .form-row {
                flex-direction: column;
                gap: 0;
            }
        }
    </style>
</head>
<body>

    <div class="register-container">
        <h2>Tạo tài khoản mới</h2>

        <!-- Hiển thị lỗi từ request.setAttribute("ERROR", ...) -->
        <div class="error-message">
            ${ERROR}
        </div>

        <!-- 
            LƯU Ý: Thay đổi action="RegisterServlet" cho khớp với đường dẫn URL Servlet của bạn.
        -->
        <form action="register" method="POST">
            
            <div class="input-group">
                <label for="username">Tên đăng nhập <span style="color:red">*</span></label>
                <!-- Tham số: username -->
                <input type="text" id="username" name="username" placeholder="Nhập tên đăng nhập (viết liền không dấu)" required>
            </div>

            <div class="input-group">
                <label for="full_name">Họ và tên <span style="color:red">*</span></label>
                <!-- Tham số: full_name -->
                <input type="text" id="full_name" name="full_name" placeholder="VD: Nguyễn Văn A" required>
            </div>

            <div class="form-row">
                <div class="input-group">
                    <label for="email">Email <span style="color:red">*</span></label>
                    <!-- Tham số: email -->
                    <input type="email" id="email" name="email" placeholder="example@email.com" required>
                </div>

                <div class="input-group">
                    <label for="phone_number">Số điện thoại</label>
                    <!-- Tham số: phone_number -->
                    <input type="tel" id="phone_number" name="phone_number" placeholder="Nhập số điện thoại">
                </div>
            </div>

            <div class="form-row">
                <div class="input-group">
                    <label for="password">Mật khẩu <span style="color:red">*</span></label>
                    <!-- Tham số: password -->
                    <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                </div>

                <div class="input-group">
                    <label for="confirm_password">Xác nhận mật khẩu <span style="color:red">*</span></label>
                    <!-- Tham số: confirm_password -->
                    <input type="password" id="confirm_password" name="confirm_password" placeholder="Nhập lại mật khẩu" required>
                </div>
            </div>

            <button type="submit" class="btn-register-submit">Đăng ký ngay</button>
        </form>

        <div class="login-section">
            <p>Đã có tài khoản?</p>
            <a href="login.jsp" class="btn-login-link">Quay lại Đăng nhập</a>
        </div>
    </div>

</body>
</html>