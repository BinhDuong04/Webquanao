<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <title>Quản lý sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .sidebar {
            height: 100vh;
            position: fixed;
            top: 56px;
            left: 0;
            width: 220px;
            padding-top: 1rem;
            background-color: #f8f9fa;
            border-right: 1px solid #dee2e6;
        }

        .main-content {
            margin-left: 220px;
            margin-top: 80px;
            padding: 2rem;
        }

        .table {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            table-layout: fixed;
            width: 100%;
        }

        .table th, .table td {
            vertical-align: middle;
            text-align: center;
            padding: 12px 8px;
            font-size: 15px;
            word-wrap: break-word;
        }

        .table th {
            background-color: #f1f1f1;
            color: #333;
            font-weight: 600;
        }

        .table tbody tr:hover {
            background-color: #f9f9f9;
            cursor: pointer;
        }

        .img-preview {
            width: 150px;
            height: 100px;
            object-fit: contain;
            border-radius: 8px;
            border: 1px solid #ddd;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .input-group .form-control {
            background-color: rgba(255, 255, 255, 0.8);
            border: 1px solid #ced4da;
            border-radius: 4px;
            padding: 10px;
            font-size: 14px;
        }

        .input-group .btn-outline-secondary {
            background-color: #0d6efd;
            color: white;
            border-color: #0d6efd;
            transition: 0.3s;
        }

        .input-group .btn-outline-secondary:hover {
            background-color: #0b5ed7;
            border-color: #0b5ed7;
            color: white;
        }

        .table th:nth-child(1), .table td:nth-child(1) { width: 5%; }
        .table th:nth-child(2), .table td:nth-child(2) { width: 25%; }
        .table th:nth-child(3), .table td:nth-child(3) { width: 10%; }
        .table th:nth-child(4), .table td:nth-child(4) { width: 8%; }
        .table th:nth-child(5), .table td:nth-child(5) { width: 17%; }
        .table th:nth-child(6), .table td:nth-child(6) { width: 15%; }
        .table th:nth-child(7), .table td:nth-child(7) { width: 20%; }

        .selectable-img {
            cursor: pointer;
            transition: 0.2s;
        }

        .selectable-img:hover {
            opacity: 0.8;
        }

        .selectable-img.selected {
            border: 3px solid #007bff;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.7);
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Admin Panel</a>
        <div class="d-flex align-items-center ms-auto">
            <span class="navbar-text text-white me-3">
                Xin chào, <strong>Admin ${sessionScope.user.tenDangNhap}</strong>
                <small class="text-muted">(${sessionScope.user.email})</small>
            </span>
            <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </div>
    </div>
</nav>

<nav class="sidebar">
    <ul class="nav flex-column">
        <li class="nav-item mb-2">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/danhmuc">
                <i class="bi bi-list-ul"></i> Quản lý danh mục
            </a>
        </li>
        <li class="nav-item mb-2">
            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/products">
                <i class="bi bi-box-seam"></i> Quản lý sản phẩm
            </a>
        </li>
        <li class="nav-item mb-2">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/news">
                <i class="bi bi-newspaper"></i> Quản lý tin tức
            </a>
        </li>
        <li class="nav-im mb-2">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
                <i class="bi bi-receipt"></i> Quản lý đơn hàng
            </a>
        </li>
        <li class="nav-item mb-2">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                <i class="bi bi-people"></i> Quản lý tài khoản
            </a>
        </li>
    </ul>
</nav>

<div class="main-content">
 

    <form method="get" action="${pageContext.request.contextPath}/admin/products">
        <div class="input-group mb-3">
            <input type="text" class="form-control" name="keyword" placeholder="Tìm kiếm sản phẩm..." value="${param.keyword}">
            <button class="btn btn-outline-secondary" type="submit">Tìm kiếm</button>
        </div>
    </form>
