package com.example.workus.common.util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class WebContentFileUtils {

	@Value("${webapp.path:src/main/webapp}")
	String webAppPath;

	/**
	 * 웹 컨텐츠 파일을 지정된 디렉토리에 첨부파일의 원래 파일명으로 저장시키고, 원래 파일명을 반환한다.
	 * @param multipartFile 업로드된 파일
	 * @param directory 디렉토리 경로
	 * @return
	 */
	public String saveWebContentFile(MultipartFile multipartFile, String directory) {
		String filename = multipartFile.getOriginalFilename();
		File file = new File(Paths.get(webAppPath, directory).toAbsolutePath().toFile(), filename);
		WebContentFileUtils.saveFile(multipartFile, file);
		
		return filename;
	}

	/**
	 * 웹 컨텐츠 파일을 지정된 디렉토리에 파일명으로 저장시킨다.
	 * @param multipartFile 업로드된 파일
	 * @param directory 디렉토리 경로
	 * @param filename 파일명
	 * @return
	 */
	public void saveWebContentFile(MultipartFile multipartFile, String directory, String filename) {
		File file = new File(Paths.get(webAppPath, directory).toAbsolutePath().toFile(), filename);
		WebContentFileUtils.saveFile(multipartFile, file);
	}
	
	private static void saveFile(MultipartFile multipartFile, File file) {
		try {
			multipartFile.transferTo(file);
		} catch (IOException ex) {
			throw new RuntimeException(ex.getMessage());
		}
	}
}
