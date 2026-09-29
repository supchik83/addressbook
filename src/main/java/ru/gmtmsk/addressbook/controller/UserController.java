package ru.gmtmsk.addressbook.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import ru.gmtmsk.addressbook.config.Ldap;
import ru.gmtmsk.addressbook.data.Employee;
import ru.gmtmsk.addressbook.service.Excel;
import ru.gmtmsk.addressbook.service.FindEmployees;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Controller
//@RequestMapping("/service")
public class UserController {

    @Autowired
    Ldap ldap;

    @Autowired
    Excel excel;

    @Autowired
    FindEmployees findEmployees;

    ArrayList<Employee> employees;

    // Пользователи, не найденные в AD ни по табельному номеру, ни по ФИО (для страницы /updateusers)
    ArrayList<Employee> firedEmp;

    // Лог изменений, сделанных последним обновлением через /upload2 (для страницы /updateusers)
    List<String> changeLog = new ArrayList<>();

    String message = "";

    private HashMap<Employee, ArrayList<Employee>> users;


    @GetMapping("/addusers")
//    @PreAuthorize("hasRole('ADMIN')")
    public String addUserTroughExcel(Model model) {
        if (users != null){
          model.addAttribute("employees", users);
        }
        return "addusers";
    }

    @PostMapping("/upload")
    public String getUsersFromExcel(@RequestParam("uploadedFile") MultipartFile file, RedirectAttributes redirectAttributes){
        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "Пожалуйста, выберете файл для загрузки.");
            return "redirect:/addusers";
        }

        ArrayList <Employee> ldapEmployees = ldap.LoadEmployeesAD();

        users = new HashMap<>();
        for (Employee key: excel.parseFile(file)) {
            ArrayList<Employee> value = findEmployees.findDepartment(key.getDepartment(), ldapEmployees);
            users.put(key, value);
        }
        return "redirect:addusers";
    }

    @PostMapping("/save")
    public String addUsersToLdap(@ModelAttribute("employees") Employee user){
       ArrayList<Employee> arrayList= new ArrayList<>();
       arrayList.add(user);
        message = ldap.addEmployees(arrayList);
        return "redirect:finish";
    }

    @GetMapping("/finish")
    public String finish(Model model){
        model.addAttribute("message", message);
        return "finish";
    }


    @GetMapping("/updateusers")
//    @PreAuthorize("hasRole('ADMIN')")
    public String updateUsersTroughExcel(Model model){
        model.addAttribute("firedEmp", firedEmp);
        model.addAttribute("changeLog", changeLog);
        return "updateusers";
    }

    @PostMapping("/upload2")
    public String getUsersFromExcel2 (@RequestParam("uploadedFile2") MultipartFile file, RedirectAttributes redirectAttributes){
        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "Пожалуйста, выберете файл для загрузки.");
            return "redirect:/updateusers";
        }
        firedEmp = ldap.updateEmployees(excel.parseFile(file));
        changeLog = ldap.getLastUpdateLog();

        redirectAttributes.addFlashAttribute("message", "Данные пользователей обновлены. Изменений: " + changeLog.size());
        return "redirect:updateusers";
    }

    @PostMapping("/fired")
    private String firedEmployee(@RequestParam(value = "fired", required = false) ArrayList<String> usersName, RedirectAttributes redirectAttributes){
        if (usersName != null && !usersName.isEmpty()){
            ldap.firedEmployees(usersName);
            // Убираем уволенных пользователей из списка "не найденных" без повторного обращения к AD
            if (firedEmp != null) {
                firedEmp.removeIf(emp -> usersName.contains(emp.getUsername()));
            }
            redirectAttributes.addFlashAttribute("message", "Выбранные пользователи перемещены в группу Уволенные;");
        }else {
            redirectAttributes.addFlashAttribute("message", "Не выбран ниодин пользователь");
        }
        return "redirect:/updateusers";
    }

    //Обновление кабинетов


}
