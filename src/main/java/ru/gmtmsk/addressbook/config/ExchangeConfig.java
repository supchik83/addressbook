package ru.gmtmsk.addressbook.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ExchangeConfig {

    @Value("${exchange.username}")
    private String email;
    @Value("${exchange.password}")
    private String password;
    @Value("${exchange.domain}")
    private String domain;
    @Value("${exchange.serverUrl}")
    private String serverUrl;
    @Value("${exchange.folderName}")
    private String folderName;

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getDomain() { return domain; }
    public void setDomain(String domain) { this.domain = domain; }

    public String getServerUrl() { return serverUrl; }
    public void setServerUrl(String serverUrl) { this.serverUrl = serverUrl; }

    public String getFolderName() { return folderName; }
    public void setFolderName(String folderName) { this.folderName = folderName; }
}
