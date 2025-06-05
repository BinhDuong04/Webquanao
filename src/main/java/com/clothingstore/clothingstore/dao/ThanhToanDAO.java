package com.clothingstore.clothingstore.dao;

import com.clothingstore.clothingstore.entity.DonHang;
import com.clothingstore.clothingstore.entity.ThanhToan;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Repository;

@Repository
@Transactional
public class ThanhToanDAO {

    @PersistenceContext
    private EntityManager entityManager;

    public void save(ThanhToan thanhToan) {
        entityManager.persist(thanhToan);
    }

    public ThanhToan findByDonHang(DonHang donHang) {
        try {
            return entityManager.createQuery(
                    "SELECT t FROM ThanhToan t WHERE t.donHang = :donHang", ThanhToan.class)
                    .setParameter("donHang", donHang)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    public void update(ThanhToan thanhToan) {
        entityManager.merge(thanhToan);
    }
    
}
