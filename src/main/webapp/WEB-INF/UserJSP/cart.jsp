<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng của bạn</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/menu.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css"> <!-- cart.css riêng -->

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<jsp:include page="../templates/header.jsp" />
<jsp:include page="../templates/menu.jsp" />

<!-- BREADCRUMB -->
<div class="breadcrumb-bar">
    <a href="${pageContext.request.contextPath}/customer/home">Trang chủ</a> &gt; Giỏ hàng
</div>

<div class="cart-container">
    <div class="cart-title">🛒 Giỏ hàng của bạn</div>

    <c:choose>
        <c:when test="${not empty cartItems}">
            <table class="table table-striped cart-table align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>Ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Tổng</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:set var="grandTotal" value="0" />
                    <c:forEach var="item" items="${cartItems}">
                        <c:set var="imageList" value="${fn:split(item.sanPham.hinhAnh, ',')}" />
                        <c:set var="itemTotal" value="${item.sanPham.gia * item.soLuong}" />
                        <c:set var="grandTotal" value="${grandTotal + itemTotal}" />

                        <tr>
                            <td>
                                <img src="${pageContext.request.contextPath}/${imageList[0]}" alt="${item.sanPham.tenSanPham}" />
                            </td>
                            <td>${item.sanPham.tenSanPham}</td>
                            <td>
                                <fmt:formatNumber value="${item.sanPham.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                            </td>
                            <td>
                                <div class="input-group" style="max-width: 140px;">
                                    <button class="btn btn-outline-secondary btn-sm" type="button" onclick="changeQuantity(${item.sanPham.id}, -1)">➖</button>
                                    <input type="number" id="quantity-${item.sanPham.id}" class="form-control text-center" value="${item.soLuong}" min="1" style="width: 50px;" onchange="updateQuantity(${item.sanPham.id})">
                                    <button class="btn btn-outline-secondary btn-sm" type="button" onclick="changeQuantity(${item.sanPham.id}, 1)">➕</button>
                                </div>
                            </td>
                            <td>
                                <fmt:formatNumber value="${itemTotal}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/cart/remove?productId=${item.sanPham.id}" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');">
                                    <i class="fa fa-trash"></i> Xóa
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="cart-summary">
                Tổng cộng: 
                <span style="color: #e60023;" id="grand-total">
                    <fmt:formatNumber value="${grandTotal}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                </span>
                <span id="cart-loading" style="display:none; color:#007bff; margin-left: 10px;">
                    <i class="fa fa-spinner fa-spin"></i> Đang cập nhật...
                </span>
            </div>

            <div class="cart-actions">
                <a href="${pageContext.request.contextPath}/order/checkout" class="btn btn-success btn-lg">
                    <i class="fa fa-credit-card"></i> Thanh toán
                </a>
            </div>
        </c:when>

        <c:otherwise>
            <p class="text-center fs-4 text-muted mt-5">Giỏ hàng của bạn đang trống! 🛍️</p>
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/customer/home" class="btn btn-primary btn-lg">
                    <i class="fa fa-house"></i> Quay lại trang chủ
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<jsp:include page="../templates/footer.jsp" />

<!-- SCRIPT AJAX -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function changeQuantity(productId, delta) {
        let qtyInput = document.getElementById('quantity-' + productId);
        let currentQty = parseInt(qtyInput.value);
        let newQty = currentQty + delta;
        if (newQty < 1) newQty = 1;
        qtyInput.value = newQty;
        updateQuantity(productId);
    }

    function updateQuantity(productId) {
        let newQty = document.getElementById('quantity-' + productId).value;

        // Hiện spinner
        $('#cart-loading').show();

        $.ajax({
            url: '${pageContext.request.contextPath}/cart/update',
            type: 'POST',
            data: {
                productId: productId,
                quantity: newQty
            },
            success: function(response) {
                if (response.status === 'success') {
                    // Chờ 300ms rồi reload mượt
                    setTimeout(function() {
                        location.reload();
                    }, 300);
                } else {
                    alert("Lỗi: " + response.message);
                    $('#cart-loading').hide();
                }
            },
            error: function(xhr, status, error) {
                console.error("Lỗi khi cập nhật số lượng:", error);
                alert("Có lỗi xảy ra khi cập nhật.");
                $('#cart-loading').hide();
            }
        });
    }
</script>

</body>
</html>
