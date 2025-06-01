<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/menu.css">
<nav class="menu">
    <div class="container">
        <div class="menu-content">
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/home/index">Trang Chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/home/introduce">Giới Thiệu</a></li>
                <li><a href="${pageContext.request.contextPath}/home/news">Tin Tức</a></li>
                <li><a href="${pageContext.request.contextPath}/order/history">Lịch sử đơn hàng</a></li>
            </ul>

        </div>
    </div>
</nav>

<div class="container-menu-wrapper">
    <div class="container-menu">
        <ul>
            <c:choose>
                <c:when test="${not empty categories}">
                    <c:forEach var="category" items="${categories}">
                        <li>
                            <a href="${pageContext.request.contextPath}/category/${category.id}">
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
</div>

