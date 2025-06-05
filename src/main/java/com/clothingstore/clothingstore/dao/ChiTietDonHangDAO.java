package com.clothingstore.clothingstore.dao;

import com.clothingstore.clothingstore.entity.ChiTietDonHang;
import com.clothingstore.clothingstore.entity.DonHang;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ChiTietDonHangDAO {

    @PersistenceContext
    private EntityManager entityManager;

    @Transactional
    public void save(ChiTietDonHang ct) {
        entityManager.merge(ct);
    }

    public List<ChiTietDonHang> findByDonHang(DonHang donHang) {
        return entityManager.createQuery(
                "SELECT c FROM ChiTietDonHang c WHERE c.donHang = :donHang", ChiTietDonHang.class)
                .setParameter("donHang", donHang)
                .getResultList();
    }
    
}
