<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sản phẩm - ${product.tenSanPham}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/menu.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        .product-detail-container {
            max-width: 1200px;
            margin: 30px auto;
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
        }

        .product-detail-image {
            flex: 1 1 500px;
            text-align: center;
        }

        .product-detail-image img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .thumbnail-slider {
            margin-top: 15px;
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        .thumbnail-slider img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 6px;
            cursor: pointer;
            border: 2px solid #ddd;
            transition: border-color 0.3s;
        }

        .thumbnail-slider img:hover {
            border-color: #007bff;
        }

        .product-detail-info {
            flex: 1 1 500px;
        }

        .product-detail-info h2 {
            font-size: 28px;
            margin-bottom: 20px;
        }

        .product-detail-info .price {
            color: #e60023;
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .product-detail-info .stock {
            font-size: 16px;
            color: #555;
            margin-bottom: 15px;
        }

        .product-detail-info .attribute {
            margin-bottom: 10px;
        }

        .btn-group .btn {
            min-width: 50px;
        }

        .size-btn.active, .color-btn.active {
            border-color: #007bff;
            background-color: #007bff;
            color: white;
        }

        .quantity-input {
            width: 80px;
            padding: 8px;
            font-size: 16px;
            margin-bottom: 15px;
        }

        .add-to-cart-btn {
            background-color: #ff6600;
            color: white;
            font-size: 16px;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .add-to-cart-btn:hover {
            background-color: #e65c00;
        }
    </style>
</head>
<body>

<jsp:include page="../templates/header.jsp" />
<jsp:include page="../templates/menu.jsp" />

<div class="breadcrumb-bar">
    <a href="${pageContext.request.contextPath}/customer/home">Trang chủ</a> &gt; ${product.tenSanPham}
</div>

<div class="product-detail-container">
    <!-- Hình ảnh sản phẩm -->
    <div class="product-detail-image">
        <c:set var="imageList" value="${fn:split(product.hinhAnh, ',')}" />
        <img id="mainImage" src="${pageContext.request.contextPath}/${imageList[0]}" alt="${product.tenSanPham}">

        <!-- Slider mini -->
        <div class="thumbnail-slider">
            <c:forEach var="img" items="${imageList}">
                <img src="${pageContext.request.contextPath}/${img}" alt="Thumbnail" onclick="changeMainImage('${pageContext.request.contextPath}/${img}')">
            </c:forEach>
        </div>
    </div>

    <!-- Thông tin sản phẩm -->
    <div class="product-detail-info">
        <h2>${product.tenSanPham}</h2>
        <p class="price">
            <fmt:formatNumber value="${product.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
        </p>
        <p class="stock">Còn lại: ${product.soLuong} sản phẩm</p>
        <p><strong>Mô tả:</strong> ${product.moTa}</p>

        <!-- Chọn Size -->
        <c:if test="${not empty chiTietSanPham.kichCo}">
            <div class="attribute">
                <strong>Kích cỡ:</strong>
                <div class="btn-group" role="group" aria-label="Chọn size">
                    <c:forEach var="size" items="${fn:split(chiTietSanPham.kichCo, ',')}">
                        <button type="button" class="btn btn-outline-secondary size-btn" onclick="selectOption(this, 'size')">${size}</button>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <!-- Chọn Màu sắc -->
        <c:if test="${not empty chiTietSanPham.mauSac}">
            <div class="attribute">
                <strong>Màu sắc:</strong>
                <div class="btn-group" role="group" aria-label="Chọn màu">
                    <c:forEach var="color" items="${fn:split(chiTietSanPham.mauSac, ',')}">
                        <button type="button" class="btn btn-outline-secondary color-btn" onclick="selectOption(this, 'color')">${color}</button>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <!-- Các thuộc tính khác -->
        <c:if test="${not empty chiTietSanPham}">
            <div class="attribute"><strong>Chất liệu:</strong> ${chiTietSanPham.chatLieu}</div>
            <div class="attribute"><strong>Thương hiệu:</strong> ${chiTietSanPham.thuongHieu}</div>
            <div class="attribute"><strong>Kiểu dáng:</strong> ${chiTietSanPham.form}</div>
            <div class="attribute"><strong>Đặc điểm:</strong> ${chiTietSanPham.dacDiem}</div>
        </c:if>

        <!-- Chọn số lượng -->
        <div>
            <label for="quantity"><strong>Số lượng:</strong></label>
            <input type="number" id="quantity" class="quantity-input" min="1" max="${product.soLuong}" value="1">
        </div>

        
        <!-- Nút thêm vào giỏ hàng + Mua ngay -->
        <div style="margin-top: 20px;">
            <button class="add-to-cart-btn" style="margin-right: 15px;" onclick="addToCart(${product.id})">Thêm vào giỏ hàng</button>
            <button class="add-to-cart-btn btn-danger" onclick="buyNow(${product.id})">Mua ngay</button>
        </div>
    </div>
</div>

<jsp:include page="../templates/footer.jsp" />

<!-- Script -->
<script>
    function changeMainImage(imgSrc) {
        document.getElementById('mainImage').src = imgSrc;
    }

    function selectOption(button, type) {
        // Bỏ active tất cả nút trong nhóm
        document.querySelectorAll('.' + type + '-btn').forEach(btn => btn.classList.remove('active'));
        // Thêm active vào nút vừa chọn
        button.classList.add('active');
    }

    function addToCart(productId) {
        const quantity = document.getElementById('quantity').value;
        const sizeBtn = document.querySelector('.size-btn.active');
        const colorBtn = document.querySelector('.color-btn.active');

        // Kiểm tra đã chọn size chưa (nếu có)
        if (document.querySelectorAll('.size-btn').length > 0 && !sizeBtn) {
            alert('Vui lòng chọn kích cỡ!');
            return;
        }

        // Kiểm tra đã chọn màu chưa (nếu có)
        if (document.querySelectorAll('.color-btn').length > 0 && !colorBtn) {
            alert('Vui lòng chọn màu sắc!');
            return;
        }

        const size = sizeBtn ? sizeBtn.innerText.trim() : '';
        const color = colorBtn ? colorBtn.innerText.trim() : '';

        $.ajax({
            url: '${pageContext.request.contextPath}/cart/add',
            type: 'POST',
            data: {
                productId: productId,
                quantity: quantity,
                size: size,
                color: color
            },
            success: function(response) {
                if (response.status === 'success') {
                    updateCartCount();
                    alert(response.message);
                } else {
                    alert("Lỗi: " + response.message);
                }
            },
            error: function(xhr, status, error) {
                console.error("Lỗi khi thêm giỏ hàng:", error);
                alert("Có lỗi xảy ra khi thêm vào giỏ hàng.");
            }
        });
    }

    function buyNow(productId) {
        const quantity = document.getElementById('quantity').value;
        const sizeBtn = document.querySelector('.size-btn.active');
        const colorBtn = document.querySelector('.color-btn.active');

        // Kiểm tra đã chọn size chưa (nếu có)
        if (document.querySelectorAll('.size-btn').length > 0 && !sizeBtn) {
            alert('Vui lòng chọn kích cỡ!');
            return;
        }

        // Kiểm tra đã chọn màu chưa (nếu có)
        if (document.querySelectorAll('.color-btn').length > 0 && !colorBtn) {
            alert('Vui lòng chọn màu sắc!');
            return;
        }

        const size = sizeBtn ? sizeBtn.innerText.trim() : '';
        const color = colorBtn ? colorBtn.innerText.trim() : '';

        // Chuyển hướng sang trang đặt hàng nhanh
        window.location.href = '${pageContext.request.contextPath}/order/checkout'
            + '?productId=' + productId
            + '&quantity=' + quantity
            + '&size=' + encodeURIComponent(size)
            + '&color=' + encodeURIComponent(color);
    }

    function updateCartCount() {
        $.ajax({
            url: '${pageContext.request.contextPath}/cart/getCartCount',
            type: 'GET',
            success: function(response) {
                $('#cart-count').text(response.count);
            },
            error: function(xhr, status, error) {
                console.error("Có lỗi khi cập nhật giỏ hàng:", error);
            }
        });
    }
</script>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
