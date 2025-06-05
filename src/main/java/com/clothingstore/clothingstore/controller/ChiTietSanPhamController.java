package com.clothingstore.clothingstore.controller;

import com.clothingstore.clothingstore.dao.ChiTietSanPhamDAO;
import com.clothingstore.clothingstore.dao.SanPhamDAO;
import com.clothingstore.clothingstore.entity.ChiTietSanPham;
import com.clothingstore.clothingstore.entity.SanPham;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/products/details")
public class ChiTietSanPhamController {

    @Autowired
    private ChiTietSanPhamDAO chiTietSanPhamDAO;

    @Autowired
    private SanPhamDAO sanPhamDAO;

    @PostMapping("/add")
    public String addOrUpdate(@ModelAttribute ChiTietSanPham ctsp,
                              @RequestParam("idSanPham") int idSanPham,
                              @RequestParam(value = "id", required = false) Integer id) {

        ctsp.setIdSanPham(idSanPham);

        if (id != null && id > 0) {
            // Cập nhật
            ctsp.setId(id);
            chiTietSanPhamDAO.update(ctsp);
        } else {
            // Thêm mới
            chiTietSanPhamDAO.save(ctsp);
        }

        return "redirect:/admin/products";
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("id") int id, @RequestParam("idSanPham") int idSanPham) {
        chiTietSanPhamDAO.delete(id);
        return "redirect:/admin/products";
    }
    
}
