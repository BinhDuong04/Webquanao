<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn hàng</title>
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
        }

        .table th, .table td {
            vertical-align: middle;
            text-align: center;
            padding: 12px 8px;
            font-size: 15px;
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
    </style>
</head>
<body>

<!-- Navbar -->
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

<!-- Sidebar -->
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
            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/orders">
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

<!-- Main Content -->
<div class="main-content">
    <h2 class="mb-4">Quản lý đơn hàng</h2>

    <table class="table table-bordered table-hover">
        <thead class="table-light">
        <tr>
            <th>ID</th>
            <th>Khách hàng</th>
            <th>Ngày đặt</th>
            <th>Trạng thái</th>
            <th>Tổng tiền</th>
            <th>Phương thức thanh toán</th>
            <th>Trạng thái thanh toán</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="order" items="${dsDonHang}">
            <c:set var="payment" value="${thanhToanMap[order.id]}"/>
            <tr>
                <td>${order.id}</td>
                <td>${order.hoTenNguoiNhan}</td>
                <td><fmt:formatDate value="${order.ngayDat}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <td>${order.trangThai}</td>
                <td><fmt:formatNumber value="${order.tongTien}" type="number" groupingUsed="true" maxFractionDigits="0"/> ₫</td>
                <td>${payment != null ? payment.phuongThuc : 'Chưa xác định'}</td>
                <td>${payment != null ? payment.trangThai : 'Chưa xác định'}</td>
                <td>
                    <!-- Nút cập nhật trạng thái -->
                    <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#updateModal${order.id}">
                        <i class="bi bi-pencil-square"></i> Cập nhật
                    </button>

                    <!-- Nút xem chi tiết -->
                    <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#detailModal${order.id}">
                        <i class="bi bi-eye"></i> Xem chi tiết
                    </button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- Modal cập nhật trạng thái -->
<c:forEach var="order" items="${dsDonHang}">
    <c:set var="payment" value="${thanhToanMap[order.id]}"/>
    <div class="modal fade" id="updateModal${order.id}" tabindex="-1">
        <div class="modal-dialog">
            <form action="${pageContext.request.contextPath}/admin/orders/update" method="post">
                <input type="hidden" name="orderId" value="${order.id}">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Cập nhật trạng thái đơn hàng #${order.id}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <!-- Trạng thái đơn hàng -->
                        <div class="mb-3">
                            <label class="form-label">Trạng thái đơn hàng</label>
                            <select name="trangThai" class="form-select" required>
                                <option value="Đang xử lý" ${order.trangThai == 'Đang xử lý' ? 'selected' : ''}>Đang xử lý</option>
                                <option value="Đang giao hàng" ${order.trangThai == 'Đang giao hàng' ? 'selected' : ''}>Đang giao hàng</option>
                                <option value="Đã giao" ${order.trangThai == 'Đã giao' ? 'selected' : ''}>Đã giao</option>
                                <option value="Đã hủy" ${order.trangThai == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                            </select>
                        </div>

                        <!-- Trạng thái thanh toán -->
                        <div class="mb-3">
                            <label class="form-label">Trạng thái thanh toán</label>
                            <select name="trangThaiThanhToan" class="form-select">
                                <option value="Chưa thanh toán" ${payment != null && payment.trangThai == 'Chưa thanh toán' ? 'selected' : ''}>Chưa thanh toán</option>
                                <option value="Đã thanh toán" ${payment != null && payment.trangThai == 'Đã thanh toán' ? 'selected' : ''}>Đã thanh toán</option>
                            </select>
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

<!-- Modal xem chi tiết -->
<c:forEach var="order" items="${dsDonHang}">
    <c:set var="chiTietList" value="${chiTietMap[order.id]}"/>
    <div class="modal fade" id="detailModal${order.id}" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chi tiết đơn hàng #${order.id}</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered">
                        <thead class="table-light">
                        <tr>
                            <th>Tên sản phẩm</th>
                            <th>Kích cỡ</th>
                            <th>Màu sắc</th>
                            <th>Giá</th>
                            <th>Số lượng</th>
                            <th>Thành tiền</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${chiTietList}">
                            <tr>
                                <td>${item.sanPham.tenSanPham}</td>
                                <td>${item.kichCo}</td>
                                <td>${item.mauSac}</td>
                                <td><fmt:formatNumber value="${item.donGia}" groupingUsed="true"/> ₫</td>
                                <td>${item.soLuong}</td>
                                <td>
                                    <fmt:formatNumber value="${item.donGia * item.soLuong}" groupingUsed="true"/> ₫
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>
</c:forEach>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
