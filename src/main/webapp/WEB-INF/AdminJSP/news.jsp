<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <title>Quản lý tin tức</title>
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

        /* Cột STT */
        .table th:nth-child(1), .table td:nth-child(1) { width: 5%; }

        /* Cột Tiêu đề */
        .table th:nth-child(2), .table td:nth-child(2) { width: 20%; }

        /* Cột Nội dung (giới hạn, có ... nếu dài) */
        .table th:nth-child(3), .table td:nth-child(3) {
            width: 30%;
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* Cột Ảnh */
        .table th:nth-child(4), .table td:nth-child(4) { width: 15%; }

        /* Cột Ngày đăng */
        .table th:nth-child(5), .table td:nth-child(5) { width: 15%; }

        /* Cột Hành động */
        .table th:nth-child(6), .table td:nth-child(6) { width: 15%; }
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

<nav class="sidebar" style="position: fixed; top: 56px; left: 0; width: 220px; height: 100vh; background-color: #f8f9fa; border-right: 1px solid #dee2e6; padding-top: 1rem;">
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
            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/news">
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

<div class="main-content" style="margin-left: 220px; margin-top: 80px; padding: 2rem;">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Quản lý tin tức</h2>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
            <i class="bi bi-plus-circle"></i> Thêm tin tức
        </button>
    </div>

    <!-- Tìm kiếm -->
    <form method="get" action="${pageContext.request.contextPath}/admin/news">
        <div class="input-group mb-3">
            <input type="text" class="form-control" name="keyword" placeholder="Tìm kiếm tiêu đề tin tức..." value="${param.keyword}">
            <button class="btn btn-outline-secondary" type="submit">Tìm kiếm</button>
        </div>
    </form>

    <!-- Table danh sách tin tức -->
    <table class="table table-bordered table-hover">
        <thead class="table-light">
        <tr>
            <th>STT</th>
            <th>Tiêu đề</th>
            <th>Nội dung</th>
            <th>Hình ảnh</th>
            <th>Ngày đăng</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="tt" items="${dsTinTuc}" varStatus="loop">
            <tr>
                <td>${loop.index + 1}</td>
                <td>${tt.tieuDe}</td>
                <td>
                    <c:choose>
                        <c:when test="${fn:length(tt.noiDung) > 100}">
                            ${fn:substring(tt.noiDung, 0, 100)}...
                        </c:when>
                        <c:otherwise>
                            ${tt.noiDung}
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:set var="imageArray" value="${fn:split(tt.hinhAnh, ',')}"/>
                    <c:set var="firstImage" value="${(not empty imageArray) ? imageArray[0] : 'images/news/default.jpg'}"/>
                    <img src="${pageContext.request.contextPath}/${firstImage}" class="img-thumbnail" style="width: 120px; height: 80px; object-fit: cover;">
                </td>
                <td>
                    <fmt:formatDate value="${tt.ngayDang}" pattern="dd/MM/yyyy HH:mm"/>
                </td>
                <td>
                    <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editModal${tt.id}">
                        <i class="bi bi-pencil-square"></i> Sửa
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/news/delete?id=${tt.id}" class="btn btn-sm btn-danger" onclick="return confirm('Xác nhận xóa tin tức này?')">
                        <i class="bi bi-trash"></i> Xóa
                    </a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- Modal Thêm tin tức -->
<div class="modal fade" id="addModal" tabindex="-1">
    <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/admin/news/add" method="post" enctype="multipart/form-data">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm tin tức</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tiêu đề</label>
                        <input type="text" name="tieuDe" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nội dung</label>
                        <textarea name="noiDung" class="form-control" rows="5" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Hình ảnh</label>
                        <input type="file" name="imageFiles" class="form-control" multiple required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">ID Admin</label>
                        <input type="number" name="idAdmin" class="form-control" value="${sessionScope.user.id}">
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

<!-- Modal Sửa tin tức -->
<c:forEach var="tt" items="${dsTinTuc}">
    <div class="modal fade" id="editModal${tt.id}" tabindex="-1">
        <div class="modal-dialog">
            <form action="${pageContext.request.contextPath}/admin/news/update" method="post" enctype="multipart/form-data">
                <input type="hidden" name="id" value="${tt.id}">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Sửa tin tức</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Tiêu đề</label>
                            <input type="text" name="tieuDe" class="form-control" value="${tt.tieuDe}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Nội dung</label>
                            <textarea name="noiDung" class="form-control" rows="5" required>${tt.noiDung}</textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Ảnh hiện tại:</label>
                            <div>
                                <c:forEach var="img" items="${fn:split(tt.hinhAnh, ',')}">
                                    <img src="${pageContext.request.contextPath}/${img}" class="img-thumbnail m-1" style="width: 100px; height: 80px; object-fit: cover;">
                                </c:forEach>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Ảnh mới (nếu có)</label>
                            <input type="file" name="imageFiles" class="form-control" multiple>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">ID Admin</label>
                            <input type="number" name="idAdmin" class="form-control" value="${tt.idAdmin}">
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
