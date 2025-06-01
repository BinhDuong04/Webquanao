package com.clothingstore.clothingstore.entity;

import java.io.Serializable;
import java.util.Objects;

public class ChiTietGioHangId implements Serializable {
    private Integer gioHang;
    private Integer sanPham;

    // Constructors
    public ChiTietGioHangId() {}

    public ChiTietGioHangId(Integer gioHang, Integer sanPham) {
        this.gioHang = gioHang;
        this.sanPham = sanPham;
    }

    // equals & hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ChiTietGioHangId that = (ChiTietGioHangId) o;
        return Objects.equals(gioHang, that.gioHang) &&
               Objects.equals(sanPham, that.sanPham);
    }

    @Override
    public int hashCode() {
        return Objects.hash(gioHang, sanPham);
    }
}

