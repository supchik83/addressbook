package ru.gmtmsk.addressbook.service;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class MenuScheduledTask {

    private static final Logger logger = LoggerFactory.getLogger(MenuScheduledTask.class);

    @Autowired
    private final ExchangeMailService exchangeService;
    @Autowired
    private final SftpService sftpService;

    public MenuScheduledTask(ExchangeMailService exchangeService, SftpService sftpService) {
        this.exchangeService = exchangeService;
        this.sftpService = sftpService;
    }

    @Scheduled(cron = "0 0 7 * * TUE-SAT") // Со вторника по субботу в 7:00
    public void fetchAndUploadMenu() {
        logger.info("Начинаем обработку меню столовой");

        try {
            // Получаем файл из Exchange
            byte[] menuFile = exchangeService.getMenuAttachmentFromToday();

            if (menuFile != null && menuFile.length > 0) {
                logger.info("Файл получен");
                // Загружаем на SFTP сервер
                sftpService.uploadFile(menuFile, "menu.xlsx");

                logger.info("Файл успешно загружен на SFTP сервер");
            } else {
                logger.warn("Файл меню не найден или пуст");
            }

        } catch (Exception e) {
            logger.error("Ошибка при обработке меню столовой", e);
        }
    }

    private String getCurrentDate() {
        return new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
    }
}