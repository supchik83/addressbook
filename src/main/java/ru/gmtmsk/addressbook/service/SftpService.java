package ru.gmtmsk.addressbook.service;

import com.jcraft.jsch.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.gmtmsk.addressbook.config.SftpConfig;

import java.io.ByteArrayInputStream;

@Service
public class SftpService {

    @Autowired
    private final SftpConfig sftpConfig;

    public SftpService(SftpConfig sftpConfig) {
        this.sftpConfig = sftpConfig;
    }

    public void uploadFile(byte[] fileContent, String fileName) throws JSchException, SftpException {
        JSch jsch = new JSch();
        Session session = null;
        ChannelSftp channel = null;

        try {
            // Создаем сессию
            session = jsch.getSession(
                    sftpConfig.getUsername(),
                    sftpConfig.getHost(),
                    sftpConfig.getPort()
            );
            session.setPassword(sftpConfig.getPassword());
            session.setConfig("StrictHostKeyChecking", "no");
            session.connect();

            // Открываем SFTP канал
            channel = (ChannelSftp) session.openChannel("sftp");
            channel.connect();

            // Загружаем файл
            String remoteFilePath = sftpConfig.getRemotePath() + "/" + fileName;
            channel.put(new ByteArrayInputStream(fileContent), remoteFilePath);

        } finally {
            if (channel != null && channel.isConnected()) {
                channel.disconnect();
            }
        }
    }
}