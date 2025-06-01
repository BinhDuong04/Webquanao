<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
</head>
<body>

    <jsp:include page="../templates/header.jsp" />
    <jsp:include page="../templates/menu.jsp" />

    <div class="container-content">
    <h2>DANH SÁCH SẢN PHẨM MỚI NHẤT</h2>
    <div class="product-list">
        <c:choose>
            <c:when test="${not empty products}">
                <c:forEach var="product" items="${products}">
                    <div class="product-item" onclick="openProductDetail(${product.id})">
                        <div class="product-image">
                            <c:set var="imageList" value="${fn:split(product.hinhAnh, ',')}" />
                            <img src="${pageContext.request.contextPath}/${imageList[0]}" alt="${product.tenSanPham}" />
                            <c:if test="${product.soLuong < 3}">
                                <span class="low-stock">🔥 Sắp hết hàng!</span>
                            </c:if>
                        </div>
                        <div class="product-details">
                            <h3>${product.tenSanPham}</h3>
                            <p class="price">${product.gia} VND</p>
                            <p class="stock">Còn lại: ${product.soLuong} sản phẩm</p>
                            <button class="add-to-cart" onclick="event.stopPropagation(); addToCart(${product.id});">Thêm vào giỏ hàng</button>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p>Không tìm thấy sản phẩm phù hợp.</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>


    <jsp:include page="../templates/footer.jsp" />

    <script>
    function openProductDetail(productId) {
        window.location.href = '${pageContext.request.contextPath}/home/productDetail?id=' + productId;
    }

    function addToCart(productId) {
        // TODO: Gọi AJAX hoặc chuyển trang thêm vào giỏ hàng
        alert("Đã thêm sản phẩm ID = " + productId + " vào giỏ hàng!");
    }
    </script>

</body>
</html>
