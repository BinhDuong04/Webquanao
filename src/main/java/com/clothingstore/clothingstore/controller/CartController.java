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

        KhachHang khachHang = entityManager.find(KhachHang.class, user.getId());
        if (khachHang == null) {
            return "redirect:/login";
        }

        GioHang gioHang = gioHangDAO.findByKhachHang(khachHang);

        List<ChiTietGioHang> cartItems = new ArrayList<>();
        if (gioHang != null) {
            cartItems = chiTietGioHangDAO.findByGioHang(gioHang);
        }

        model.addAttribute("cartItems", cartItems);
        return "UserJSP/cart";
    }

    // Thêm sản phẩm vào giỏ
    @PostMapping("/add")
    @ResponseBody
    public Map<String, Object> addToCart(@RequestParam("productId") int productId,
                                     @RequestParam("quantity") int quantity,
                                     @RequestParam(value = "size", required = false) String size,
                                     @RequestParam(value = "color", required = false) String color,
                                     HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        if (user == null) {
            response.put("status", "error");
            response.put("message", "Bạn cần đăng nhập trước khi thêm sản phẩm vào giỏ hàng.");
            return response;
        }

        KhachHang khachHang = entityManager.find(KhachHang.class, user.getId());
        if (khachHang == null) {
            response.put("status", "error");
            response.put("message", "Không tìm thấy thông tin khách hàng.");
            return response;
        }

        GioHang gioHang = gioHangDAO.findByKhachHang(khachHang);

        if (gioHang == null) {
            gioHang = new GioHang();
            gioHang.setKhachHang(khachHang);
            gioHang.setNgayTao(new Date());
            gioHangDAO.save(gioHang);
        }

        SanPham sp = sanPhamDAO.findById(productId);

        if (sp == null) {
            response.put("status", "error");
            response.put("message", "Sản phẩm không tồn tại.");
            return response;
        }

        // Tìm theo productId - nhưng hiện tại phương thức findById chỉ theo idGioHang + idSanPham
        // Nếu muốn phân biệt theo size + color → bạn cần tạo thêm phương thức findByFullKey nếu cần.

        ChiTietGioHang ct = chiTietGioHangDAO.findById(gioHang, sp);

        if (ct == null) {
            ct = new ChiTietGioHang();
            ct.setGioHang(gioHang);
            ct.setSanPham(sp);
            ct.setSoLuong(quantity);
            ct.setKichCo(size);
            ct.setMauSac(color);
            chiTietGioHangDAO.save(ct);
        } else {
            // Nếu muốn cộng dồn, bạn có thể kiểm tra size + color có khớp không!
            ct.setSoLuong(ct.getSoLuong() + quantity);
            ct.setKichCo(size);
            ct.setMauSac(color);
            chiTietGioHangDAO.update(ct);
        }

        response.put("status", "success");
        response.put("message", "Đã thêm sản phẩm vào giỏ hàng!");
        return response;
    }

    // Xóa 1 sản phẩm khỏi giỏ
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

    // API: lấy số sản phẩm khác nhau trong giỏ
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
                    count = cartItems.size();
                }
            }
        }

        Map<String, Object> response = new HashMap<>();
        response.put("count", count);
        return response;
    }

    // API: Cập nhật số lượng sản phẩm
    @PostMapping("/update")
    @ResponseBody
    public Map<String, Object> updateQuantity(@RequestParam("productId") int productId,
                                              @RequestParam("quantity") int quantity,
                                              HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        if (user == null) {
            response.put("status", "error");
            response.put("message", "Bạn cần đăng nhập.");
            return response;
        }

        KhachHang khachHang = entityManager.find(KhachHang.class, user.getId());
        if (khachHang == null) {
            response.put("status", "error");
            response.put("message", "Không tìm thấy khách hàng.");
            return response;
        }

        GioHang gioHang = gioHangDAO.findByKhachHang(khachHang);
        if (gioHang == null) {
            response.put("status", "error");
            response.put("message", "Giỏ hàng không tồn tại.");
            return response;
        }

        SanPham sp = sanPhamDAO.findById(productId);
        if (sp == null) {
            response.put("status", "error");
            response.put("message", "Sản phẩm không tồn tại.");
            return response;
        }

        ChiTietGioHang ct = chiTietGioHangDAO.findById(gioHang, sp);
        if (ct == null) {
            response.put("status", "error");
            response.put("message", "Sản phẩm không có trong giỏ.");
            return response;
        }

        //Kiểm tra tồn kho
        if (quantity > sp.getSoLuong()) {
            response.put("status", "error");
            response.put("message", "Số lượng vượt quá số lượng còn trong kho (" + sp.getSoLuong() + " sản phẩm).");
            return response;
        }

        // Cập nhật số lượng
        ct.setSoLuong(quantity);
        chiTietGioHangDAO.update(ct);

        response.put("status", "success");
        response.put("message", "Đã cập nhật số lượng.");
        return response;
    }

}
