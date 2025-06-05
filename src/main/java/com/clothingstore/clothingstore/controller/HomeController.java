package com.clothingstore.clothingstore.controller;

import com.clothingstore.clothingstore.dao.SanPhamDAO;
import com.clothingstore.clothingstore.dao.ChiTietSanPhamDAO;  // THÊM VÀO
import com.clothingstore.clothingstore.entity.ChiTietSanPham;
import com.clothingstore.clothingstore.entity.SanPham;
import com.clothingstore.clothingstore.entity.DanhMuc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/home")
public class HomeController {

    @Autowired
    private SanPhamDAO sanPhamDAO;

    @Autowired
    private ChiTietSanPhamDAO chiTietSanPhamDAO;  // THÊM VÀO

    // Trang chủ
    @GetMapping
    public String danhSachSanPham(
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            Model model) {

        List<SanPham> list;
        int totalProducts;
        int totalPages;

        if (keyword != null && !keyword.isEmpty()) {
            list = sanPhamDAO.search(keyword);
            totalProducts = list.size();
            int start = (page - 1) * size;
            int end = Math.min(start + size, list.size());
            list = list.subList(start, end);
            totalPages = (int) Math.ceil((double) totalProducts / size);
        } else {
            list = sanPhamDAO.findNewestProductsPaged(page, size);
            totalProducts = sanPhamDAO.countAllProducts();
            totalPages = (int) Math.ceil((double) totalProducts / size);
        }

        Map<DanhMuc, List<SanPham>> randomCategories = sanPhamDAO.findRandomCategoriesAndProducts();
        List<DanhMuc> danhMucList = sanPhamDAO.findAllDanhMuc();

        model.addAttribute("products", list);
        model.addAttribute("randomCategories", randomCategories);
        model.addAttribute("dsDanhMuc", danhMucList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("pageSize", size);
        model.addAttribute("keyword", keyword);

        return "UserJSP/index";
    }

    // Chi tiết sản phẩm
    @GetMapping("/productDetail")
    public String chiTietSanPham(@RequestParam("id") int id, Model model) {
        SanPham sp = sanPhamDAO.findById(id);
        if (sp == null) {
            return "redirect:/home";
        }

        // Lấy danh sách chi tiết, lấy phần tử đầu tiên (hoặc null nếu không có)
        List<ChiTietSanPham> ctspList = chiTietSanPhamDAO.findBySanPhamId(id);
        ChiTietSanPham ctsp = ctspList.isEmpty() ? null : ctspList.get(0);

        model.addAttribute("product", sp);
        model.addAttribute("chiTietSanPham", ctsp);

        return "UserJSP/productDetail";
    }

}
