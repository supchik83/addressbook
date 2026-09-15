package ru.gmtmsk.addressbook.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;
import ru.gmtmsk.addressbook.service.Excel;

import java.io.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;


@Controller
@RequestMapping("/diningroom")
public class DiningRoomController {

    @Autowired
    Excel excel;

    // Храним активные процессы для возможности принудительной остановки
    private final ConcurrentHashMap<String, Process> activeProcesses = new ConcurrentHashMap<>();

    @GetMapping()
    public String menu(Model model) {
        model.addAttribute("menuItems", excel.menu());
        return "dining_room";
    }

    @GetMapping(value = "/live.mjpeg", produces = "multipart/x-mixed-replace;boundary=--frame")
    public ResponseEntity<StreamingResponseBody> mjpegStream() {
        String rtspUrl = "rtsp://admin:1234567890-=Gmt@10.39.1.250:554/ISAPI/Streaming/Channels/102/live";
        String processId = "ffmpeg_" + System.currentTimeMillis();

        StreamingResponseBody stream = out -> {
            AtomicBoolean isActive = new AtomicBoolean(true);

            try {
                Process ffmpeg = new ProcessBuilder(
                        "ffmpeg",
                        "-rtsp_transport", "tcp",
                        "-i", rtspUrl,
                        "-c:v", "mjpeg",
                        "-q:v", "3",
                        "-pix_fmt", "yuvj420p",
                        "-f", "mjpeg",
                        "-update", "1",
                        "-flush_packets", "1",
                        "-t", "300", // Ограничение времени работы до 5 минут
                        "-"
                ).redirectError(ProcessBuilder.Redirect.PIPE)
                        .start();

                activeProcesses.put(processId, ffmpeg);
//                System.out.println("Started FFmpeg process: " + processId);

                // Чтение ошибок FFmpeg в отдельном потоке
                Thread errorReader = new Thread(() -> {
                    try (BufferedReader reader = new BufferedReader(
                            new InputStreamReader(ffmpeg.getErrorStream()))) {
                        String line;
                        while ((line = reader.readLine()) != null && isActive.get()) {
                            System.err.println("FFmpeg [" + processId + "]: " + line);
                        }
                    } catch (IOException e) {
                        if (isActive.get()) {
                            System.err.println("Error reading FFmpeg output: " + e.getMessage());
                        }
                    }
                });
                errorReader.start();

                // Передача данных
                try (InputStream in = ffmpeg.getInputStream()) {
                    byte[] buffer = new byte[128 * 1024]; // Уменьшим размер буфера
                    int bytesRead;
                    while ((bytesRead = in.read(buffer)) != -1 && isActive.get()) {
                        try {
                            String header = "--frame\r\n" +
                                    "Content-Type: image/jpeg\r\n" +
                                    "Content-Length: " + bytesRead + "\r\n\r\n";
                            out.write(header.getBytes());
                            out.write(buffer, 0, bytesRead);
                            out.write("\r\n".getBytes());
                            out.flush();
                        } catch (IOException e) {
                            // Клиент отключился
//                            System.out.println("Client disconnected, stopping stream: " + processId);
                            isActive.set(false);
                            break;
                        }
                    }
                } catch (IOException e) {
                    System.err.println("Stream error: " + e.getMessage());
                } finally {
                    cleanupProcess(processId, ffmpeg, isActive);
                }
            } catch (IOException e) {
                System.err.println("Failed to start FFmpeg: " + e.getMessage());
                activeProcesses.remove(processId);
            }
        };

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType("multipart/x-mixed-replace;boundary=--frame"))
                .header("Cache-Control", "no-cache, no-store, must-revalidate")
                .header("Pragma", "no-cache")
                .header("Expires", "0")
                .body(stream);
    }

    @GetMapping("/stopAllStreams")
    public ResponseEntity<String> stopAllStreams() {
//        System.out.println("Stopping all active streams, count: " + activeProcesses.size());
        int stoppedCount = 0;

        for (String processId : activeProcesses.keySet()) {
            Process ffmpeg = activeProcesses.get(processId);
            if (ffmpeg != null && ffmpeg.isAlive()) {
                ffmpeg.destroy();
                try {
                    // Заменяем waitFor на Thread.sleep
                    Thread.sleep(2000);
                    if (ffmpeg.isAlive()) {
                        ffmpeg.destroyForcibly();
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    ffmpeg.destroyForcibly();
                }
                stoppedCount++;
//                System.out.println("Stopped process: " + processId);
            }
        }
        activeProcesses.clear();

        return ResponseEntity.ok("Stopped " + stoppedCount + " streams");
    }

    private void cleanupProcess(String processId, Process ffmpeg, AtomicBoolean isActive) {
        isActive.set(false);
        activeProcesses.remove(processId);

        if (ffmpeg != null) {
//            System.out.println("Cleaning up FFmpeg process: " + processId);
            ffmpeg.destroy();
            try {
                if (ffmpeg.isAlive()) {
                    Thread.sleep(2000);
                    if (ffmpeg.isAlive()) {
                        ffmpeg.destroyForcibly();
                        System.out.println("Forcefully destroyed FFmpeg process: " + processId);
                    } else {
                        System.out.println("FFmpeg process stopped gracefully: " + processId);
                    }
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                ffmpeg.destroyForcibly();
            }
        }
    }
}
