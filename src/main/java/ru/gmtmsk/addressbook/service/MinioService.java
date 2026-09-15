package ru.gmtmsk.addressbook.service;

import io.minio.ListObjectsArgs;
import io.minio.MinioClient;
import io.minio.Result;
import io.minio.messages.Item;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service

public class MinioService {
    private final MinioClient minioClient;

    public MinioService(MinioClient minioClient) {
        this.minioClient = minioClient;
    }

    public List<FileItem> listObjects(String bucketName, String prefix) {
        List<FileItem> items = new ArrayList<>();

        try {
            Iterable<Result<Item>> results = minioClient.listObjects(
                    ListObjectsArgs.builder()
                            .bucket(bucketName)
                            .prefix(prefix)
                            .recursive(false)
                            .build());

            for (Result<Item> result : results) {
                Item item = result.get();
                items.add(new FileItem(
                        item.objectName(),
                        item.isDir(),
                        item.size(),
                        getFileExtension(item.objectName())
                ));
            }
        } catch (Exception e) {
            throw new RuntimeException("Error listing objects", e);
        }

        return items;
    }

    public List<FileItem> searchFiles(String bucketName, String basePath, String query) {
        List<FileItem> results = new ArrayList<>();
        String searchPath = basePath.isEmpty() ? "" : basePath.endsWith("/") ? basePath : basePath + "/";

        try {
            Iterable<Result<Item>> objects = minioClient.listObjects(
                    ListObjectsArgs.builder()
                            .bucket(bucketName)
                            .prefix(searchPath)
                            .recursive(true)
                            .build());

            for (Result<Item> result : objects) {
                Item item = result.get();
                String filename = item.objectName().substring(item.objectName().lastIndexOf("/") + 1);

                if (filename.toLowerCase().contains(query.toLowerCase())) {
                    results.add(new FileItem(
                            item.objectName(),
                            item.isDir(),
                            item.size(),
                            getFileExtension(item.objectName())
                    ));

                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error searching files", e);
        }

        return results;
    }

    private String getFileExtension(String filename) {
        if (filename.contains(".")) {
            return filename.substring(filename.lastIndexOf(".") + 1).toLowerCase();
        }
        return "";
    }


    public static class FileItem {
        private String path;
        private boolean isDirectory;
        private long size;
        private String extension;

        public FileItem(String path, boolean isDirectory, long size, String extension) {
            this.path = path;
            this.isDirectory = isDirectory;
            this.size = size;
            this.extension = extension;
        }

        public String getPath() {
            return path;
        }

        public void setPath(String path) {
            this.path = path;
        }

        public boolean isDirectory() {
            return isDirectory;
        }

        public void setDirectory(boolean directory) {
            isDirectory = directory;
        }

        public long getSize() {
            return size;
        }

        public void setSize(long size) {
            this.size = size;
        }

        public String getExtension() {
            return extension;
        }

        public void setExtension(String extension) {
            this.extension = extension;
        }

        public String getName() {
            return path.substring(path.lastIndexOf("/") + 1);
        }
    }




}
