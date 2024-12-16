package com.example.workus.archive.view;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.View;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

@Component
public class FileDownloadView implements View {

    @Override
    public void render(Map<String, ?> model, HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String directory = (String) model.get("directory");
        String filename = (String) model.get("filename");
        String originalFilename = (String) model.get("originalFilename");

        File file = new File(new File(directory), filename);
        originalFilename = URLEncoder.encode(originalFilename, "utf-8");

        // 응답컨텐츠의 타입을 설정한다.
        // application/octet-stream은 "바이너리 데이터"의 기본 컨텐츠타입이다.
        response.setContentType("appliction/octet-stream");
        // 응답메세지의 응답헤더정보를 설정한다.
        response.setHeader("Content-Disposition",
                "attachment; filename=" + originalFilename);

        // 서버에 저장된 첨부파일을 읽어오는 스트림 생성
        FileInputStream in = new FileInputStream(file);
        // 브라우저로 내보내는 스트림 획득
        OutputStream out = response.getOutputStream();

        FileCopyUtils.copy(in, out);
    }
}
