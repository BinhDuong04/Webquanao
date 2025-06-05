<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${currentCategory.tenDanhMuc}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/menu.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
</head>
<body>

<jsp:include page="../templates/header.jsp" />
<jsp:include page="../templates/menu.jsp" />

<!-- BREADCRUMB -->
<div class="breadcrumb-bar">
    <a href="${pageContext.request.contextPath}/customer/home">Trang chủ</a> &gt; ${currentCategory.tenDanhMuc}
</div>


<!-- MAIN CONTENT -->
<div class="container-menu-wrapper">

    <!-- FILTER BÊN TRÁI -->
    <div class="container-menu">
        <h4>Lọc theo</h4>
        <ul>
            <li><a href="${pageContext.request.contextPath}/admin/products/category/${currentCategory.id}?sort=price_asc">Giá tăng dần</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products/category/${currentCategory.id}?sort=price_desc">Giá giảm dần</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products/category/${currentCategory.id}?sort=brand">Hãng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products/category/${currentCategory.id}">Mặc định</a></li>
        </ul>
    </div>

    <!-- LIST SẢN PHẨM BÊN PHẢI -->
    <div class="container-content">
        <h2>${currentCategory.tenDanhMuc}</h2>
        <div class="product-list">
            <c:choose>
                <c:when test="${not empty products}">
                    <c:forEach var="product" items="${products}">
                        <div class="product-item" onclick="openProductDetail(${product.id})">
                            <div class="product-image">
                                <c:set var="imageList" value="${fn:split(product.hinhAnh, ',')}" />
                                <img src="${pageContext.request.contextPath}/${imageList[0]}" alt="${product.tenSanPham}" />
                            </div>
                            <div class="product-details">
                                <h3>${product.tenSanPham}</h3>
                                <p class="price">
                                    <fmt:formatNumber value="${product.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                </p>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p>Không có sản phẩm nào trong danh mục này.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</div>

<jsp:include page="../templates/footer.jsp" />

<script>
    function openProductDetail(productId) {
        window.location.href = '${pageContext.request.contextPath}/home/productDetail?id=' + productId;
    }
</script>

</body>
</html>
