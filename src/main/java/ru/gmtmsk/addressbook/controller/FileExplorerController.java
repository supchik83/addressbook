package ru.gmtmsk.addressbook.controller;

import io.minio.GetObjectArgs;
import io.minio.MinioClient;
import io.minio.StatObjectArgs;
import io.minio.StatObjectResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import ru.gmtmsk.addressbook.service.MinioService;

import java.io.InputStream;
import java.net.URLEncoder;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class FileExplorerController {

    private final MinioService minioService;

    public FileExplorerController(MinioService minioService) {
        this.minioService = minioService;
    }

    @Autowired
    private MinioClient minioClient;

    @GetMapping("/lna")
    public String lna_docs(
            @RequestParam(defaultValue = "lna") String bucket,
            @RequestParam(defaultValue = "") String path,
            @RequestParam(required = false) String search,
            Model model) {

        if (search != null && !search.isEmpty()) {
            // Если есть поисковый запрос
            model.addAttribute("files", minioService.searchFiles(bucket, path, search));
            model.addAttribute("searchMode", true);
        } else {
            // Обычный режим просмотра
            List<MinioService.FileItem> allItems = minioService.listObjects(bucket, path);
            List<MinioService.FileItem> directories = allItems.stream()
                    .filter(MinioService.FileItem::isDirectory)
                    .collect(Collectors.toList());
            List<MinioService.FileItem> files = allItems.stream()
                    .filter(item -> !item.isDirectory())
                    .collect(Collectors.toList());

            model.addAttribute("directories", directories);
            model.addAttribute("files", files);
            model.addAttribute("searchMode", false);
        }

        model.addAttribute("bucket", bucket);
        model.addAttribute("currentPath", path);
        model.addAttribute("searchQuery", search != null ? search : "");

        return "lna";
    }

    @GetMapping("/templates_new")
    public String temp_docs(
            @RequestParam(defaultValue = "tamplates-new") String bucket,
            @RequestParam(defaultValue = "") String path,
            @RequestParam(required = false) String search,
            Model model) {

        if (search != null && !search.isEmpty()) {
            // Если есть поисковый запрос
            model.addAttribute("files", minioService.searchFiles(bucket, path, search));
            model.addAttribute("searchMode", true);
        } else {
            // Обычный режим просмотра
            List<MinioService.FileItem> allItems = minioService.listObjects(bucket, path);
            List<MinioService.FileItem> directories = allItems.stream()
                    .filter(MinioService.FileItem::isDirectory)
                    .collect(Collectors.toList());
            List<MinioService.FileItem> files = allItems.stream()
                    .filter(item -> !item.isDirectory())
                    .collect(Collectors.toList());

            model.addAttribute("directories", directories);
            model.addAttribute("files", files);
            model.addAttribute("searchMode", false);
        }

        model.addAttribute("bucket", bucket);
        model.addAttribute("currentPath", path);
        model.addAttribute("searchQuery", search != null ? search : "");

        return "tamplates-new";
    }

    @GetMapping("/download")
    public ResponseEntity<InputStreamResource> downloadFile(
            @RequestParam String bucket,
            @RequestParam String path) {

        try {
            // Получаем объект из MinIO
            StatObjectResponse stat = minioClient.statObject(
                    StatObjectArgs.builder()
                            .bucket(bucket)
                            .object(path)
                            .build());

            // Получаем поток файла
            InputStream fileStream = minioClient.getObject(
                    GetObjectArgs.builder()
                            .bucket(bucket)
                            .object(path)
                            .build());

            // Определяем имя файла с расширением
            String filename =  URLEncoder.encode(path.substring(path.lastIndexOf("/") + 1), "UTF-8");

            // Создаем заголовки для скачивания
            HttpHeaders headers = new HttpHeaders();
            headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"");
            headers.add(HttpHeaders.CACHE_CONTROL, "no-cache, no-store, must-revalidate");
            headers.add(HttpHeaders.PRAGMA, "no-cache");
            headers.add(HttpHeaders.EXPIRES, "0");
            headers.add(HttpHeaders.CONTENT_TYPE, stat.contentType());

            return ResponseEntity.ok()
                    .headers(headers)
                    .contentLength(stat.size())
                    .body(new InputStreamResource(fileStream));
        } catch (Exception e) {
            throw new RuntimeException("Error downloading file", e);
        }
    }

}
