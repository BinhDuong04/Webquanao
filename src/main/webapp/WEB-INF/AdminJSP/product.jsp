<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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

    .table {
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        table-layout: fixed; /* Cố định layout */
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
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }

    /* Form tìm kiếm */
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

    /* Chia tỷ lệ cột */
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
      <button class="btn btn-outline-secondary" type="submit">Tìm kiếm</button>
    </div>
  </form>

  <table class="table table-bordered table-hover">
    <thead class="table-light">
    <tr>
      <th>STT</th>
      <th>Tên sản phẩm</th>
      <th>Giá</th>
      <th>Số lượng</th>
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
        <td>
            <c:set var="imageArray" value="${fn:split(sp.hinhAnh, ',')}" />
            <c:set var="firstImage" value="${(not empty imageArray) ? imageArray[0] : 'images/products/default.jpg'}" />
            <img src="${pageContext.request.contextPath}/${firstImage}" class="img-preview" />
        </td>

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
      <!-- Modal Sửa sản phẩm -->
        <div class="modal fade" id="editModal${sp.id}" tabindex="-1">
          <div class="modal-dialog">
            <form action="${pageContext.request.contextPath}/admin/products/update" method="post" enctype="multipart/form-data">
              <input type="hidden" name="id" value="${sp.id}">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title">Sửa sản phẩm</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                  <div class="mb-3">
                    <label class="form-label">Tên sản phẩm</label>
                    <input type="text" name="tenSanPham" class="form-control" value="${sp.tenSanPham}" required>
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Mô tả</label>
                    <textarea name="moTa" class="form-control">${sp.moTa}</textarea>
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Giá</label>
                    <input type="number" name="gia" class="form-control" value="${sp.gia}" required>
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Số lượng</label>
                    <input type="number" name="soLuong" class="form-control" value="${sp.soLuong}" required>
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Danh mục</label>
                    <select name="idDanhMuc" class="form-select" required>
                      <c:forEach var="dm" items="${dsDanhMuc}">
                        <option value="${dm.id}" ${sp.idDanhMuc == dm.id ? 'selected' : ''}>${dm.tenDanhMuc}</option>
                      </c:forEach>
                    </select>
                  </div>

                  <div class="mb-3">
                        <label class="form-label">Ảnh hiện tại:</label>
                        <div>
                            <c:forEach var="img" items="${fn:split(sp.hinhAnh, ',')}">
                                <img src="${pageContext.request.contextPath}/${img}" 
                                     class="img-preview m-1 selectable-img" 
                                     data-img="${img}" 
                                     style="width: 100px; height: 80px;">
                            </c:forEach>
                        </div>
                        <!-- input hidden để lưu các ảnh được chọn -->
                        <input type="hidden" name="replaceImages" id="replaceImages${sp.id}">
                        <small>Nhấn vào ảnh để chọn ảnh muốn thay.</small>
                    </div>


                  <div class="mb-3">
                    <label class="form-label">Ảnh mới (nếu có):</label>
                    <input type="file" name="imageFiles" class="form-control" multiple>
                  </div>

                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                  <button type="submit" class="btn btn-primary">Cập nhật</button>
                </div>
              </div>
            </form>
          </div>
        </div>
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

<script>
document.addEventListener('DOMContentLoaded', function () {
    // Tìm tất cả các modal có sửa sản phẩm
    document.querySelectorAll('[id^="editModal"]').forEach(modal => {
        const productId = modal.id.replace('editModal', '');
        const hiddenInput = document.getElementById('replaceImages' + productId);
        
        // Lắng nghe click vào các ảnh
        modal.querySelectorAll('.selectable-img').forEach(img => {
            img.addEventListener('click', function () {
                img.classList.toggle('selected');
                
                // Cập nhật danh sách ảnh đã chọn vào hidden input
                const selectedImgs = Array.from(modal.querySelectorAll('.selectable-img.selected'))
                    .map(i => i.getAttribute('data-img'));
                hiddenInput.value = selectedImgs.join(',');
            });
        });
    });
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>