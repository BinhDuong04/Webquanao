package com.clothingstore.clothingstore.dao;

import com.clothingstore.clothingstore.entity.ChiTietGioHang;
import com.clothingstore.clothingstore.entity.ChiTietGioHangId;
import com.clothingstore.clothingstore.entity.GioHang;
import com.clothingstore.clothingstore.entity.SanPham;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Transactional
public class ChiTietGioHangDAO {

    @PersistenceContext
    private EntityManager entityManager;

    // Lấy danh sách sản phẩm trong giỏ
    public List<ChiTietGioHang> findByGioHang(GioHang gioHang) {
        return entityManager.createQuery(
                "SELECT c FROM ChiTietGioHang c WHERE c.gioHang = :gioHang", ChiTietGioHang.class)
                .setParameter("gioHang", gioHang)
                .getResultList();
    }

    // Tìm 1 sp trong giỏ
    public ChiTietGioHang findById(GioHang gioHang, SanPham sanPham) {
        return entityManager.find(ChiTietGioHang.class, new ChiTietGioHangId(gioHang.getId(), sanPham.getId()));
    }

    // Thêm mới
    public void save(ChiTietGioHang ct) {
        entityManager.persist(ct);
    }

    // Update
    public void update(ChiTietGioHang ct) {
        entityManager.merge(ct);
    }

    // Xoá
    public void delete(ChiTietGioHang ct) {
        entityManager.remove(entityManager.contains(ct) ? ct : entityManager.merge(ct));
    }

    // Xoá toàn bộ giỏ hàng (khi đặt hàng xong)
    public void deleteAllByGioHang(GioHang gioHang) {
        List<ChiTietGioHang> list = findByGioHang(gioHang);
        for (ChiTietGioHang ct : list) {
            delete(ct);
        }
    }
}
