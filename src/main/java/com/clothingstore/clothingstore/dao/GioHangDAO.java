package com.clothingstore.clothingstore.dao;

import com.clothingstore.clothingstore.entity.GioHang;
import com.clothingstore.clothingstore.entity.KhachHang;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Repository;

@Repository
@Transactional
public class GioHangDAO {

    @PersistenceContext
    private EntityManager entityManager;

    // Tìm giỏ hàng của khách
    public GioHang findByKhachHang(KhachHang khachHang) {
        try {
            return entityManager.createQuery(
                    "SELECT g FROM GioHang g WHERE g.khachHang = :khachHang", GioHang.class)
                    .setParameter("khachHang", khachHang)
                    .getSingleResult();
        } catch (Exception e) {
            return null; // chưa có giỏ hàng
        }
    }

    // Lưu giỏ hàng mới
    public void save(GioHang gioHang) {
        entityManager.persist(gioHang);
    }

    // Update giỏ hàng
    public void update(GioHang gioHang) {
        entityManager.merge(gioHang);
    }
}
