package com.clothingstore.clothingstore.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "danhmuc")
public class DanhMuc {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String tenDanhMuc;
    private String moTa;

    public DanhMuc() {
    }

    public DanhMuc(int id, String tenDanhMuc, String moTa) {
        this.id = id;
        this.tenDanhMuc = tenDanhMuc;
        this.moTa = moTa;
    }

    // Getter & Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTenDanhMuc() {
        return tenDanhMuc;
    }

    public void setTenDanhMuc(String tenDanhMuc) {
        this.tenDanhMuc = tenDanhMuc;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }
}
