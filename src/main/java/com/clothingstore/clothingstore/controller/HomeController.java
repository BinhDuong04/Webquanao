package com.clothingstore.clothingstore.controller;

import com.clothingstore.clothingstore.dao.DanhMucDAO;
import com.clothingstore.clothingstore.dao.SanPhamDAO;
import com.clothingstore.clothingstore.entity.DanhMuc;
import com.clothingstore.clothingstore.entity.SanPham;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class HomeController {

    @Autowired
    private DanhMucDAO danhMucDAO;

    @Autowired
    private SanPhamDAO sanPhamDAO;

    @GetMapping("/")
    public String index(Model model) {

        // Lấy danh mục
        List<DanhMuc> categories = danhMucDAO.findAll();

        // Lấy sản phẩm mới nhất
        List<SanPham> products = sanPhamDAO.findNewestProducts();
        System.out.println("==> Tổng số sản phẩm mới nhất: " + products.size()); // DEBUG

        // Random 3 danh mục làm randomCategories
        List<DanhMuc> randomCategories = categories.stream().limit(3).collect(Collectors.toList());

        // Tạo map sản phẩm theo danh mục (productsByCategory)
        Map<Integer, List<SanPham>> productsByCategory = randomCategories.stream()
                .collect(Collectors.toMap(
                        DanhMuc::getId,
                        cat -> sanPhamDAO.findProductsByCategory(cat.getId())
                ));

        // Remaining categories
        List<DanhMuc> remainingCategories = categories.stream().skip(3).collect(Collectors.toList());
        Map<Integer, List<SanPham>> otherProducts = remainingCategories.stream()
                .collect(Collectors.toMap(
                        DanhMuc::getId,
                        cat -> sanPhamDAO.findProductsByCategory(cat.getId())
                ));

        Integer firstCategoryId = remainingCategories.isEmpty() ? null : remainingCategories.get(0).getId();

        // Truyền vào model
        model.addAttribute("categories", categories);
        model.addAttribute("products", products);
        model.addAttribute("randomCategories", randomCategories);
        model.addAttribute("productsByCategory", productsByCategory);
        model.addAttribute("remainingCategories", remainingCategories);
        model.addAttribute("otherProducts", otherProducts);
        model.addAttribute("firstCategoryId", firstCategoryId);

        // Trả về trang index.jsp trong UserJSP
        return "UserJSP/index";
    }

}
