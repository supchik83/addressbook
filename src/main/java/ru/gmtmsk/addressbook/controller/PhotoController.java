package ru.gmtmsk.addressbook.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import ru.gmtmsk.addressbook.config.Ldap;
import ru.gmtmsk.addressbook.data.Employee;

import java.util.ArrayList;
import java.util.Base64;


@RestController
public class PhotoController {

    @Autowired
    private Ldap ldap;

    // Заглушка на случай отсутствия фото у сотрудника
    private static final byte[] NO_PHOTO = new byte[0];

    @GetMapping(value = "/photo/{id}", produces = MediaType.IMAGE_JPEG_VALUE)
    public ResponseEntity<byte[]> getPhoto(@PathVariable String id) {
        int index;
        try {
            index = Integer.parseInt(id.replaceAll("[^0-9]", ""));
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().build();
        }

        ArrayList<Employee> employees = ldap.LoadEmployeesAD();

        if (index < 0 || index >= employees.size()) {
            return ResponseEntity.notFound().build();
        }

        Employee emp = employees.get(index);
        String base64Photo = emp.getPhoto();

        if (base64Photo == null || base64Photo.isEmpty()) {
            return ResponseEntity.ok().body(NO_PHOTO);
        }

        byte[] photoBytes;
        try {
            photoBytes = Base64.getDecoder().decode(base64Photo);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.internalServerError().build();
        }

        return ResponseEntity.ok().body(photoBytes);
    }
}