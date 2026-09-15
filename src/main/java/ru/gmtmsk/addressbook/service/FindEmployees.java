package ru.gmtmsk.addressbook.service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.gmtmsk.addressbook.data.Employee;


import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import java.util.ArrayList;

@Service
public class FindEmployees {

    @Autowired
    Excel excel;
   //Поиск подчиненных
    public ArrayList<Employee> findWorkers (String name, ArrayList<Employee> searchList){
        ArrayList<Employee> findedList = new ArrayList();
        for(Employee e : searchList){
            if(e.getManager().equals(name)){
                findedList.add(e);
            }
        }
        return findedList;
    }

    //Поиск сотрудников по подразделению
    public ArrayList<Employee> findDepartment(String department, ArrayList<Employee> searchList){
        ArrayList<Employee> findedList = new ArrayList();
        for(Employee e : searchList){
            if(e.getDepartment().equals(department)){
                findedList.add(e);
            }
        }
        return findedList;
    }

    //Поиск дней рождений сегодня
    public ArrayList<Employee> findBirthday(ArrayList<Employee> searchList){
        LocalDate currentDate = LocalDate.now();
        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd.MM");;
        String strDate = dateTimeFormatter.format(currentDate);
        ArrayList<Employee> findedList = new ArrayList<>();
        for(Employee e : searchList){
            if (e.getBirthday().contains(strDate)){
                findedList.add(e);
            }
        }
        return findedList;
    }
    //Поиск дней рождений в текущем месяце
    public ArrayList<Employee> findBirthdayMonth(ArrayList<Employee> searchList){
        LocalDate currentDate = LocalDate.now();
        DateTimeFormatter onlyMonth = DateTimeFormatter.ofPattern("MM");;
        DateTimeFormatter dayMonth = DateTimeFormatter.ofPattern("dd");;
        String strOnlyMonth = onlyMonth.format(currentDate);
        String strDayMonth = dayMonth.format(currentDate);
        ArrayList<Employee> findedList = new ArrayList<>();
        for(Employee e : searchList){
            String m = e.getBirthday();
            if (!m.equals("")){
                String[] birthday = m.split("\\.");
                String month = birthday[1];
                String day = birthday[0];
                if (month.equals(strOnlyMonth) && Integer.parseInt(day) > Integer.parseInt(strDayMonth)){
                    findedList.add(e);
                }
            }
        }
        return findedList;
    }

    //Поиск новых сотрудников
    public ArrayList<Employee> findReceptionDate(ArrayList<Employee> searchList){
        LocalDate currentDate = LocalDate.now();
        LocalDate startDate = currentDate.minusDays(7);
        LocalDate endDate = currentDate.plusDays(7);
        ArrayList<Employee> findedList = new ArrayList<>();
        for(Employee e : searchList){
            String m = e.getReceptionDate();
            if (!m.equals("")){
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
                LocalDate receptionDate = LocalDate.parse(m, formatter);
                if (receptionDate.isAfter(startDate) && receptionDate.isBefore(endDate)){
                    findedList.add(e);
                }
            }
        }
    return findedList;
    }

    //Поиск отсутствующих руководителей
    public ArrayList<Employee> findLackManager (ArrayList<Employee> searchList, boolean manager){
        LocalDate currentDate = LocalDate.now();
        ArrayList<Employee> findedList = new ArrayList<>();
        for(Employee e : searchList){
            String m = e.getLack();
            if (!m.equals("")){
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
                LocalDate lackDate = LocalDate.parse(m, formatter).plusDays(1);
                if (currentDate.isBefore(lackDate)){
                    if (isManager(e.getPosition()) && manager){
                        findedList.add(e);
                    } else if (!manager && !e.getCause().equals("Отпуск по беременности и родам")){
                        findedList.add(e);
                    }
                }
            }
        }
        return findedList;
    }


    public Boolean findUserName(ArrayList<Employee> searchUser, String userName){
        for (Employee e: searchUser){
            if (userName.equals(e.getUsername()))
                return false;
        }
        return true;
    }

    public boolean isManager(String position){
        ArrayList<String> manager = excel.parseManagerPosition();
        for (String s : manager) {
            if (position.equals(s)) {
                return true;
            }
        }
        return false;
    }

    public boolean isException(String name){
        ArrayList<String> exc = excel.parseExceptions();
        for (String s : exc) {
            if (name.equals(s)) {
                return true;
            }
        }
        return false;
    }

}
