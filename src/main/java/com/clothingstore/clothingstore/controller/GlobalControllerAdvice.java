package com.clothingstore.clothingstore.controller;

import com.clothingstore.clothingstore.dao.DanhMucDAO;
import com.clothingstore.clothingstore.entity.DanhMuc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.ui.Model;

import java.util.List;

@ControllerAdvice
public class GlobalControllerAdvice {

    @Autowired
    private DanhMucDAO danhMucDAO;

    @ModelAttribute
    public void addGlobalAttributes(Model model) {
        List<DanhMuc> categories = danhMucDAO.findAll();
        model.addAttribute("categories", categories);
    }
}
