package com.clothingstore.clothingstore.dao;

import com.clothingstore.clothingstore.entity.ChiTietSanPham;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Transactional
public class ChiTietSanPhamDAO {

    @PersistenceContext
    private EntityManager entityManager;

    public List<ChiTietSanPham> findBySanPhamId(int idSanPham) {
        return entityManager.createQuery("SELECT c FROM ChiTietSanPham c WHERE c.idSanPham = :idSanPham", ChiTietSanPham.class)
                .setParameter("idSanPham", idSanPham)
                .getResultList();
    }

    public void save(ChiTietSanPham ctsp) {
        entityManager.persist(ctsp);
    }

    public void update(ChiTietSanPham ctsp) {
        entityManager.merge(ctsp);
    }

    public void delete(int id) {
        ChiTietSanPham ctsp = entityManager.find(ChiTietSanPham.class, id);
        if (ctsp != null) {
            entityManager.remove(ctsp);
        }
    }
    
}
