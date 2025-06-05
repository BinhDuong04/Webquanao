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

    @Autowired
    private DanhMucDAO danhMucDAO; 

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
            stmt.setString(5, sp.getHinhAnh()); // Lưu đường dẫn hình ảnh đúng
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
            stmt.setString(5, sp.getHinhAnh()); // Lưu đường dẫn hình ảnh đúng
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

        int idDanhMuc = rs.getInt("idDanhMuc");
        sp.setIdDanhMuc(idDanhMuc);

        // Thêm dòng này để set đối tượng danhMuc
        DanhMuc dm = danhMucDAO.findById(idDanhMuc);
        sp.setDanhMuc(dm);

        sp.setNgayTao(rs.getTimestamp("ngayTao"));
        return sp;
    }
    

    // Lấy sản phẩm theo danh mục
    public List<SanPham> findProductsByCategory(int categoryId) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham WHERE idDanhMuc = ? ORDER BY ngayTao DESC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResult(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Map<DanhMuc, List<SanPham>> findRandomCategoriesAndProducts() {
        Map<DanhMuc, List<SanPham>> result = new LinkedHashMap<>();
        String sqlCategories = "SELECT * FROM DanhMuc ORDER BY RAND() LIMIT 3";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sqlCategories);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                DanhMuc dm = new DanhMuc();
                dm.setId(rs.getInt("id"));
                dm.setTenDanhMuc(rs.getString("tenDanhMuc"));
                List<SanPham> products = findProductsByCategory(dm.getId());
                result.put(dm, products);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    public List<SanPham> findNewestProductsPaged(int page, int size) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham ORDER BY ngayTao DESC LIMIT ? OFFSET ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, size);
            stmt.setInt(2, (page - 1) * size);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResult(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("==> DAO: findNewestProductsPaged trả về " + list.size() + " sản phẩm.");
        return list;
    }
    public int countAllProducts() {
        String sql = "SELECT COUNT(*) FROM SanPham";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public DanhMuc findDanhMucById(int id) {
        String sql = "SELECT * FROM DanhMuc WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                DanhMuc dm = new DanhMuc();
                dm.setId(rs.getInt("id"));
                dm.setTenDanhMuc(rs.getString("tenDanhMuc"));
                return dm;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<SanPham> findByCategory(int categoryId) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham WHERE idDanhMuc = ? ORDER BY ngayTao DESC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResult(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<SanPham> findByCategoryOrderByPriceAsc(int categoryId) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham WHERE idDanhMuc = ? ORDER BY gia ASC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResult(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<SanPham> findByCategoryOrderByPriceDesc(int categoryId) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham WHERE idDanhMuc = ? ORDER BY gia DESC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResult(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
