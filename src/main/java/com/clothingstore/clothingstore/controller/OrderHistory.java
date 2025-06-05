package com.clothingstore.clothingstore.controller;

import com.clothingstore.clothingstore.dao.*;
import com.clothingstore.clothingstore.entity.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/order")
public class OrderHistory  {

    @Autowired
    private DonHangDAO donHangDAO;

    @Autowired
    private ChiTietDonHangDAO chiTietDonHangDAO;

    @Autowired
    private ThanhToanDAO thanhToanDAO;

    @PersistenceContext
    private EntityManager entityManager;

    @GetMapping("/history")
    public String orderHistory(HttpSession session, Model model) {
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        // Lấy KhachHang
        KhachHang khachHang = entityManager.find(KhachHang.class, user.getId());
        if (khachHang == null) {
            return "redirect:/login";
        }

        // Lấy danh sách đơn hàng của khách
        List<DonHang> dsDonHang = donHangDAO.findByKhachHang(khachHang);
        model.addAttribute("dsDonHang", dsDonHang);

        // Lấy chi tiết đơn hàng theo map {idDonHang -> List<ChiTietDonHang>}
        Map<Integer, List<ChiTietDonHang>> chiTietMap = dsDonHang.stream()
                .collect(Collectors.toMap(
                        DonHang::getId,
                        dh -> chiTietDonHangDAO.findByDonHang(dh)
                ));

        model.addAttribute("chiTietMap", chiTietMap);

        // Lấy map {idDonHang -> ThanhToan}
        Map<Integer, ThanhToan> thanhToanMap = dsDonHang.stream()
                .collect(Collectors.toMap(
                        DonHang::getId,
                        dh -> thanhToanDAO.findByDonHang(dh)
                ));

        model.addAttribute("thanhToanMap", thanhToanMap);

        return "UserJSP/orderHistory";  // bạn sẽ tạo file orderHistory.jsp
    }
}
