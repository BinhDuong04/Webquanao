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
                <td>
                    <fmt:formatNumber value="${sp.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                </td>
                <td>${sp.soLuong}</td>
                <td>
                    <c:set var="imageArray" value="${fn:split(sp.hinhAnh, ',')}"/>
                    <c:set var="firstImage" value="${(not empty imageArray) ? imageArray[0] : 'images/products/default.jpg'}"/>
                    <img src="${pageContext.request.contextPath}/${firstImage}" class="img-preview"/>
                </td>
                <td>${sp.danhMuc.tenDanhMuc}</td>
                <td>
                    <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editModal${sp.id}">
                        <i class="bi bi-pencil-square"></i> Sửa
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/products/delete?id=${sp.id}" class="btn btn-sm btn-danger" onclick="return confirm('Xác nhận xóa?')">
                        <i class="bi bi-trash"></i> Xóa
                    </a>
                    <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#detailModal${sp.id}">
                        <i class="bi bi-eye"></i> Chi tiết
                    </button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <!-- Modal Sửa sản phẩm -->
    <c:forEach var="sp" items="${dsSanPham}">
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
                                <input type="hidden" name="replaceImages" id="replaceImages${sp.id}">
                                <input type="hidden" name="replaceTargets" id="replaceTargets${sp.id}">
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

        <!-- Modal Chi tiết sản phẩm -->
        <div class="modal fade" id="detailModal${sp.id}" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Chi tiết sản phẩm: ${sp.tenSanPham}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <!-- Thông tin cơ bản -->
                        <p><strong>Tên sản phẩm:</strong> ${sp.tenSanPham}</p>
                        <p><strong>Giá:</strong> 
                            <fmt:formatNumber value="${sp.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                        </p>
                        <p><strong>Số lượng:</strong> ${sp.soLuong}</p>
                        <p><strong>Danh mục:</strong> ${sp.danhMuc.tenDanhMuc}</p>
                        <p><strong>Mô tả:</strong> ${sp.moTa}</p>

                        <!-- Chi tiết sản phẩm -->
                        <c:set var="details" value="${chiTietMap[sp.id]}"/>
                        <c:choose>
                            <c:when test="${not empty details}">
                                <h6 class="mt-4">Chi tiết sản phẩm</h6>
                                <c:forEach var="detail" items="${details}">
                                    <p><strong>Kích cỡ:</strong> ${detail.kichCo}</p>
                                    <p><strong>Màu sắc:</strong> ${detail.mauSac}</p>
                                    <p><strong>Chất liệu:</strong> ${detail.chatLieu != null ? detail.chatLieu : 'N/A'}</p>
                                    <p><strong>Thương hiệu:</strong> ${detail.thuongHieu != null ? detail.thuongHieu : 'N/A'}</p>
                                    <p><strong>Kiểu dáng:</strong> ${detail.form != null ? detail.form : 'N/A'}</p>
                                    <p><strong>Đặc điểm:</strong> ${detail.dacDiem != null ? detail.dacDiem : 'N/A'}</p>
                                    <hr> <!-- Separator between each detail entry -->
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted">Chưa có chi tiết sản phẩm nào.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <c:set var="details" value="${chiTietMap[sp.id]}"/>
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addDetailModal${sp.id}">
                            <i class="bi bi-plus-circle"></i>
                            <c:choose>
                                <c:when test="${not empty details}">Cập nhật chi tiết</c:when>
                                <c:otherwise>Thêm chi tiết</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Thêm / Cập nhật chi tiết sản phẩm -->
        <div class="modal fade" id="addDetailModal${sp.id}" tabindex="-1">
            <div class="modal-dialog">
                <form action="${pageContext.request.contextPath}/admin/products/details/add" method="post">
                    <input type="hidden" name="idSanPham" value="${sp.id}">

                    <!-- Nếu có ChiTietSanPham thì lấy cái đầu tiên -->
                    <c:set var="ctsp" value="${not empty chiTietMap[sp.id] ? chiTietMap[sp.id][0] : null}"/>

                    <!-- Nếu có ctsp.id thì gắn vào hidden (để Controller biết là update) -->
                    <c:if test="${ctsp != null}">
                        <input type="hidden" name="id" value="${ctsp.id}">
                    </c:if>

                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">
                                <c:choose>
                                    <c:when test="${ctsp != null}">Cập nhật chi tiết sản phẩm</c:when>
                                    <c:otherwise>Thêm chi tiết sản phẩm</c:otherwise>
                                </c:choose>
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Kích cỡ</label>
                                <input type="text" name="kichCo" class="form-control" value="${ctsp != null ? ctsp.kichCo : ''}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Màu sắc</label>
                                <input type="text" name="mauSac" class="form-control" value="${ctsp != null ? ctsp.mauSac : ''}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Chất liệu</label>
                                <input type="text" name="chatLieu" class="form-control" value="${ctsp != null ? ctsp.chatLieu : ''}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Thương hiệu</label>
                                <input type="text" name="thuongHieu" class="form-control" value="${ctsp != null ? ctsp.thuongHieu : ''}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Kiểu dáng</label>
                                <input type="text" name="form" class="form-control" value="${ctsp != null ? ctsp.form : ''}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Đặc điểm</label>
                                <textarea name="dacDiem" class="form-control">${ctsp != null ? ctsp.dacDiem : ''}</textarea>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">
                                <c:choose>
                                    <c:when test="${ctsp != null}">Cập nhật</c:when>
                                    <c:otherwise>Thêm</c:otherwise>
                                </c:choose>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

    </c:forEach>
</div>

<!-- Modal Thêm sản phẩm -->
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
        document.querySelectorAll('[id^="editModal"]').forEach(modal => {
            const productId = modal.id.replace('editModal', '');
            const hiddenReplaceImages = document.getElementById('replaceImages' + productId);
            const hiddenReplaceTargets = document.getElementById('replaceTargets' + productId);

            modal.querySelectorAll('.selectable-img').forEach(img => {
                img.addEventListener('click', function () {
                    img.classList.toggle('selected');

                    // Cập nhật danh sách ảnh giữ lại
                    const selectedImgs = Array.from(modal.querySelectorAll('.selectable-img:not(.selected)'))
                        .map(i => i.getAttribute('data-img'));
                    hiddenReplaceImages.value = selectedImgs.join(',');

                    // Cập nhật danh sách ảnh bị chọn để thay
                    const targetImgs = Array.from(modal.querySelectorAll('.selectable-img.selected'))
                        .map(i => i.getAttribute('data-img'));
                    hiddenReplaceTargets.value = targetImgs.join(',');
                });
            });
        });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>