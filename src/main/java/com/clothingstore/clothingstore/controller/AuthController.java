package com.clothingstore.clothingstore.controller;

import com.clothingstore.clothingstore.dao.LoginForm;
import com.clothingstore.clothingstore.entity.*;
import com.clothingstore.clothingstore.service.TaiKhoanService;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.LocalDate;

@Controller
public class AuthController {

    @Autowired
    private TaiKhoanService tkService;

    @PersistenceContext
    private EntityManager entityManager;

    @GetMapping("/register")
    public String showRegister(Model model) {
        model.addAttribute("taiKhoan", new TaiKhoan());
        return "Auth/register";
    }

    @Transactional // BẮT BUỘC có vì dùng entityManager.persist()
    @PostMapping("/register")
    public String doRegister(@ModelAttribute TaiKhoan taiKhoan, Model model) {
        // Mặc định tất cả tài khoản đăng ký từ form này là CUSTOMER
        taiKhoan.setVaiTro("CUSTOMER");
        taiKhoan.setNgayTao(LocalDateTime.now());

        // Lưu TaiKhoan
        tkService.save(taiKhoan);

        KhachHang kh = new KhachHang();
        kh.setId(taiKhoan.getId());
        kh.setTaiKhoan(taiKhoan);

        kh.setHoTen(taiKhoan.getTenDangNhap());
        kh.setDiaChi("");
        kh.setGioiTinh("");
        kh.setNgaySinh(LocalDate.now());

        entityManager.persist(kh);

        model.addAttribute("message", "Đăng ký thành công! Mời bạn đăng nhập.");
        return "Auth/login";
    }

    @GetMapping({"/", "/login"})
    public String showLogin(Model model) {
        model.addAttribute("loginForm", new LoginForm());
        return "Auth/login";
    }

    @PostMapping("/login")
    public String doLogin(@ModelAttribute LoginForm form,
                          HttpSession session,
                          Model model) {
        TaiKhoan user = tkService.findByTenDangNhap(form.getTenDangNhap());
        if (user != null && user.getMatKhau().equals(form.getMatKhau())) {
            session.setAttribute("user", user);
            session.setAttribute("logged_in", true);
            session.setAttribute("full_name", user.getTenDangNhap());

            if ("ADMIN".equalsIgnoreCase(user.getVaiTro())) {
                return "redirect:/admin/home";
            } else {
                return "redirect:/customer/home";
            }
        }
        model.addAttribute("error", "Sai tên đăng nhập hoặc mật khẩu");
        return "Auth/login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    @GetMapping("/customer/home")
    public String customerHome() {
        return "UserJSP/index";
    }

    @GetMapping("/admin/home")
    public String adminHome() {
        return "AdminJSP/adminForm";
    }
}
