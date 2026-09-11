package com.Grp._8.backend.services.files;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.Map;

@Service
public class StorageService {

    @Value("${cloudinary.cloud_name}")
    private String cloudName;

    @Value("${cloudinary.api_key}")
    private String apiKey;

    @Value("${cloudinary.api_secret}")
    private String apiSecret;

    private Cloudinary getCloudinary() {
        return new Cloudinary(Map.of(        // ✓ safe — Cloudinary only reads this
                "cloud_name", cloudName,
                "api_key",    apiKey,
                "api_secret", apiSecret
        ));
    }

    public String upload(byte[] fileBytes, String fileName) throws IOException {
        Map result = getCloudinary().uploader().upload(fileBytes, ObjectUtils.asMap(
                "resource_type", "raw",      // ✗ keep ObjectUtils here — Cloudinary mutates this map internally
                "public_id",     fileName,
                "folder",        "prescriptions"
        ));
        return result.get("secure_url").toString();
    }
}