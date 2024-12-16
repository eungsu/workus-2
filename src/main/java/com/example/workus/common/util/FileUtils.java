package com.example.workus.common.util;

import java.io.File;
import java.io.IOException;

import org.springframework.web.multipart.MultipartFile;

import com.example.workus.common.exception.WorkusException;

public class FileUtils {

    /**
     * 첨부파일과 디렉토리 경로를 전달받아서 파일을 저장하고, 파일명을 반환한다.
     * @param multipartFile 첨부파일
     * @param directory 디렉토리
     * @return 파일명
     */
    public static String saveMultipartFile(
            MultipartFile multipartFile,
            String directory) {
        String filename = multipartFile.getOriginalFilename();
        saveMultipartFile(multipartFile, directory, filename);

        return filename;
    }

    /**
     * 첨부파일, 디렉토리 경로, 저장할 파일명을 전달받아서 파일을 저장한다.
     * @param multipartFile 첨부파일
     * @param directory 디렉토리
     * @param filename 파일
     */
    public static void saveMultipartFile(
            MultipartFile multipartFile,
            String directory,
            String filename) {
        try {
            File dest = new File(new File(directory), filename);
            multipartFile.transferTo(dest);
        } catch (IOException ex) {
            throw new WorkusException("첨부파일 저장에 실패하였습니다.");
        }
    }
}