package com.clothingstore.clothingstore.dao;

import com.clothingstore.clothingstore.entity.SanPham;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.clothingstore.clothingstore.entity.DanhMuc;
import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

@Repository
public class SanPhamDAO {

    @Autowired
    private DataSource dataSource;

    public List<SanPham> findAll() {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham ORDER BY ngayTao DESC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapResult(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Autowired
    private DanhMucDAO danhMucDAO; 
    public List<DanhMuc> findAllDanhMuc() {
        return danhMucDAO.findAll();
    }

    public List<SanPham> search(String keyword) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham WHERE tenSanPham LIKE ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResult(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void save(SanPham sp) {
        String sql = "INSERT INTO SanPham (tenSanPham, moTa, gia, soLuong, hinhAnh, idDanhMuc, ngayTao) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sp.getTenSanPham());
            stmt.setString(2, sp.getMoTa());
            stmt.setDouble(3, sp.getGia());
            stmt.setInt(4, sp.getSoLuong());
            stmt.setString(5, sp.getHinhAnh());
            stmt.setInt(6, sp.getIdDanhMuc());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(SanPham sp) {
        String sql = "UPDATE SanPham SET tenSanPham=?, moTa=?, gia=?, soLuong=?, hinhAnh=?, idDanhMuc=? WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sp.getTenSanPham());
            stmt.setString(2, sp.getMoTa());
            stmt.setDouble(3, sp.getGia());
            stmt.setInt(4, sp.getSoLuong());
            stmt.setString(5, sp.getHinhAnh());
            stmt.setInt(6, sp.getIdDanhMuc());
            stmt.setInt(7, sp.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM SanPham WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public SanPham findById(int id) {
        String sql = "SELECT * FROM SanPham WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapResult(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private SanPham mapResult(ResultSet rs) throws SQLException {
        SanPham sp = new SanPham();
        sp.setId(rs.getInt("id"));
        sp.setTenSanPham(rs.getString("tenSanPham"));
        sp.setMoTa(rs.getString("moTa"));
        sp.setGia(rs.getDouble("gia"));
        sp.setSoLuong(rs.getInt("soLuong"));
        sp.setHinhAnh(rs.getString("hinhAnh"));
        sp.setIdDanhMuc(rs.getInt("idDanhMuc"));
        sp.setNgayTao(rs.getTimestamp("ngayTao"));
        return sp;
    }
}
