package com.clothingstore.clothingstore.controller;

import com.clothingstore.clothingstore.dao.LoginForm;
import com.clothingstore.clothingstore.entity.TaiKhoan;
import com.clothingstore.clothingstore.service.TaiKhoanService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@Controller
public class AuthController {

  @Autowired
  private TaiKhoanService tkService;

  @GetMapping("/register")
  public String showRegister(Model model) {
    model.addAttribute("taiKhoan", new TaiKhoan());
    return "Auth/register";
  }

  @PostMapping("/register")
  public String doRegister(@ModelAttribute TaiKhoan taiKhoan, Model model) {
    taiKhoan.setVaiTro("CUSTOMER");
    taiKhoan.setNgayTao(LocalDateTime.now());
    tkService.save(taiKhoan);
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
    return "UserJSP/customerForm";
  }

  @GetMapping("/admin/home")
  public String adminHome() {
    return "AdminJSP/adminForm";
  }
}

