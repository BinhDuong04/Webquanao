package com.clothingstore.clothingstore.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "ChiTietGioHang")
@IdClass(ChiTietGioHangId.class)
public class ChiTietGioHang {

    @Id
    @ManyToOne
    @JoinColumn(name = "idGioHang")
    private GioHang gioHang;

    @Id
    @ManyToOne
    @JoinColumn(name = "idSanPham")
    private SanPham sanPham;

    private Integer soLuong;

    // Getters & Setters
    public GioHang getGioHang() { return gioHang; }
    public void setGioHang(GioHang gioHang) { this.gioHang = gioHang; }

    public SanPham getSanPham() { return sanPham; }
    public void setSanPham(SanPham sanPham) { this.sanPham = sanPham; }

    public Integer getSoLuong() { return soLuong; }
    public void setSoLuong(Integer soLuong) { this.soLuong = soLuong; }
}
