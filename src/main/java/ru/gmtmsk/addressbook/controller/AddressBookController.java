package ru.gmtmsk.addressbook.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import ru.gmtmsk.addressbook.config.Ldap;
import ru.gmtmsk.addressbook.data.Employee;
import ru.gmtmsk.addressbook.service.FindEmployees;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.stream.Collectors;


@Controller
@EnableScheduling
public class AddressBookController {

    @Autowired
    private Ldap ldap;

    @Autowired
    FindEmployees findEmployees;

    private ArrayList<Employee> employees;

    @GetMapping("/")
    public String addressBook(Model model) {
        employees = ldap.LoadEmployeesAD();

        Comparator<Employee> compareByName = Comparator.comparing(Employee::getName);
        ArrayList<Employee> sortEmployees = employees.stream().sorted(compareByName).collect(Collectors.toCollection(ArrayList::new));

        model.addAttribute("employees", sortEmployees);

        return "addressbook";
    }

    @GetMapping("{id}")
    public String openEmployeeInfo(@PathVariable String id, Model model) {
        int id1 = Integer.parseInt(id.replaceAll("[^0-9]", ""));
        Employee emp = new Employee();

        if(employees.stream().anyMatch(item -> id1 == item.getId())){
            emp = employees.get(id1);
        }
        model.addAttribute("user", emp);
        model.addAttribute("workers", findEmployees.findWorkers(emp.getName(), employees));
        return "employeeinfo";
    }

    @GetMapping("/new_employee")
    public String newEmployee(Model model) {
        if (employees == null){
            employees = ldap.LoadEmployeesAD();
        }
        Comparator<Employee> compareByReceptionDate = Comparator.comparing(Employee::getReceptionDate);
        ArrayList<Employee> sortEmployees = employees.stream().sorted(compareByReceptionDate).collect(Collectors.toCollection(ArrayList::new));

        model.addAttribute("newemployees", findEmployees.findReceptionDate(sortEmployees));
        return "newemployee";
    }

    @GetMapping("/birthday")
    public String birthday(Model model) {
        if (employees == null){
            employees = ldap.LoadEmployeesAD();
        }
        Comparator<Employee> compareByName = Comparator.comparing(Employee::getName);
        ArrayList<Employee> sortEmployeesN = employees.stream().sorted(compareByName).collect(Collectors.toCollection(ArrayList::new));

        Comparator<Employee> compareByBirthday = Comparator.comparing(Employee::getBirthday);
        ArrayList<Employee> sortEmployeesB = employees.stream().sorted(compareByBirthday).collect(Collectors.toCollection(ArrayList::new));

        model.addAttribute("celebrants", findEmployees.findBirthday(sortEmployeesN));
        model.addAttribute("celebrantsM", findEmployees.findBirthdayMonth(sortEmployeesB));
        return "birthday";
    }

    @GetMapping("/kiosk")
    public String kiosk(Model model) {
        if (employees == null) {
            employees = ldap.LoadEmployeesAD();
        }
        Comparator<Employee> compareByName = Comparator.comparing(Employee::getName);
        ArrayList<Employee> sortEmployees = employees.stream()
                .filter(emp -> emp.getInnerPhone() != null && !emp.getInnerPhone().trim().isEmpty())
                .filter(emp -> !"Техник МРП".equalsIgnoreCase(emp.getPosition() == null ? "" : emp.getPosition().trim()))
                .sorted(compareByName)
                .collect(Collectors.toCollection(ArrayList::new));

        model.addAttribute("employees", sortEmployees);

        return "kiosk";
    }

    @GetMapping("/absent_employees")
    public String absentManagers(Model model) {
        if (employees == null){
            employees = ldap.LoadEmployeesAD();
        }
        Comparator<Employee> compareByName = Comparator.comparing(Employee::getName);
        ArrayList<Employee> sortEmployees = employees.stream().sorted(compareByName).collect(Collectors.toCollection(ArrayList::new));

        model.addAttribute("managers", findEmployees.findLackManager(sortEmployees, true));
        model.addAttribute("employees", findEmployees.findLackManager(sortEmployees, false));
        return "absent_employees";
    }
}
