package com.clothingstore.clothingstore.dao;

import com.clothingstore.clothingstore.entity.DanhMuc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class DanhMucDAO {

    @Autowired
    private DataSource dataSource;

    public List<DanhMuc> findAll() {
        List<DanhMuc> list = new ArrayList<>();
        String sql = "SELECT * FROM DanhMuc";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                DanhMuc dm = new DanhMuc(
                        rs.getInt("id"),
                        rs.getString("tenDanhMuc"),
                        rs.getString("moTa")
                );
                list.add(dm);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<DanhMuc> timKiem(String keyword) {
        List<DanhMuc> list = new ArrayList<>();
        String sql = "SELECT * FROM DanhMuc WHERE tenDanhMuc LIKE ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                DanhMuc dm = new DanhMuc(
                        rs.getInt("id"),
                        rs.getString("tenDanhMuc"),
                        rs.getString("moTa")
                );
                list.add(dm);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void save(DanhMuc dm) {
        String sql = "INSERT INTO DanhMuc (tenDanhMuc, moTa) VALUES (?, ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, dm.getTenDanhMuc());
            stmt.setString(2, dm.getMoTa());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(DanhMuc dm) {
        String sql = "UPDATE DanhMuc SET tenDanhMuc = ?, moTa = ? WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, dm.getTenDanhMuc());
            stmt.setString(2, dm.getMoTa());
            stmt.setInt(3, dm.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM DanhMuc WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public DanhMuc findById(int id) {
        String sql = "SELECT * FROM DanhMuc WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                DanhMuc dm = new DanhMuc();
                dm.setId(rs.getInt("id"));
                dm.setTenDanhMuc(rs.getString("tenDanhMuc"));
                dm.setMoTa(rs.getString("moTa"));  // BỔ SUNG DÒNG NÀY
                return dm;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

}
