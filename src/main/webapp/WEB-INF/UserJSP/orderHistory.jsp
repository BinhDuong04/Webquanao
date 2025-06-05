<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử đặt hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <style>
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

        .main-content {
            max-width: 1200px;
            margin: 80px auto;
            padding: 20px;
        }

    </style>
</head>
<body>

<jsp:include page="../templates/header.jsp"/>
<jsp:include page="../templates/menu.jsp" />
<div class="breadcrumb-bar">
    <a href="${pageContext.request.contextPath}/customer/home">Trang chủ</a> &gt; ${currentCategory.tenDanhMuc}
</div>

<div class="main-content">
    <h2 class="mb-4">Lịch sử đặt hàng của bạn</h2>

    <c:if test="${empty dsDonHang}">
        <p class="text-muted">Bạn chưa có đơn hàng nào.</p>
    </c:if>

    <c:if test="${not empty dsDonHang}">
        <table class="table table-bordered table-hover">
            <thead class="table-light">
            <tr>
                <th>ID Đơn</th>
                <th>Ngày đặt</th>
                <th>Tổng tiền</th>
                <th>Trạng thái đơn hàng</th>
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
                    <td><fmt:formatDate value="${order.ngayDat}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                    <td><fmt:formatNumber value="${order.tongTien}" groupingUsed="true"/> ₫</td>
                    <td>${order.trangThai}</td>
                    <td>${payment != null ? payment.phuongThuc : 'Chưa xác định'}</td>
                    <td>${payment != null ? payment.trangThai : 'Chưa xác định'}</td>
                    <td>
                        <!-- Nút xem chi tiết -->
                        <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#detailModal${order.id}">
                            <i class="bi bi-eye"></i> Xem chi tiết
                        </button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
</div>

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

<jsp:include page="../templates/footer.jsp"/>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
