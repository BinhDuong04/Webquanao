package com.clothingstore.clothingstore.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "chitietgiohang")
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

    private String kichCo;
    private String mauSac;

    // Getters & Setters
    public GioHang getGioHang() { return gioHang; }
    public void setGioHang(GioHang gioHang) { this.gioHang = gioHang; }

    public SanPham getSanPham() { return sanPham; }
    public void setSanPham(SanPham sanPham) { this.sanPham = sanPham; }

    public Integer getSoLuong() { return soLuong; }
    public void setSoLuong(Integer soLuong) { this.soLuong = soLuong; }

    public String getKichCo() { return kichCo; }
    public void setKichCo(String kichCo) { this.kichCo = kichCo; }

    public String getMauSac() { return mauSac; }
    public void setMauSac(String mauSac) { this.mauSac = mauSac; }
}
