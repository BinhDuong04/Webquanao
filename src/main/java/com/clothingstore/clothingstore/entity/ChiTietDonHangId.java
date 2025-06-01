package com.clothingstore.clothingstore.entity;

import java.io.Serializable;
import java.util.Objects;

public class ChiTietDonHangId implements Serializable {
    private Integer donHang;
    private Integer sanPham;

    // Constructors
    public ChiTietDonHangId() {}

    public ChiTietDonHangId(Integer donHang, Integer sanPham) {
        this.donHang = donHang;
        this.sanPham = sanPham;
    }

    // equals & hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ChiTietDonHangId that = (ChiTietDonHangId) o;
        return Objects.equals(donHang, that.donHang) &&
               Objects.equals(sanPham, that.sanPham);
    }

    @Override
    public int hashCode() {
        return Objects.hash(donHang, sanPham);
    }
}
