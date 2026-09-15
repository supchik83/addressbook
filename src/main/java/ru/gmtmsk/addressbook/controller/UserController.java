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

    String message = "";

    private HashMap<Employee, ArrayList<Employee>> users;

    @GetMapping("/login")
    public String showLoginPage() {
        return "login-page";
    }

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
        model.addAttribute("firedEmp", employees);
        return "updateusers";
    }

    @PostMapping("/upload2")
    public String getUsersFromExcel2 (@RequestParam("uploadedFile2") MultipartFile file, RedirectAttributes redirectAttributes){
        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "Пожалуйста, выберете файл для загрузки.");
            return "redirect:/updateusers";
        }
        employees = ldap.updateEmployees(excel.parseFile(file));

        return "redirect:updateusers";
    }

    @PostMapping("/fired")
    private String firedEmployee(@RequestParam(value = "fired", required = false) ArrayList<String> usersName){
        if (usersName != null){
            ldap.firedEmployees(usersName);
            message = "Выбранные пользователи перемещены в группу Уволенные;";
        }else {
            message = "Не выбран ниодин пользователь";
        }
        return "redirect:finish";
    }

    //Обновление кабинетов


}
