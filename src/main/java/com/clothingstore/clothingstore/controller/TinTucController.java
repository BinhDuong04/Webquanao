/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.clothingstore.clothingstore.controller;
import com.clothingstore.clothingstore.dao.TinTucDAO;
import com.clothingstore.clothingstore.entity.TinTuc;
import jakarta.servlet.ServletContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.*;

@Controller
@RequestMapping("/admin/news")
public class TinTucController {

    @Autowired
    private TinTucDAO tinTucDAO;

    @Autowired
    private ServletContext context;

    @GetMapping
    public String danhSach(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<TinTuc> list = (keyword != null && !keyword.isEmpty())
                ? tinTucDAO.search(keyword)
                : tinTucDAO.findAll();
        model.addAttribute("dsTinTuc", list);
        return "AdminJSP/news";
    }

    @PostMapping("/add")
    public String them(@ModelAttribute TinTuc tt,
                       @RequestParam("imageFiles") MultipartFile[] files) {

        String imageNames = uploadFiles(files);
        if (!imageNames.isEmpty()) {
            tt.setHinhAnh(imageNames);
        } else {
            tt.setHinhAnh("images/news/default.jpg");
        }

        tinTucDAO.save(tt);
        return "redirect:/admin/news";
    }

    @PostMapping("/update")
    public String sua(@ModelAttribute TinTuc tt,
                      @RequestParam("imageFiles") MultipartFile[] files,
                      @RequestParam(value = "replaceImages", required = false) String replaceImages) {

        StringBuilder imageNames = new StringBuilder();

        if (replaceImages != null && !replaceImages.isEmpty()) {
            imageNames.append(replaceImages);
        }

        String newImages = uploadFiles(files);
        if (!newImages.isEmpty()) {
            if (imageNames.length() > 0) imageNames.append(",");
            imageNames.append(newImages);
        }

        if (imageNames.length() == 0) {
            TinTuc existing = tinTucDAO.findById(tt.getId());
            if (existing != null && existing.getHinhAnh() != null) {
                imageNames.append(existing.getHinhAnh());
            }
        }

        tt.setHinhAnh(imageNames.toString());
        tinTucDAO.update(tt);
        return "redirect:/admin/news";
    }

    @GetMapping("/delete")
    public String xoa(@RequestParam("id") int id) {
        tinTucDAO.delete(id);
        return "redirect:/admin/news";
    }

    private String uploadFiles(MultipartFile[] files) {
        StringBuilder uploaded = new StringBuilder();

        // Đường dẫn: D:\Downloads\clothingstore\clothingstore\src\main\resources\static\images\news
        String uploadDirPath = context.getRealPath("/images/news");
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
                    uploaded.append("images/news/" + filename);

                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return uploaded.toString();
    }
}