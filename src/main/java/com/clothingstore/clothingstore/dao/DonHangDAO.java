package com.clothingstore.clothingstore.dao;

import com.clothingstore.clothingstore.entity.DonHang;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class DonHangDAO {

    @PersistenceContext
    private EntityManager entityManager;

    @Transactional
    public void save(DonHang donHang) {
        entityManager.persist(donHang);
    }

    public DonHang findById(int id) {
        return entityManager.find(DonHang.class, id);
    }

    public List<DonHang> findAll() {
        return entityManager.createQuery("SELECT d FROM DonHang d ORDER BY d.id DESC", DonHang.class).getResultList();
    }

    @Transactional
    public void update(DonHang donHang) {
        entityManager.merge(donHang);
    }
    
    public List<DonHang> findByKhachHang(com.clothingstore.clothingstore.entity.KhachHang khachHang) {
        return entityManager.createQuery(
                "SELECT d FROM DonHang d WHERE d.khachHang = :khachHang ORDER BY d.ngayDat DESC",
                DonHang.class)
                .setParameter("khachHang", khachHang)
                .getResultList();
    }
}
