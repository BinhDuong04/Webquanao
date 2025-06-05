package com.clothingstore.clothingstore.controller;

import com.clothingstore.clothingstore.dao.*;
import com.clothingstore.clothingstore.entity.*;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Controller
@RequestMapping("/admin/orders")
public class AdminOrderController {

    @Autowired
    private DonHangDAO donHangDAO;

    @Autowired
    private ThanhToanDAO thanhToanDAO;

    @Autowired
    private ChiTietDonHangDAO chiTietDonHangDAO;

    @GetMapping
    public String listOrders(Model model) {
        List<DonHang> dsDonHang = donHangDAO.findAll();

        Map<Integer, ThanhToan> thanhToanMap = new HashMap<>();
        Map<Integer, List<ChiTietDonHang>> chiTietMap = new HashMap<>();

        for (DonHang dh : dsDonHang) {
            ThanhToan tt = thanhToanDAO.findByDonHang(dh);
            List<ChiTietDonHang> ctList = chiTietDonHangDAO.findByDonHang(dh);

            thanhToanMap.put(dh.getId(), tt);
            chiTietMap.put(dh.getId(), ctList);
        }

        model.addAttribute("dsDonHang", dsDonHang);
        model.addAttribute("thanhToanMap", thanhToanMap);
        model.addAttribute("chiTietMap", chiTietMap);

        return "AdminJSP/order";
    }

    @PostMapping("/update")
    @Transactional
    public String updateOrderStatus(
            @RequestParam("orderId") int orderId,
            @RequestParam("trangThai") String trangThai,
            @RequestParam(value = "trangThaiThanhToan", required = false) String trangThaiThanhToan
    ) {
        DonHang order = donHangDAO.findById(orderId);
        if (order != null) {
            order.setTrangThai(trangThai);
            donHangDAO.update(order);
        }

        ThanhToan tt = thanhToanDAO.findByDonHang(order);
        if (tt != null && trangThaiThanhToan != null) {
            tt.setTrangThai(trangThaiThanhToan);
            thanhToanDAO.update(tt);
        }

        return "redirect:/admin/orders";
    }
}
