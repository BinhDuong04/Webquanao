<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt hàng thành công</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        .success-container {
            max-width: 600px;
            margin: 50px auto;
            text-align: center;
        }

        .success-icon {
            font-size: 80px;
            color: #28a745;
            margin-bottom: 20px;
        }

        .success-message {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .btn-home {
            padding: 12px 24px;
            font-size: 18px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            text-decoration: none;
        }

        .btn-home:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<jsp:include page="../templates/header.jsp" />
<jsp:include page="../templates/menu.jsp" />

<div class="success-container">
    <div class="success-icon">
        ✅
    </div>
    <div class="success-message">
        Đặt hàng thành công! Cảm ơn bạn đã mua sắm với chúng tôi.
    </div>
    <a href="${pageContext.request.contextPath}/home" class="btn-home">Về trang chủ</a>
</div>

<jsp:include page="../templates/footer.jsp" />

</body>
</html>
