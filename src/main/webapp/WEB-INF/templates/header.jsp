<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">

<!-- Banner trên cùng -->
<div class="top-banner">
    <img src="${pageContext.request.contextPath}/images/banner.png" alt="Ưu đãi lớn">
</div>

<!-- Thanh điều hướng chính -->
<header class="top-bar">
    <div class="container">
        <div class="top-bar-content">
            <!-- Thanh tìm kiếm -->
            <div class="search-bar">
                <form action="${pageContext.request.contextPath}/home" method="get">
                    <input type="text" name="keyword" placeholder="Tìm kiếm sản phẩm..." value="${keyword != null ? keyword : ''}">
                    <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
                </form>
            </div>

            <!-- Hỗ trợ khách hàng + tài khoản + giỏ hàng -->
            <div class="top-right">

                <!-- Hỗ trợ khách hàng -->
                <div class="support">
                    <i class="fa-solid fa-phone-volume"></i>
                    <div class="support-text">
                        <span>Hỗ trợ khách hàng</span>
                        <strong>034.559.1612</strong>
                    </div>
                </div>

                <!-- Tài khoản -->
                <div class="account">
                    <i class="fa-solid fa-circle-user"></i>
                    <div class="account-text">
                        <c:choose>
                            <c:when test="${isLoggedIn}">
                                <span class="username">${fullName}</span>
                                <a href="${pageContext.request.contextPath}/logout" class="logout">Đăng xuất</a>
                            </c:when>
                            <c:otherwise>
                                <span>Tài Khoản</span>
                                <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Giỏ hàng -->
                <div class="cart">
                    <a href="${pageContext.request.contextPath}/cart">
                        <i class="fa-solid fa-bag-shopping"></i> Giỏ hàng
                        <span class="cart-count" id="cart-count">0</span>
                    </a>
                </div>

                <!-- Thêm đoạn script sau -->
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script>
                    $(document).ready(function() {
                        $.ajax({
                            url: '${pageContext.request.contextPath}/cart/getCartCount',
                            type: 'GET',
                            success: function(response) {
                                $('#cart-count').text(response.count);
                            },
                            error: function(xhr, status, error) {
                                console.error("Có lỗi xảy ra khi lấy giỏ hàng: " + error);
                            }
                        });
                    });
                </script>
            </div>
        </div>
    </div>
</header>

<!-- AJAX cập nhật giỏ hàng -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

