package com.clothingstore.clothingstore;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.IOException;

@SpringBootApplication
public class ClothingstoreApplication {

    public static void main(String[] args) {
        SpringApplication.run(ClothingstoreApplication.class, args);

        // Tự động mở trình duyệt
        openHomePage("http://localhost:8081/customer/home");
    }

    private static void openHomePage(String url) {
        try {
            String os = System.getProperty("os.name").toLowerCase();

            if (os.contains("win")) {
                // Windows
                Runtime.getRuntime().exec("rundll32 url.dll,FileProtocolHandler " + url);
            } else if (os.contains("mac")) {
                // MacOS
                Runtime.getRuntime().exec("open " + url);
            } else if (os.contains("nix") || os.contains("nux") || os.contains("aix")) {
                // Linux/Unix
                Runtime.getRuntime().exec("xdg-open " + url);
            } else {
                System.out.println("Hệ điều hành không hỗ trợ tự động mở trình duyệt.");
            }

            System.out.println("Đã cố gắng mở trình duyệt: " + url);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
