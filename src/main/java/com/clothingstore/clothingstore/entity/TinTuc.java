package com.clothingstore.clothingstore.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "tintuc")
public class TinTuc {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String tieuDe;
    private String noiDung;
    private String hinhAnh;

    @Temporal(TemporalType.TIMESTAMP)
    private Date ngayDang;

    private Integer idAdmin;

    public TinTuc() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }

    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }

    public Date getNgayDang() { return ngayDang; }
    public void setNgayDang(Date ngayDang) { this.ngayDang = ngayDang; }

    public Integer getIdAdmin() { return idAdmin; }
    public void setIdAdmin(Integer idAdmin) { this.idAdmin = idAdmin; }
}
