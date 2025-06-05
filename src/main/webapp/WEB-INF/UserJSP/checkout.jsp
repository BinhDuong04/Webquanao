<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        .checkout-container {
            max-width: 800px;
            margin: 30px auto;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .checkout-title {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 20px;
            text-align: center;
        }

        .checkout-summary {
            margin-bottom: 30px;
        }

        .checkout-summary th, .checkout-summary td {
            padding: 12px 10px;
        }

        .checkout-total {
            text-align: right;
            font-size: 20px;
            font-weight: bold;
            margin-top: 20px;
        }

        .checkout-btn {
            width: 100%;
            padding: 12px;
            font-size: 18px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-top: 20px;
        }

        .checkout-btn:hover {
            background-color: #218838;
        }

        .form-section {
            margin-bottom: 20px;
        }

        .form-section label {
            font-weight: bold;
        }
    </style>
</head>
<body>

<jsp:include page="../templates/header.jsp" />

<div class="checkout-container">
    <div class="checkout-title">Thanh toán đơn hàng</div>

    <!-- Bảng sản phẩm -->
    <table class="table table-bordered checkout-summary">
        <thead>
            <tr>
                <th>Tên sản phẩm</th>
                <th>Số lượng</th>
                <th>Đơn giá</th>
                <th>Thành tiền</th>
            </tr>
        </thead>
        <tbody>
            <c:set var="total" value="0" />
            <c:forEach var="item" items="${cartItems}">
                <c:set var="itemTotal" value="${item.soLuong * item.sanPham.gia}" />
                <c:set var="total" value="${total + itemTotal}" />
                <tr>
                    <td>${item.sanPham.tenSanPham}</td>
                    <td>${item.soLuong}</td>
                    <td><fmt:formatNumber value="${item.sanPham.gia}" groupingUsed="true" /> ₫</td>
                    <td><fmt:formatNumber value="${itemTotal}" groupingUsed="true" /> ₫</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="checkout-total">
        Tổng cộng: <fmt:formatNumber value="${total}" groupingUsed="true" /> ₫
    </div>

    <!-- Form đặt hàng -->
    <form action="${pageContext.request.contextPath}/order/placeOrder" method="post">
        <!-- Thông tin giao hàng -->
        <div class="form-section">
            <label for="hoTen">Họ tên người nhận:</label>
            <input type="text" id="hoTen" name="hoTen" class="form-control" required>
        </div>

        <div class="form-section">
            <label for="diaChi">Địa chỉ giao hàng:</label>
            <textarea id="diaChi" name="diaChi" class="form-control" rows="3" required></textarea>
        </div>

        <div class="form-section">
            <label for="sdt">Số điện thoại:</label>
            <input type="text" id="sdt" name="sdt" class="form-control" required pattern="[0-9]{9,12}" title="Nhập số điện thoại hợp lệ">
        </div>

        <!-- Phương thức thanh toán -->
        <div class="form-section">
            <label>Phương thức thanh toán:</label>
            <div class="form-check">
                <input class="form-check-input" type="radio" name="phuongThuc" id="cod" value="COD" checked>
                <label class="form-check-label" for="cod">
                    Thanh toán khi nhận hàng (COD)
                </label>
            </div>
            <div class="form-check">
                <input class="form-check-input" type="radio" name="phuongThuc" id="bank" value="Chuyển khoản" onclick="showBankInfo()">
                <label class="form-check-label" for="bank">
                    Chuyển khoản ngân hàng
                </label>
            </div>

            <!-- Phần thông tin ngân hàng, ban đầu ẩn -->
            <div id="bank-info" style="display: none; margin-top: 15px; border: 1px solid #ddd; padding: 10px; border-radius: 8px;">
                <p><strong>Ngân hàng:</strong> MB Bank Quân Đội</p>
                <p><strong>Số tài khoản:</strong> 864706789</p>
                <p><strong>Chủ tài khoản:</strong> Dương Lý Bình</p>
                <p><strong>Nội dung chuyển khoản:</strong> Đơn hàng #<span id="order-id">IDORDER</span></p>
                <p><strong>Số tiền:</strong> <span id="order-amount">0</span> ₫</p>

                <!-- QR Code -->
                <div style="text-align: center; margin-top: 10px;">
                    <img id="qr-code" src="" alt="QR Code thanh toán" style="max-width: 200px;">
                </div>
            </div>
            <div class="form-check">
                <input class="form-check-input" type="radio" name="phuongThuc" id="momo" value="Momo">
                <label class="form-check-label" for="momo">
                    Ví điện tử Momo
                </label>
            </div>
        </div>
        <c:if test="${isBuyNow}">
            <input type="hidden" name="isBuyNow" value="true" />
            <input type="hidden" name="productId" value="${cartItems[0].sanPham.id}" />
            <input type="hidden" name="quantity" value="${cartItems[0].soLuong}" />
            <input type="hidden" name="size" value="${cartItems[0].kichCo}" />
            <input type="hidden" name="color" value="${cartItems[0].mauSac}" />
        </c:if>

        <button type="submit" class="checkout-btn">Xác nhận đặt hàng</button>
    </form>
</div>

<jsp:include page="../templates/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/qrcode/build/qrcode.min.js"></script>

<script>
    // Khi load trang, mặc định ẩn QR
    document.addEventListener('DOMContentLoaded', function() {
        updateBankInfoVisibility();
    });

    // Lắng nghe thay đổi phương thức thanh toán
    document.querySelectorAll('input[name="phuongThuc"]').forEach(function(radio) {
        radio.addEventListener('change', function() {
            updateBankInfoVisibility();
        });
    });

    function updateBankInfoVisibility() {
        var bankInfoDiv = document.getElementById('bank-info');
        var isBank = document.getElementById('bank').checked;

        if (isBank) {
            // Hiện QR + cập nhật nội dung
            bankInfoDiv.style.display = 'block';

            // Lấy thông tin
            var orderId = 'ORDER' + Math.floor(Math.random() * 1000000);  // Mã random tránh trùng
            var totalAmount = ${total};

            document.getElementById('order-id').innerText = orderId;
            document.getElementById('order-amount').innerText = new Intl.NumberFormat().format(totalAmount);

            // URL QR đúng chuẩn VietQR
            var encodedInfo = encodeURIComponent('Don hang ' + orderId);

            var qrUrl = `https://img.vietqr.io/image/MB-864706789-compact2.png?amount=${totalAmount}&addInfo=${encodedInfo}`;

            document.getElementById('qr-code').src = qrUrl;

        } else {
            // Ẩn QR
            bankInfoDiv.style.display = 'none';
        }
    }
</script>

</body>
</html>
