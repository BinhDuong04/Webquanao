package com.clothingstore.clothingstore.config;

import javax.sql.DataSource;
import java.sql.Connection;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;

@Component
public class DBConnect implements CommandLineRunner {

    @Autowired
    private DataSource dataSource;

    @Override
    public void run(String... args) throws Exception {
        try (Connection conn = dataSource.getConnection()) {
            System.out.println("=== DBConnect: connected to " + conn.getCatalog());
        } catch (Exception e) {
            System.err.println("=== DBConnect: connection failed");
            e.printStackTrace();
        }
    }
}
