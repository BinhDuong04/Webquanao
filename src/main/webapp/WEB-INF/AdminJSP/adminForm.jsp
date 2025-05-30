<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <title>Bảng điều khiển Admin</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

  <link 
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" 
    rel="stylesheet"
  />
  <style>
    /* độ rộng cố định cho sidebar */
    .sidebar {
      height: 100vh;
      position: fixed;
      top: 56px; /* bằng chiều cao navbar */
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
    
  </style>
</head>
<body>
  <!-- HEADER -->
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
      <a class="navbar-brand" href="#">Admin Panel</a>
      <div class="d-flex align-items-center ms-auto">
        <span class="navbar-text text-white me-3">
          Xin chào, <strong>Admin ${sessionScope.user.tenDangNhap}</strong>
          <small class="text-muted">(${sessionScope.user.email})</small>
        </span>
        <a 
          class="btn btn-outline-light btn-sm" 
          href="${pageContext.request.contextPath}/logout"
        >
          Đăng xuất
        </a>
      </div>
    </div>
  </nav>

  <!-- SIDEBAR MENU -->
  <nav class="sidebar">
    <ul class="nav flex-column">
      <li class="nav-item mb-2">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/danhmuc">
          <i class="bi bi-list-ul"></i> Quản lý danh mục
        </a>
      </li>
      <li class="nav-item mb-2">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/products">
          <i class="bi bi-box-seam"></i> Quản lý sản phẩm
        </a>
      </li>
      <li class="nav-item mb-2">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/news">
          <i class="bi bi-newspaper"></i> Quản lý tin tức
        </a>
      </li>
      <li class="nav-item mb-2">
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

  <!-- MAIN CONTENT -->
  <div class="main-content">
    <h2 class="mb-4">Bảng điều khiển</h2>
    <!-- Ví dụ: hiển thị các số liệu tóm tắt -->
    <div class="row">
      <div class="col-md-3">
        <div class="card text-bg-primary mb-3">
          <div class="card-body">
            <h5 class="card-title">Tổng danh mục</h5>
            <p class="card-text display-6">12</p>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card text-bg-success mb-3">
          <div class="card-body">
            <h5 class="card-title">Tổng sản phẩm</h5>
            <p class="card-text display-6">234</p>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card text-bg-warning mb-3">
          <div class="card-body">
            <h5 class="card-title">Đơn hàng hôm nay</h5>
            <p class="card-text display-6">8</p>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card text-bg-info mb-3">
          <div class="card-body">
            <h5 class="card-title">Tài khoản mới</h5>
            <p class="card-text display-6">5</p>
          </div>
        </div>
      </div>
    </div>
    <!-- Nội dung thêm tại đây -->
  </div>

  <!-- Bootstrap JS + Bootstrap Icons (nếu cần) -->
  <script 
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
  ></script>
  <link 
    rel="stylesheet" 
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
  />
</body>
</html>
