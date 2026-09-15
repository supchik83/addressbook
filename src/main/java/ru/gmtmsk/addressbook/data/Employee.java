package ru.gmtmsk.addressbook.data;

import org.springframework.stereotype.Component;

import java.util.Objects;

@Component
public class Employee {

    private int id;
    private String tabnumber;
    private String name;
    private String username;
    private  String DN;
    private String position;
    private String department;
    private String office;
    private String email;
    private String phone;
    private String innerPhone;
    private String manager;
    private String photo;
    private String birthday;
    private String receptionDate;
    private String lack;
    private String cause;
    private String sex;
    private String example;

    public String getBirthday() {
        return birthday;
    }

    public String getDN() { return DN; }

    public void setDN(String DN) { this.DN = DN; }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public String getReceptionDate() {
        return receptionDate;
    }

    public void setReceptionDate(String receptionDate) {
        this.receptionDate = receptionDate;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTabNumber() { return tabnumber; }

    public void setTabNumber(String tabnumber) { this.tabnumber = tabnumber; }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getOffice() {
        return office;
    }

    public void setOffice(String office) {
        this.office = office;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getInnerPhone() {
        return innerPhone;
    }

    public void setInnerPhone(String innerPhone) {
        this.innerPhone = innerPhone;
    }

    public String getManager() {
        return manager;
    }

    public void setManager(String manager) {
        this.manager = manager;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getLack() {
        return lack;
    }

    public void setLack(String lack) {
        this.lack = lack;
    }

    public String getCause() {
        return cause;
    }

    public void setCause(String cause) {
        this.cause = cause;
    }

    public String getSex() { return sex; }

    public void setSex(String sex) { this.sex = sex; }

    public String getExample() { return example; }

    public void setExample(String example) { this.example = example; }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Employee employee = (Employee) o;
        return Objects.equals(tabnumber, employee.tabnumber) &&
                Objects.equals(name, employee.name) &&
                Objects.equals(position, employee.position) &&
                Objects.equals(department, employee.department);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, tabnumber, position, department);
    }
}
