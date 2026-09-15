package ru.gmtmsk.addressbook.service;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.PathResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import ru.gmtmsk.addressbook.data.Employee;
import ru.gmtmsk.addressbook.data.Product;

import java.io.*;

import java.util.ArrayList;

@Service
public class Excel {

    @Value("${filePath.managerPosition}")
    String managerPositionPath;

    @Value("${filePath.excEmp}")
    String excEmpPath;

    @Value("${filePath.menu}")
    String menuPath;
      public ArrayList <Employee> parseFile(MultipartFile file) {

        ArrayList <Employee> employees = new ArrayList<>();
        try (InputStream fileInputStream = new BufferedInputStream(file.getInputStream())) {
            String name = file.getOriginalFilename();
            Workbook workbook;
            if (name.endsWith(".xlsx")) {
                workbook = new XSSFWorkbook(fileInputStream); // Для .xlsx
            } else if (name.endsWith(".xls")) {
                workbook = new HSSFWorkbook(fileInputStream); // Для .xls
            } else {
                throw new IllegalArgumentException("Неподдерживаемый формат файла");
            }

            Sheet sheet = workbook.getSheetAt(0);
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Employee employee = new Employee();
                Row row = sheet.getRow(i);
                if (row == null) {
                    continue;
                }
                employee.setName(row.getCell(0).toString().trim());
                employee.setTabNumber(row.getCell(1).toString().trim());
                employee.setPosition(row.getCell(2).toString().trim());
                employee.setDepartment(row.getCell(3).toString().trim());
                employee.setReceptionDate(row.getCell(4).toString());
                employee.setBirthday(row.getCell(5).toString());
                employee.setSex(row.getCell(6).toString());
                if (row.getCell(7) != null){
                    employee.setCause(row.getCell(7).toString());
                }
                if (row.getCell(9) != null){
                    employee.setLack(row.getCell(9).toString());
                }

                String[] fio = row.getCell(0).toString().split(" ");
                StringBuilder builder = new StringBuilder(fio[1]);
                String userName = "";
                if (!row.getCell(3).toString().contains("МРП")) {
                    userName = (builder.charAt(0) + "." + fio[0]).toUpperCase();
                } else {
                    userName = (fio[0] + "" + builder.charAt(0)).toUpperCase();
                }

                String login = NameTranslit.cyr2lat(userName).toLowerCase();
                employee.setUsername(login);
                employees.add(employee);

            }
            workbook.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return employees;
    }

    public ArrayList <String> parseExceptions(){
        PathResource resource = new PathResource(excEmpPath);
       ArrayList<String> users = new ArrayList<>();
        try {
            InputStream fileInputStream = resource.getInputStream();
            Workbook workbook;
            workbook = new XSSFWorkbook(fileInputStream);
            Sheet sheet = workbook.getSheetAt(0);
            for (int i = 0; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) {
                    continue;
                }
                users.add(row.getCell(0).toString());
            }
            workbook.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        return users;
    }

    public ArrayList <String> parseManagerPosition(){
        PathResource resource = new PathResource(managerPositionPath);
        ArrayList<String> position = new ArrayList<>();
        try {
            InputStream fileInputStream = resource.getInputStream();
            Workbook workbook;
            workbook = new XSSFWorkbook(fileInputStream);
            Sheet sheet = workbook.getSheetAt(0);
            for (int i = 0; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) {
                    continue;
                }
                position.add(row.getCell(0).toString());
            }
            workbook.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return position;
    }

    public ArrayList<Product> menu() {
        PathResource resource = new PathResource(menuPath);
        InputStream inputStream = null;
        try {
            inputStream = resource.getInputStream();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        Workbook workbook = null;
        try {
            workbook = new XSSFWorkbook(inputStream);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        Sheet sheet = workbook.getSheetAt(0);
        ArrayList<Product> products = new ArrayList<>();

        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);

            // Проверка на пустую строку
            if (row == null || isRowEmpty(row)) {
                continue;
            }

            // Проверка обязательных полей
            Cell titleCell = row.getCell(2);
            Cell priceCell = row.getCell(4);

            if (titleCell == null || priceCell == null ||
                    titleCell.toString().trim().isEmpty() ||
                    priceCell.toString().trim().isEmpty()) {
                continue; // Пропускаем строки без названия или цены
            }

            Product product = new Product();

            // Обработка с проверкой на null для каждого поля
            product.setView(getCellValue(row.getCell(0)));
            product.setCategory(getCellValue(row.getCell(1)));
            product.setTitle(getCellValue(titleCell));
            product.setQuantity(getCellValue(row.getCell(3)));
            product.setPrice(getCellValue(priceCell));

            products.add(product);
        }

        return products;
    }

    // Метод для безопасного получения значения ячейки
    private String getCellValue(Cell cell) {
        if (cell == null) {
            return "";
        }

        // Учитываем разные типы ячеек
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getDateCellValue().toString();
                } else {
                    // Форматируем числовое значение без лишних нулей
                    double num = cell.getNumericCellValue();
                    if (num == (int) num) {
                        return String.valueOf((int) num);
                    } else {
                        return String.valueOf(num);
                    }
                }
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                return cell.getCellFormula();
            default:
                return "";
        }
    }

    // Метод для проверки, является ли строка полностью пустой
    private boolean isRowEmpty(Row row) {
        if (row == null) {
            return true;
        }

        boolean isEmpty = true;
        for (int i = 0; i < row.getLastCellNum(); i++) {
            Cell cell = row.getCell(i);
            if (cell != null && cell.getCellType() != CellType.BLANK) {
                String value = getCellValue(cell);
                if (!value.isEmpty()) {
                    isEmpty = false;
                    break;
                }
            }
        }
        return isEmpty;
    }
}
