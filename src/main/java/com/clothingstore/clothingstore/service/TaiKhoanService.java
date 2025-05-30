package com.clothingstore.clothingstore.service;

import com.clothingstore.clothingstore.entity.TaiKhoan;

public interface TaiKhoanService {

    TaiKhoan save(TaiKhoan taiKhoan);

    TaiKhoan findByTenDangNhap(String tenDangNhap);
}