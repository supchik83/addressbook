package ru.gmtmsk.addressbook.controller;

import io.minio.*;
import io.minio.errors.*;
import io.minio.messages.Item;
import org.etsi.uri.x01903.v13.SignerRoleType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import ru.gmtmsk.addressbook.config.Ldap;
import ru.gmtmsk.addressbook.data.Employee;
import ru.gmtmsk.addressbook.service.FileService;

import java.io.IOException;
import java.io.InputStream;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;



@Controller
public class DocumentsController {

    @Autowired
    MinioClient minioClient;

    @Autowired
    Ldap ldap;

    @Autowired
    FileService fileService;

    ArrayList<Employee> employees;


    @GetMapping("/templates")
    public String templates(Model model) throws ServerException, InsufficientDataException, ErrorResponseException, IOException, NoSuchAlgorithmException, InvalidKeyException, InvalidResponseException, XmlParserException, InternalException {
        ArrayList<String> docs = new ArrayList<>();
        Iterable<Result<Item>> objectsList = minioClient.listObjects(
                ListObjectsArgs.builder()
                        .bucket("templates")
                        .build());
        for (Result<Item> result : objectsList) {
            Item item = result.get();
            docs.add(item.objectName());
        }

        model.addAttribute("docs", docs);
        return "templates";
    }

    @GetMapping("/tech")
    public String techDocs(Model model) throws ServerException, InsufficientDataException, ErrorResponseException, IOException, NoSuchAlgorithmException, InvalidKeyException, InvalidResponseException, XmlParserException, InternalException {
        ArrayList<String> docs = new ArrayList<>();
        Iterable<Result<Item>> objectsList = minioClient.listObjects(
                ListObjectsArgs.builder()
                        .bucket("tech-docs")
                        .build());
        for (Result<Item> result : objectsList) {
            Item item = result.get();
            docs.add(item.objectName());
        }

        model.addAttribute("docs", docs);
        return "instructions";
    }


    @GetMapping("/for-new-emp")
    public String docsForEmp(Model model) throws ServerException, InsufficientDataException, ErrorResponseException, IOException, NoSuchAlgorithmException, InvalidKeyException, InvalidResponseException, XmlParserException, InternalException {
        if (employees == null){
            employees = ldap.LoadEmployeesAD();
        }
        ArrayList<String> docs = new ArrayList<>();
        Iterable<Result<Item>> objectsList = minioClient.listObjects(
                ListObjectsArgs.builder()
                        .bucket("docs-for-emp")
                        .build());
        for (Result<Item> result : objectsList) {
            Item item = result.get();
            docs.add(item.objectName());
        }

        model.addAttribute("docs", docs);
        return "fornewemp";
    }

    @GetMapping("/templates/{objectName}")
    public ResponseEntity<InputStreamResource> downloadTemplates(@PathVariable String objectName) {
        try {
            InputStream stream = getInputStream("templates", objectName);
            HttpHeaders headers = new HttpHeaders();
            headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment");
            headers.add(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_OCTET_STREAM_VALUE);

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(new InputStreamResource(stream));
        } catch (MinioException e) {
            throw new RuntimeException("Ошибка при загрузке файла из хранилища", e);
        } catch (Exception e) {
            throw new RuntimeException("Неожиданная ошибка", e);
        }
    }

    @GetMapping("/tech/{objectName}")
    public ResponseEntity<InputStreamResource> downloadTechDocs(@PathVariable String objectName) {
        try {
            InputStream stream = getInputStream("tech-docs", objectName);
            HttpHeaders headers = new HttpHeaders();
            headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment");
            headers.add(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_OCTET_STREAM_VALUE);

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(new InputStreamResource(stream));
        } catch (MinioException e) {
            throw new RuntimeException("Ошибка при загрузке файла из хранилища", e);
        } catch (Exception e) {
            throw new RuntimeException("Неожиданная ошибка", e);
        }
    }

    @GetMapping("/for-new-emp/{objectName}")
    public ResponseEntity<InputStreamResource> downloadFileN(@PathVariable String objectName) {
        try {
            InputStream stream = getInputStream("docs-for-emp", objectName);
            HttpHeaders headers = new HttpHeaders();
            headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment");
            headers.add(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_OCTET_STREAM_VALUE);

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(new InputStreamResource(stream));
        } catch (MinioException e) {
            throw new RuntimeException("Ошибка при загрузке файла из хранилища", e);
        } catch (Exception e) {
            throw new RuntimeException("Неожиданная ошибка", e);
        }
    }


    private InputStream getInputStream(String bucket, String objectName) throws ErrorResponseException, InsufficientDataException, InternalException, InvalidKeyException, InvalidResponseException, IOException, NoSuchAlgorithmException, ServerException, XmlParserException {
        InputStream stream = minioClient.getObject(
                GetObjectArgs.builder()
                        .bucket(bucket)
                        .object(objectName)
                        .build());
        return stream;
    }

}
