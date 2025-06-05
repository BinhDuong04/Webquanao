package com.clothingstore.clothingstore.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "chitietsanpham")
public class ChiTietSanPham {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "idSanPham")
    private int idSanPham;

    @Column(name = "kichCo")
    private String kichCo;

    @Column(name = "mauSac")
    private String mauSac;

    @Column(name = "chatLieu")
    private String chatLieu;

    @Column(name = "thuongHieu")
    private String thuongHieu;

    @Column(name = "form")
    private String form;

    @Column(name = "dacDiem")
    private String dacDiem;

    // Getter - Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdSanPham() { return idSanPham; }
    public void setIdSanPham(int idSanPham) { this.idSanPham = idSanPham; }

    public String getKichCo() { return kichCo; }
    public void setKichCo(String kichCo) { this.kichCo = kichCo; }

    public String getMauSac() { return mauSac; }
    public void setMauSac(String mauSac) { this.mauSac = mauSac; }

    public String getChatLieu() { return chatLieu; }
    public void setChatLieu(String chatLieu) { this.chatLieu = chatLieu; }

    public String getThuongHieu() { return thuongHieu; }
    public void setThuongHieu(String thuongHieu) { this.thuongHieu = thuongHieu; }

    public String getForm() { return form; }
    public void setForm(String form) { this.form = form; }

    public String getDacDiem() { return dacDiem; }
    public void setDacDiem(String dacDiem) { this.dacDiem = dacDiem; }
}
