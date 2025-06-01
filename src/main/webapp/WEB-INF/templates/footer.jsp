<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">

<footer>
    <div class="container">
        <div class="footer-content">

            <!-- Giới thiệu shop -->
            <div class="footer-column">
                <h3>SHOP QUẦN ÁO NAM NỮ THỜI TRANG</h3>
                <p>Chuyên cung cấp các sản phẩm quần áo thời trang nam nữ, mẫu mã đa dạng, phong cách hiện đại, cập nhật xu hướng mới nhất.</p>
                <p><i class="fa-solid fa-location-dot"></i> Địa chỉ: 266 Đội Cấn, Quận Ba Đình, TP. Hà Nội</p>
                <p><i class="fa-solid fa-phone"></i> Hotline: 0987.654.321</p>
                <p><i class="fa-solid fa-envelope"></i> Email: <a href="mailto:shopthoitrang@gmail.com">shopthoitrang@gmail.com</a></p>
            </div>

            <!-- Hỗ trợ khách hàng -->
            <div class="footer-column">
                <h3>Hỗ trợ khách hàng</h3>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/home/index">Trang Chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/home/introduce">Giới Thiệu</a></li>
                    <li><a href="${pageContext.request.contextPath}/home/news">Tin Tức</a></li>
                    <li><a href="${pageContext.request.contextPath}/order/history">Lịch sử đơn hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/home/contact">Liên hệ</a></li>
                </ul>
            </div>

            <!-- Mạng xã hội + Thanh toán -->
            <div class="footer-column">
                <h3>Kết nối với chúng tôi</h3>
                <div class="social-icons">
                    <a href="#"><i class="fa-brands fa-facebook"></i></a>
                    <a href="#"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#"><i class="fa-brands fa-tiktok"></i></a>
                    <a href="#"><i class="fa-brands fa-youtube"></i></a>
                </div>

                <h3>Phương thức thanh toán</h3>
                <div class="payment-methods">
                    <img src="${pageContext.request.contextPath}/images/payment.png" alt="Phương thức thanh toán">
                </div>
                
                <div class="gov-certification">
                    <img src="${pageContext.request.contextPath}/images/bo_cong_thuong.png" alt="Đã thông báo Bộ Công Thương">
                </div>
            </div>

        </div>

        <!-- Bản quyền -->
        <div class="footer-bottom">
            <p>© 2025 - Website được xây dựng phục vụ Đồ Án Kết Thúc Học Phần - Nhóm sinh viên ngành Công Nghệ Thông Tin.</p>
            <p>Thành viên nhóm: Dương Lý Bình (Leader), Cao Xuân Tuấn Anh, Hoàng Mậu Phong.</p>
        </div>
    </div>
</footer>
