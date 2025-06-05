package com.clothingstore.clothingstore.dao;

public class LoginForm {

    private String tenDangNhap;
    private String matKhau;

    // Constructors
    public LoginForm() {}

    // Getters and Setters
    public String getTenDangNhap() {
        return tenDangNhap;
    }

    public void setTenDangNhap(String tenDangNhap) {
        this.tenDangNhap = tenDangNhap;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
    }
}
