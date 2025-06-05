<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/menu.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>

    <jsp:include page="../templates/header.jsp" />
    <jsp:include page="../templates/menu.jsp" />

    <!-- FLEX BOX: MENU TRÁI + CONTENT PHẢI -->
    <div class="container-menu-wrapper">

        <!-- MENU BÊN TRÁI -->
        <div class="container-menu">
            <ul>
                <c:choose>
                    <c:when test="${not empty categories}">
                        <c:forEach var="category" items="${categories}">
                            <li>
                                <a href="${pageContext.request.contextPath}/admin/products/category/${category.id}">
                                    ${category.tenDanhMuc}
                                </a>
                            </li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <li>Không có danh mục nào</li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>

        <!-- CONTENT BÊN PHẢI -->
        <div class="container-content">
            <c:choose>
                <c:when test="${not empty keyword}">
                    <h2>Kết quả tìm kiếm cho: "<span style="color: #000;">${keyword}</span>"</h2>
                </c:when>
                <c:otherwise>
                    <h2>DANH SÁCH SẢN PHẨM MỚI NHẤT</h2>
                </c:otherwise>
            </c:choose>
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
                                    <p class="price">
                                        <fmt:formatNumber value="${product.gia}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                    </p>
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
            <!-- PHÂN TRANG -->
            <div class="pagination" style="margin-top: 20px; text-align: center;">
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center">

                            <!-- Prev button -->
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}&size=${pageSize}&keyword=${keyword}">«</a>
                                </li>
                            </c:if>

                            <!-- Logic phân trang thông minh -->
                            <c:set var="startPage" value="${currentPage <= 2 ? 1 : currentPage - 1}" />
                            <c:set var="endPage" value="${currentPage + 1 >= totalPages ? totalPages : currentPage + 1}" />

                            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&size=${pageSize}&keyword=${keyword}">${i}</a>
                                </li>
                            </c:forEach>

                            <!-- Next button -->
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}&size=${pageSize}&keyword=${keyword}">»</a>
                                </li>
                            </c:if>

                        </ul>
                    </nav>
                </c:if>
            </div>

        </div>

    </div>

    <!-- SLIDE ẢNH CHUYỂN ĐỘNG -->
    <div id="mainCarousel" class="carousel slide" data-bs-ride="carousel" style="margin: 30px auto; max-width: 1150px;">
        <!-- Dấu chấm chỉ mục -->
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="0" class="active"></button>
            <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="1"></button>
            <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="2"></button>
            <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="3"></button>
        </div>

        <!-- Slide ảnh -->
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="${pageContext.request.contextPath}/images/slide1.png" class="d-block w-100" alt="Slide 1">
            </div>
            <div class="carousel-item">
                <img src="${pageContext.request.contextPath}/images/slide2.png" class="d-block w-100" alt="Slide 2">
            </div>
            <div class="carousel-item">
                <img src="${pageContext.request.contextPath}/images/slide3.png" class="d-block w-100" alt="Slide 3">
            </div>
            <div class="carousel-item">
                <img src="${pageContext.request.contextPath}/images/slide4.png" class="d-block w-100" alt="Slide 4">
            </div>
        </div>

        <!-- Nút điều khiển -->
        <button class="carousel-control-prev" type="button" data-bs-target="#mainCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#mainCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>

    <jsp:include page="../templates/footer.jsp" />

    <script>
        function openProductDetail(productId) {
            window.location.href = '${pageContext.request.contextPath}/home/productDetail?id=' + productId;
        }

        function addToCart(productId) {
            $.ajax({
                url: '${pageContext.request.contextPath}/cart/add',
                type: 'POST',
                data: {
                    productId: productId,
                    quantity: 1
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>


</body>
</html>
