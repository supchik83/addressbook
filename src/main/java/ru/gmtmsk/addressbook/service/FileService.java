package ru.gmtmsk.addressbook.service;

import io.minio.MinioClient;
import io.minio.PutObjectArgs;
import io.minio.RemoveObjectArgs;
import io.minio.Result;
import io.minio.messages.Item;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Service
public class FileService {

    @Autowired
    private MinioClient minioClient;


    private String bucketName;


    // Метод для загрузки файла
    public void uploadFile(MultipartFile file) {
        try {
            InputStream inputStream = file.getInputStream();
            minioClient.putObject(
                    PutObjectArgs.builder()
                            .bucket(bucketName)
                            .object(file.getOriginalFilename())
                            .stream(inputStream, file.getSize(), -1)
                            .contentType(file.getContentType())
                            .build());
        } catch (Exception e) {
            throw new RuntimeException("Ошибка при загрузке файла", e);
        }
    }

    // Метод для удаления файла
    public void deleteFile(String fileName) {
        try {
            minioClient.removeObject(
                    RemoveObjectArgs.builder()
                            .bucket(bucketName)
                            .object(fileName)
                            .build());
        } catch (Exception e) {
            throw new RuntimeException("Ошибка при удалении файла", e);
        }
    }

    //Дерево файлов из minio
    public List<String> listDocuments(String prefix, String bucketName) throws Exception {
        List<String> documents = new ArrayList<>();
        Iterable<Result<Item>> results = minioClient.listObjects(
                io.minio.ListObjectsArgs.builder()
                        .bucket(bucketName)
                        .prefix(prefix)
                        .recursive(true)
                        .build());

        for (Result<Item> result : results) {
            Item item = result.get();
            documents.add(item.objectName());
        }

        return documents;
    }


}

