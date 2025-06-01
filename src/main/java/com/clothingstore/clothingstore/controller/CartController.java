package com.clothingstore.clothingstore.controller;

import com.clothingstore.clothingstore.dao.*;
import com.clothingstore.clothingstore.entity.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private GioHangDAO gioHangDAO;

    @Autowired
    private ChiTietGioHangDAO chiTietGioHangDAO;

    @Autowired
    private SanPhamDAO sanPhamDAO;

    @PersistenceContext
    private EntityManager entityManager;

    // Hiển thị giỏ hàng
    @GetMapping
    public String viewCart(HttpSession session, Model model) {
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        // Lấy KhachHang từ EntityManager
        KhachHang khachHang = entityManager.find(KhachHang.class, user.getId());
        if (khachHang == null) {
            return "redirect:/login"; // nếu không có thì về login
        }

        GioHang gioHang = gioHangDAO.findByKhachHang(khachHang);

        List<ChiTietGioHang> cartItems = new ArrayList<>();
        if (gioHang != null) {
            cartItems = chiTietGioHangDAO.findByGioHang(gioHang);
        }

        model.addAttribute("cartItems", cartItems);
        return "UserJSP/cart";
    }

    // Thêm sp vào giỏ
    @PostMapping("/add")
    public String addToCart(@RequestParam("productId") int productId,
                            @RequestParam("quantity") int quantity,
                            HttpSession session) {

        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        KhachHang khachHang = entityManager.find(KhachHang.class, user.getId());
        if (khachHang == null) {
            return "redirect:/login";
        }

        GioHang gioHang = gioHangDAO.findByKhachHang(khachHang);

        // Nếu chưa có giỏ → tạo mới
        if (gioHang == null) {
            gioHang = new GioHang();
            gioHang.setKhachHang(khachHang);
            gioHang.setNgayTao(new Date());
            gioHangDAO.save(gioHang);
        }

        SanPham sp = sanPhamDAO.findById(productId);
        ChiTietGioHang ct = chiTietGioHangDAO.findById(gioHang, sp);

        if (ct == null) {
            ct = new ChiTietGioHang();
            ct.setGioHang(gioHang);
            ct.setSanPham(sp);
            ct.setSoLuong(quantity);
            chiTietGioHangDAO.save(ct);
        } else {
            ct.setSoLuong(ct.getSoLuong() + quantity);
            chiTietGioHangDAO.update(ct);
        }

        return "redirect:/cart";
    }

    // Xoá 1 sản phẩm
    @GetMapping("/remove")
    public String removeItem(@RequestParam("productId") int productId, HttpSession session) {
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        KhachHang khachHang = entityManager.find(KhachHang.class, user.getId());
        if (khachHang == null) {
            return "redirect:/login";
        }

        GioHang gioHang = gioHangDAO.findByKhachHang(khachHang);

        if (gioHang != null) {
            SanPham sp = sanPhamDAO.findById(productId);
            ChiTietGioHang ct = chiTietGioHangDAO.findById(gioHang, sp);
            if (ct != null) {
                chiTietGioHangDAO.delete(ct);
            }
        }

        return "redirect:/cart";
    }

    // API lấy số lượng sản phẩm trong giỏ (cho header)
    @GetMapping("/getCartCount")
    @ResponseBody
    public Map<String, Object> getCartCount(HttpSession session) {
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        int count = 0;

        if (user != null) {
            KhachHang khachHang = entityManager.find(KhachHang.class, user.getId());
            if (khachHang != null) {
                GioHang gioHang = gioHangDAO.findByKhachHang(khachHang);
                if (gioHang != null) {
                    List<ChiTietGioHang> cartItems = chiTietGioHangDAO.findByGioHang(gioHang);
                    count = cartItems.stream().mapToInt(ChiTietGioHang::getSoLuong).sum();
                }
            }
        }

        Map<String, Object> response = new HashMap<>();
        response.put("count", count);
        return response;
    }
}
