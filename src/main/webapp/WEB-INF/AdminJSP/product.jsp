<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
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
    .img-preview {
      max-height: 60px;
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
    <li class="nav-item mb-2">
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
        <i class="bi bi-receipt"></i> Quản lý đơn hàng
      </a>
    </li>
    <li class="nav-item mb-2">
      <a class="nav-link" href="${ PlasmidContext.request.contextPath}/admin/users">
        <i class="bi bi-people"></i> Quản lý tài khoản
      </a>
    </li>
  </ul>
</nav>

<div class="main-content">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Quản lý sản phẩm</h2>
    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
      <i class="bi bi-plus-circle"></i> Thêm sản phẩm
    </button>
  </div>

  <form method="get" action="${pageContext.request.contextPath}/admin/products">
    <div class="input-group mb-3">
      <input type="text" class="form-control" name="keyword" placeholder="Tìm kiếm sản phẩm..." value="${param.keyword}">
      <button class="btn btn-outline-secondary" type="submit">Tìm</button>
    </div>
  </form>

  <table class="table table-bordered table-hover">
    <thead class="table-light">
    <tr>
      <th>#</th>
      <th>Tên</th>
      <th>Giá</th>
      <th>SL</th>
      <th>Hình ảnh</th>
      <th>Danh mục</th>
      <th>Hành động</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="sp" items="${dsSanPham}" varStatus="loop">
      <tr>
        <td>${loop.index + 1}</td>
        <td>${sp.tenSanPham}</td>
        <td>${sp.gia}</td>
        <td>${sp.soLuong}</td>
        <img src="${pageContext.request.contextPath}/${sp.hinhAnh}" class="img-preview">
        <td>${sp.danhMuc.tenDanhMuc}</td>
        <td>
          <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editModal${sp.id}">
            <i class="bi bi-pencil-square"></i> Sửa
          </button>
          <a href="${pageContext.request.contextPath}/admin/products/delete?id=${sp.id}" class="btn btn-sm btn-danger" onclick="return confirm('Xác nhận xóa?')">
            <i class="bi bi-trash"></i> Xóa
          </a>
          <a href="${pageContext.request.contextPath}/admin/products/detail?id=${sp.id}" class="btn btn-sm btn-info">
            <i class="bi bi-eye"></i> Chi tiết
          </a>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>

<!-- Modal thêm sản phẩm -->
<div class="modal fade" id="addModal" tabindex="-1">
  <div class="modal-dialog">
    <form action="${pageContext.request.contextPath}/admin/products/add" method="post" enctype="multipart/form-data">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Thêm sản phẩm</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label class="form-label">Tên sản phẩm</label>
            <input type="text" name="tenSanPham" class="form-control" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Mô tả</label>
            <textarea name="moTa" class="form-control"></textarea>
          </div>
          <div class="mb-3">
            <label class="form-label">Giá</label>
            <input type="number" name="gia" class="form-control" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Số lượng</label>
            <input type="number" name="soLuong" class="form-control" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Danh mục</label>
            <select name="idDanhMuc" class="form-select" required>
              <c:forEach var="dm" items="${dsDanhMuc}">
                <option value="${dm.id}">${dm.tenDanhMuc}</option>
              </c:forEach>
            </select>
          </div>
          <div class="mb-3">
            <label class="form-label">Hình ảnh</label>
            <input type="file" name="imageFiles" class="form-control" multiple required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-primary">Thêm</button>
        </div>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>