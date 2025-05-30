<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký - Clothing Store</title>
    <!-- Bootstrap CSS qua CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f5f5;
        }
        .register-container {
            max-width: 500px;
            margin: 50px auto;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h2 class="text-center mb-4">Đăng Ký Tài Khoản</h2>

        <form action="/register" method="POST">
            <div class="mb-3">
                <label for="tenDangNhap" class="form-label">Tên Đăng Nhập</label>
                <input type="text" class="form-control" id="tenDangNhap" name="tenDangNhap" required>
            </div>
            <div class="mb-3">
                <label for="matKhau" class="form-label">Mật Khẩu</label>
                <input type="password" class="form-control" id="matKhau" name="matKhau" required>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="mb-3">
                <label for="soDienThoai" class="form-label">Số Điện Thoại</label>
                <input type="text" class="form-control" id="soDienThoai" name="soDienThoai">
            </div>
            <button type="submit" class="btn btn-success w-100">Đăng Ký</button>
        </form>
        <p class="text-center mt-3">
            Đã có tài khoản? <a href="/login">Đăng nhập ngay</a>
        </p>
    </div>

    <!-- Bootstrap JS qua CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>