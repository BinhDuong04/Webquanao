package com.clothingstore.clothingstore.controller;

import com.clothingstore.clothingstore.dao.SanPhamDAO;
import com.clothingstore.clothingstore.entity.SanPham;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.ServletContext;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/admin/products")
public class SanPhamController {

    @Autowired
    private SanPhamDAO sanPhamDAO;

    @Autowired
    private ServletContext context;

    @GetMapping
    public String danhSach(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<SanPham> list = (keyword != null && !keyword.isEmpty())
                ? sanPhamDAO.search(keyword)
                : sanPhamDAO.findAll();
        model.addAttribute("dsSanPham", list);
        model.addAttribute("dsDanhMuc", sanPhamDAO.findAllDanhMuc());
        return "AdminJSP/product";
    }

    @GetMapping("/detail")
    public String chiTiet(@RequestParam("id") int id, Model model) {
        SanPham sanPham = sanPhamDAO.findById(id);
        if (sanPham == null) {
            return "redirect:/admin/products";
        }
        model.addAttribute("sanPham", sanPham);
        model.addAttribute("dsDanhMuc", sanPhamDAO.findAllDanhMuc());
        return "views/productDetail";
    }

    @PostMapping("/add")
    public String them(@ModelAttribute SanPham sp,
                       @RequestParam("imageFiles") MultipartFile[] files) {
        String imageNames = uploadFiles(files);
        if (!imageNames.isEmpty()) {
            sp.setHinhAnh(imageNames);
        } else {
            sp.setHinhAnh("products/default.jpg");
        }
        sanPhamDAO.save(sp);
        return "redirect:/admin/products";
    }

    @PostMapping("/update")
    public String sua(@ModelAttribute SanPham sp,
                      @RequestParam("imageFiles") MultipartFile[] files) {
        String imageNames = uploadFiles(files);
        if (!imageNames.isEmpty()) {
            sp.setHinhAnh(imageNames);
        } else {
            SanPham existing = sanPhamDAO.findById(sp.getId());
            if (existing != null) {
                sp.setHinhAnh(existing.getHinhAnh());
            }
        }
        sanPhamDAO.update(sp);
        return "redirect:/admin/products";
    }

    @GetMapping("/delete")
    public String xoa(@RequestParam("id") int id) {
        sanPhamDAO.delete(id);
        return "redirect:/admin/products";
    }

    private String uploadFiles(MultipartFile[] files) {
        StringBuilder uploaded = new StringBuilder();
        for (MultipartFile file : files) {
            if (!file.isEmpty()) {
                try {
                    String filename = UUID.randomUUID() + "_" + file.getOriginalFilename();
                    String uploadDirPath = new File("src/main/resources/static/images/products").getAbsolutePath();
                    File uploadDir = new File(uploadDirPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    String filePath = uploadDirPath + File.separator + filename;
                    file.transferTo(new File(filePath));
                    if (uploaded.length() > 0) uploaded.append(",");
                    uploaded.append("products/" + filename);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return uploaded.toString();
    }
}