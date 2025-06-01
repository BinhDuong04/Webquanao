package com.clothingstore.clothingstore.config;

import com.clothingstore.clothingstore.entity.TaiKhoan;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.ui.Model;

@ControllerAdvice
public class GlobalModelAttribute {

    @ModelAttribute
    public void addCommonAttributes(Model model, HttpSession session) {
        TaiKhoan user = (TaiKhoan) session.getAttribute("user");
        if (user != null) {
            model.addAttribute("isLoggedIn", true);
            model.addAttribute("fullName", user.getTenDangNhap());
        } else {
            model.addAttribute("isLoggedIn", false);
        }
    }
}
