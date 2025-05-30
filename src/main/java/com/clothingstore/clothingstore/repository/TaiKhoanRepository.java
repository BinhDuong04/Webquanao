package com.clothingstore.clothingstore.repository;

import com.clothingstore.clothingstore.entity.TaiKhoan;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TaiKhoanRepository extends JpaRepository<TaiKhoan, Integer> {

    TaiKhoan findByTenDangNhap(String tenDangNhap);
}