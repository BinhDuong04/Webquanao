package com.clothingstore.clothingstore.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "sanpham")
public class SanPham {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String tenSanPham;
    private String moTa;
    private double gia;
    private int soLuong;
    private String hinhAnh;
    private int idDanhMuc;

    @Temporal(TemporalType.TIMESTAMP)
    private Date ngayTao;

    // Thêm thuộc tính danhMuc (OOP)
    @Transient
    private DanhMuc danhMuc;

    public SanPham() {
    }

    public SanPham(int id, String tenSanPham, String moTa, double gia, int soLuong, String hinhAnh, int idDanhMuc, Date ngayTao) {
        this.id = id;
        this.tenSanPham = tenSanPham;
        this.moTa = moTa;
        this.gia = gia;
        this.soLuong = soLuong;
        this.hinhAnh = hinhAnh;
        this.idDanhMuc = idDanhMuc;
        this.ngayTao = ngayTao;
    }

    // GETTERS & SETTERS
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTenSanPham() { return tenSanPham; }
    public void setTenSanPham(String tenSanPham) { this.tenSanPham = tenSanPham; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }

    public double getGia() { return gia; }
    public void setGia(double gia) { this.gia = gia; }

    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }

    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }

    public int getIdDanhMuc() { return idDanhMuc; }
    public void setIdDanhMuc(int idDanhMuc) { this.idDanhMuc = idDanhMuc; }

    public Date getNgayTao() { return ngayTao; }
    public void setNgayTao(Date ngayTao) { this.ngayTao = ngayTao; }

    // GETTER SETTER cho DanhMuc
    public DanhMuc getDanhMuc() { return danhMuc; }
    public void setDanhMuc(DanhMuc danhMuc) { this.danhMuc = danhMuc; }
}
