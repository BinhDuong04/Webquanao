package com.clothingstore.clothingstore.controller;

import com.clothingstore.clothingstore.dao.*;
import com.clothingstore.clothingstore.entity.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;

@Controller
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private DonHangDAO donHangDAO;

    @Autowired
    private ChiTietDonHangDAO chiTietDonHangDAO;

    @Autowired
    private GioHangDAO gioHangDAO;

    @Autowired
    private ChiTietGioHangDAO chiTietGioHangDAO;

    @Autowired
    private SanPhamDAO sanPhamDAO;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private ThanhToanDAO thanhToanDAO;

    // Trang checkout
    @GetMapping("/checkout")
    public String checkoutPage(
            @RequestParam(value = "productId", required = false) Integer productId,
            @RequestParam(value = "quantity", required = false) Integer quantity,
            @RequestParam(value = "size", required = false) String size,
            @RequestParam(value = "color", required = false) String color,
            HttpSession session,
            Model model
    ) {
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        KhachHang khachHang = entityManager.find(KhachHang.class, user.getId());
        if (khachHang == null) {
            return "redirect:/login";
        }

        // Nếu có productId → MUA NGAY
        if (productId != null && quantity != null) {
            SanPham sp = sanPhamDAO.findById(productId);

            if (sp == null) {
                return "redirect:/home";
            }

            // Fake 1 ChiTietGioHang để truyền qua view
            ChiTietGioHang tempItem = new ChiTietGioHang();
            tempItem.setSanPham(sp);
            tempItem.setSoLuong(quantity);
            tempItem.setKichCo(size);
            tempItem.setMauSac(color);

            List<ChiTietGioHang> singleItemList = new ArrayList<>();
            singleItemList.add(tempItem);

            model.addAttribute("cartItems", singleItemList);
            model.addAttribute("isBuyNow", true); // Cờ để view biết đây là "Mua ngay"

        } else {
            // Ngược lại → đặt từ giỏ hàng
            GioHang gioHang = gioHangDAO.findByKhachHang(khachHang);
            List<ChiTietGioHang> cartItems = new ArrayList<>();

            if (gioHang != null) {
                cartItems = chiTietGioHangDAO.findByGioHang(gioHang);
            }

            if (cartItems.isEmpty()) {
                return "redirect:/cart";
            }

            model.addAttribute("cartItems", cartItems);
            model.addAttribute("isBuyNow", false);
        }

        return "UserJSP/checkout";
    }

    // Xử lý đặt hàng
    @PostMapping("/placeOrder")
    @Transactional
    public String placeOrder(
            HttpSession session,
            @RequestParam("hoTen") String hoTen,
            @RequestParam("diaChi") String diaChi,
            @RequestParam("sdt") String sdt,
            @RequestParam("phuongThuc") String phuongThuc,
            @RequestParam(value = "isBuyNow", required = false) String isBuyNow,
            @RequestParam(value = "productId", required = false) Integer productId,
            @RequestParam(value = "quantity", required = false) Integer quantity,
            @RequestParam(value = "size", required = false) String size,
            @RequestParam(value = "color", required = false) String color,
            RedirectAttributes redirectAttributes
    ) {
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        KhachHang khachHang = entityManager.find(KhachHang.class, user.getId());
        if (khachHang == null) {
            return "redirect:/login";
        }

        List<ChiTietGioHang> cartItems = new ArrayList<>();

        if ("true".equals(isBuyNow)) {
            // MUA NGAY
            SanPham sp = sanPhamDAO.findById(productId);
            if (sp == null) {
                return "redirect:/home";
            }

            ChiTietGioHang tempItem = new ChiTietGioHang();
            tempItem.setSanPham(sp);
            tempItem.setSoLuong(quantity);
            tempItem.setKichCo(size);
            tempItem.setMauSac(color);

            cartItems.add(tempItem);
        } else {
            // Đặt từ giỏ hàng
            GioHang gioHang = gioHangDAO.findByKhachHang(khachHang);
            if (gioHang == null) {
                return "redirect:/cart";
            }

            cartItems = chiTietGioHangDAO.findByGioHang(gioHang);
            if (cartItems.isEmpty()) {
                return "redirect:/cart";
            }
        }

        // Tính tổng tiền
        double total = cartItems.stream()
                .mapToDouble(item -> item.getSanPham().getGia() * item.getSoLuong())
                .sum();

        // Tạo đơn hàng
        DonHang order = new DonHang();
        order.setKhachHang(khachHang);
        order.setNgayDat(new Date());
        order.setTrangThai("Đang xử lý");
        order.setTongTien(total);

        // Set thông tin giao hàng
        order.setHoTenNguoiNhan(hoTen);
        order.setDiaChiGiaoHang(diaChi);
        order.setSdtNguoiNhan(sdt);

        donHangDAO.save(order);

        // Lưu chi tiết đơn hàng
        for (ChiTietGioHang cartItem : cartItems) {
            // 🔥 LẤY LẠI SanPham từ DB để tránh lỗi detached:
            SanPham sp = sanPhamDAO.findById(cartItem.getSanPham().getId());

            ChiTietDonHang ct = new ChiTietDonHang();
            ct.setDonHang(order);
            ct.setSanPham(sp); // Managed entity
            ct.setSoLuong(cartItem.getSoLuong());
            ct.setDonGia(sp.getGia());
            ct.setKichCo(cartItem.getKichCo());
            ct.setMauSac(cartItem.getMauSac());
            chiTietDonHangDAO.save(ct);

            // Cập nhật tồn kho
            sp.setSoLuong(sp.getSoLuong() - cartItem.getSoLuong());
            sanPhamDAO.update(sp);
        }

        // Lưu thanh toán
        ThanhToan thanhToan = new ThanhToan();
        thanhToan.setDonHang(order);
        thanhToan.setPhuongThuc(phuongThuc);
        thanhToan.setTrangThai("Chưa thanh toán");
        thanhToan.setNgayThanhToan(new Date());
        thanhToanDAO.save(thanhToan);

        // Nếu đặt từ giỏ hàng → xóa giỏ hàng
        if (!"true".equals(isBuyNow)) {
            GioHang gioHang = gioHangDAO.findByKhachHang(khachHang);
            if (gioHang != null) {
                chiTietGioHangDAO.deleteAllByGioHang(gioHang);
            }
        }

        // Gửi thông tin sang success page
        redirectAttributes.addFlashAttribute("orderId", order.getId());
        redirectAttributes.addFlashAttribute("totalAmount", order.getTongTien());
        redirectAttributes.addFlashAttribute("phuongThuc", phuongThuc);

        return "redirect:/order/success";
    }

    @GetMapping("/success")
    public String orderSuccessPage() {
        return "UserJSP/orderSuccess";
    }
}
