<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <title>Quản lý danh mục</title>
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
      <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/logout">
        Đăng xuất
      </a>
    </div>
  </div>
</nav>

<!-- SIDEBAR MENU -->
<nav class="sidebar">
  <ul class="nav flex-column">
    <li class="nav-item mb-2">
      <a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">
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
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Quản lý danh mục</h2>
    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
      <i class="bi bi-plus-circle"></i> Thêm danh mục
    </button>
  </div>

  <form method="get" action="danhmuc">
    <div class="input-group mb-3">
      <input type="text" class="form-control" name="keyword" placeholder="Tìm kiếm danh mục..." value="${param.keyword}">
      <button class="btn btn-outline-secondary" type="submit">Tìm</button>
    </div>
  </form>

  <table class="table table-bordered table-hover">
    <thead class="table-light">
    <tr>
      <th>ID</th>
      <th>Tên danh mục</th>
      <th>Mô tả</th>
      <th>Hành động</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="dm" items="${dsDanhMuc}" varStatus="loop">
      <tr>
        <td>${loop.index + 1}</td>
        <td>${dm.tenDanhMuc}</td>
        <td>${dm.moTa}</td>
        <td>
          <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editModal${dm.id}">
            <i class="bi bi-pencil-square"></i> Sửa
          </button>
          <a href="danhmuc/delete?id=${dm.id}" class="btn btn-sm btn-danger" onclick="return confirm('Xác nhận xóa?')">
            <i class="bi bi-trash"></i> Xóa
          </a>

          <!-- Edit Modal -->
          <div class="modal fade" id="editModal${dm.id}" tabindex="-1">
            <div class="modal-dialog">
              <form action="danhmuc/update" method="post">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title">Sửa danh mục</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                  </div>
                  <div class="modal-body">
                    <input type="hidden" name="id" value="${dm.id}" />
                    <div class="mb-3">
                      <label class="form-label">Tên danh mục</label>
                      <input type="text" name="tenDanhMuc" class="form-control" value="${dm.tenDanhMuc}" required>
                    </div>
                    <div class="mb-3">
                      <label class="form-label">Mô tả</label>
                      <textarea name="moTa" class="form-control">${dm.moTa}</textarea>
                    </div>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>

<!-- Add Modal -->
<div class="modal fade" id="addModal" tabindex="-1">
  <div class="modal-dialog">
    <form action="danhmuc/add" method="post">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Thêm danh mục</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label class="form-label">Tên danh mục</label>
            <input type="text" name="tenDanhMuc" class="form-control" required>
          </div>
          <div class="mb-3">
            <label class="form-label">Mô tả</label>
            <textarea name="moTa" class="form-control"></textarea>
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