package com.clothingstore.clothingstore.controller;

import com.clothingstore.clothingstore.dao.DanhMucDAO;
import com.clothingstore.clothingstore.entity.DanhMuc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/danhmuc")
public class DanhMucController {

    @Autowired
    private DanhMucDAO danhMucDAO;

    @GetMapping
    public String danhSach(Model model, @RequestParam(value = "keyword", required = false) String keyword) {
        List<DanhMuc> list = (keyword != null && !keyword.isEmpty())
                ? danhMucDAO.timKiem(keyword)
                : danhMucDAO.findAll();
        model.addAttribute("dsDanhMuc", list);
        return "AdminJSP/danhMuc";
    }

    @PostMapping("/add")
    public String them(@ModelAttribute DanhMuc dm) {
        danhMucDAO.save(dm);
        return "redirect:/admin/danhmuc";
    }

    @PostMapping("/update")
    public String sua(@ModelAttribute DanhMuc dm) {
        danhMucDAO.update(dm);
        return "redirect:/admin/danhmuc";
    }

    @GetMapping("/delete")
    public String xoa(@RequestParam("id") int id) {
        danhMucDAO.delete(id);
        return "redirect:/admin/danhmuc";
    }
}
