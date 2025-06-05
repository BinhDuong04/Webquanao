package com.clothingstore.clothingstore.dao;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author ASUS
 */
import com.clothingstore.clothingstore.entity.TinTuc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class TinTucDAO {

    @Autowired
    private DataSource dataSource;

    public List<TinTuc> findAll() {
        List<TinTuc> list = new ArrayList<>();
        String sql = "SELECT * FROM tintuc ORDER BY ngayDang DESC";
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

    public List<TinTuc> search(String keyword) {
        List<TinTuc> list = new ArrayList<>();
        String sql = "SELECT * FROM tintuc WHERE tieuDe LIKE ? ORDER BY ngayDang DESC";
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

    public void save(TinTuc tt) {
        String sql = "INSERT INTO tintuc (tieuDe, noiDung, hinhAnh, ngayDang, idAdmin) VALUES (?, ?, ?, NOW(), ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, tt.getTieuDe());
            stmt.setString(2, tt.getNoiDung());
            stmt.setString(3, tt.getHinhAnh());
            stmt.setObject(4, tt.getIdAdmin());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(TinTuc tt) {
        String sql = "UPDATE tintuc SET tieuDe=?, noiDung=?, hinhAnh=?, idAdmin=? WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, tt.getTieuDe());
            stmt.setString(2, tt.getNoiDung());
            stmt.setString(3, tt.getHinhAnh());
            stmt.setObject(4, tt.getIdAdmin());
            stmt.setInt(5, tt.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM tintuc WHERE id=?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public TinTuc findById(int id) {
        String sql = "SELECT * FROM tintuc WHERE id=?";
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

    private TinTuc mapResult(ResultSet rs) throws SQLException {
        TinTuc tt = new TinTuc();
        tt.setId(rs.getInt("id"));
        tt.setTieuDe(rs.getString("tieuDe"));
        tt.setNoiDung(rs.getString("noiDung"));
        tt.setHinhAnh(rs.getString("hinhAnh"));
        tt.setNgayDang(rs.getTimestamp("ngayDang"));
        tt.setIdAdmin((Integer) rs.getObject("idAdmin"));
        return tt;
    }
}