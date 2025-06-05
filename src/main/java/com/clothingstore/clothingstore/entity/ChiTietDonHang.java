package com.clothingstore.clothingstore.entity;

import jakarta.persistence.*;

@Entity
@IdClass(ChiTietDonHangId.class)
@Table(name = "chitietdonhang")
public class ChiTietDonHang {

    @Id
    @ManyToOne
    @JoinColumn(name = "idDonHang")
    private DonHang donHang;

    @Id
    @ManyToOne
    @JoinColumn(name = "idSanPham")
    private SanPham sanPham;

    private int soLuong;
    private double donGia;

    private String kichCo;
    private String mauSac;

    // Getters & Setters
    public DonHang getDonHang() {
        return donHang;
    }

    public void setDonHang(DonHang donHang) {
        this.donHang = donHang;
    }

    public SanPham getSanPham() {
        return sanPham;
    }

    public void setSanPham(SanPham sanPham) {
        this.sanPham = sanPham;
    }

    public int getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(int soLuong) {
        this.soLuong = soLuong;
    }

    public double getDonGia() {
        return donGia;
    }

    public void setDonGia(double donGia) {
        this.donGia = donGia;
    }

    public String getKichCo() { return kichCo; }
    public void setKichCo(String kichCo) { this.kichCo = kichCo; }

    public String getMauSac() { return mauSac; }
    public void setMauSac(String mauSac) { this.mauSac = mauSac; }
}
