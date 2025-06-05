package com.clothingstore.clothingstore.controller;

import com.clothingstore.clothingstore.dao.SanPhamDAO;
import com.clothingstore.clothingstore.entity.SanPham;
import com.clothingstore.clothingstore.dao.ChiTietSanPhamDAO;
import com.clothingstore.clothingstore.entity.ChiTietSanPham;
import java.util.Map;
import java.util.HashMap;
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

    @Autowired
    private ChiTietSanPhamDAO chiTietSanPhamDAO;


    @GetMapping
    public String danhSach(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<SanPham> list = (keyword != null && !keyword.isEmpty())
                ? sanPhamDAO.search(keyword)
                : sanPhamDAO.findAll();
        model.addAttribute("dsSanPham", list);
        model.addAttribute("dsDanhMuc", sanPhamDAO.findAllDanhMuc());
        Map<Integer, List<ChiTietSanPham>> chiTietMap = new HashMap<>();
            for (SanPham sp : list) {
                chiTietMap.put(sp.getId(), chiTietSanPhamDAO.findBySanPhamId(sp.getId()));
            }
    model.addAttribute("chiTietMap", chiTietMap);
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
                      @RequestParam("imageFiles") MultipartFile[] files,
                      @RequestParam(value = "replaceImages", required = false) String replaceImages,
                      @RequestParam(value = "replaceTargets", required = false) String replaceTargets) {

        StringBuilder imageNames = new StringBuilder();

        // B1: lấy ảnh cũ (ảnh được chọn giữ lại từ replaceImages)
        if (replaceImages != null && !replaceImages.isEmpty()) {
            imageNames.append(replaceImages);
        }

        // B2: upload ảnh mới
        String newImages = uploadFiles(files);
        if (!newImages.isEmpty()) {
            if (imageNames.length() > 0) {
                imageNames.append(",");
            }
            imageNames.append(newImages);
        }

        // Nếu không có ảnh nào (ảnh cũ cũng không có), thì lấy ảnh cũ từ DB
        if (imageNames.length() == 0) {
            SanPham existing = sanPhamDAO.findById(sp.getId());
            if (existing != null && existing.getHinhAnh() != null) {
                imageNames.append(existing.getHinhAnh());
            }
        }

        // Set lại vào sản phẩm
        sp.setHinhAnh(imageNames.toString());
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

        
        String uploadDirPath = context.getRealPath("/images/products");
        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        for (MultipartFile file : files) {
            if (!file.isEmpty()) {
                try {
                    String filename = UUID.randomUUID() + "_" + file.getOriginalFilename();
                    String filePath = uploadDirPath + File.separator + filename;
                    file.transferTo(new File(filePath));

                    
                    if (uploaded.length() > 0) uploaded.append(",");
                    uploaded.append("images/products/" + filename);

                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return uploaded.toString();
    }


    @GetMapping("/category/{id}")
    public String sanPhamTheoDanhMuc(@PathVariable("id") int id,
                                     @RequestParam(value = "sort", required = false) String sort,
                                     Model model) {
        // Lấy danh mục
        var danhMuc = sanPhamDAO.findDanhMucById(id);
        if (danhMuc == null) {
            return "redirect:/";
        }

        // Lấy sản phẩm theo danh mục + sắp xếp
        List<SanPham> list;
        if (sort != null) {
            switch (sort) {
                case "price_asc":
                    list = sanPhamDAO.findByCategoryOrderByPriceAsc(id);
                    break;
                case "price_desc":
                    list = sanPhamDAO.findByCategoryOrderByPriceDesc(id);
                    break;
                
                default:
                    list = sanPhamDAO.findByCategory(id);
            }
        } else {
            list = sanPhamDAO.findByCategory(id);
        }

        // Truyền về view
        model.addAttribute("currentCategory", danhMuc);
        model.addAttribute("products", list);
        model.addAttribute("categories", sanPhamDAO.findAllDanhMuc());
        return "UserJSP/categoryProducts";

    }

    private String[] uploadFilesArray(MultipartFile[] files) {
        List<String> uploaded = new java.util.ArrayList<>();

        String uploadDirPath = context.getRealPath("/images/products");
        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        for (MultipartFile file : files) {
            if (!file.isEmpty()) {
                try {
                    String filename = UUID.randomUUID() + "_" + file.getOriginalFilename();
                    String filePath = uploadDirPath + File.separator + filename;
                    file.transferTo(new File(filePath));

                    uploaded.add("images/products/" + filename);

                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return uploaded.toArray(new String[0]);
    }

}
