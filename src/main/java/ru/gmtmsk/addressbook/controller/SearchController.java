package ru.gmtmsk.addressbook.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ru.gmtmsk.addressbook.service.MinioService;

import java.util.List;

@RestController
@RequestMapping("/api")
public class SearchController {

    @Autowired
    MinioService minioService;

    @GetMapping("/search")
    public ResponseEntity<List<MinioService.FileItem>> searchFiles(
            @RequestParam String bucket,
            @RequestParam String path,
            @RequestParam String query) {

        List<MinioService.FileItem> results = minioService.searchFiles(bucket, path, query);
        return ResponseEntity.ok(results);
    }
}