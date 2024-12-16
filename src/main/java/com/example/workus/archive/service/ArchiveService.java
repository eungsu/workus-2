package com.example.workus.archive.service;

import com.example.workus.archive.mapper.ArchiveMapper;
import com.example.workus.archive.vo.Archive;
import com.example.workus.common.dto.DeleteFileData;
import com.example.workus.common.dto.DownloadFileData;
import com.example.workus.common.dto.saveFileForm;
import com.example.workus.common.s3.S3Service;
import com.example.workus.security.LoginUser;
import com.example.workus.user.mapper.UserMapper;
import com.example.workus.user.vo.User;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.services.s3.model.S3Exception;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Date;
import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class ArchiveService {

    @Value("${cloud.aws.s3.bucket}")
    private String bucketName;

    private String folder = "resources/files";

    private final S3Service s3Service;

    @Autowired
    private ArchiveMapper archiveMapper;
    @Autowired
    private UserMapper userMapper;

    public List<Archive> getArchiveList() {
        return archiveMapper.selectArchiveList();
    }

    public void saveFile(saveFileForm form, LoginUser loginUser) {

        MultipartFile saveFile = form.getSaveFile();
        if (saveFile == null || saveFile.isEmpty()) {
            throw new IllegalArgumentException("업로드할 파일이 없습니다.");
        }
        String filename = System.currentTimeMillis() + "_" + saveFile.getOriginalFilename();

        try {
        s3Service.uploadFile(saveFile, bucketName, folder, filename);

        Archive archive = new Archive();
        archive.setUploadTime(new Date());
        archive.setOriginalName(saveFile.getOriginalFilename());
        archive.setSavedFileName(filename);
        archive.setFileSize(saveFile.getSize());
        archive.setFileExtension(saveFile.getOriginalFilename().substring(saveFile.getOriginalFilename().lastIndexOf(".") + 1));
        archive.setFileStatus('A');
        archive.setDivision('P');

        User user = userMapper.getUserByUserNo(loginUser.getNo());
        archive.setUser(user);
        archive.setDeptNo(user.getDeptNo());

        archiveMapper.insertArchive(archive);

        } catch (Exception e) {
            throw new RuntimeException("파일 저장 중 오류가 발생했습니다.", e);
        }
    }

    public DownloadFileData downloadFile(Long no, LoginUser loginUser) {
        Archive archive = archiveMapper.selectArchiveByNo(no);
        if (archive == null) {
            throw new IllegalArgumentException("파일을 찾을 수 없습니다.");
        }

        ByteArrayResource resource = s3Service.downloadFile(bucketName, folder, archive.getSavedFileName());

        try {
            String filename = archive.getOriginalName();
            String encodedFileName = URLEncoder.encode(filename, "UTF-8");

            return new DownloadFileData(encodedFileName, resource);
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("파일 이름 인코딩 실패", e);
        }
    }

    public void deleteFile(Long no, LoginUser loginUser) {
        if (loginUser == null) {
            throw new SecurityException("사용자 정보가 없습니다.");
        }

        Archive archive = archiveMapper.selectArchiveByNo(no);
        if (archive == null) {
            throw new IllegalArgumentException("삭제하려는 파일을 찾을 수 없습니다.");
        }

        // 사용자 권한 확인
        if (!archive.getUser().getNo().equals(loginUser.getNo())) {
            System.out.println("로그인 사용자 번호: " + loginUser.getNo());
            System.out.println("파일 소유자 번호: " + archive.getUser().getNo());
            throw new SecurityException("해당 파일을 삭제할 권한이 없습니다.");
        }

        try {
            // S3에서 파일 삭제
            s3Service.deleteFile(bucketName, folder, archive.getSavedFileName());

            // 데이터베이스에서 파일 정보 삭제
            archiveMapper.deleteArchiveByNo(no);

        } catch (S3Exception e) {
            // S3 관련 예외 처리
            throw new RuntimeException("S3에서 파일 삭제 도중 문제가 발생했습니다: " + e.getMessage(), e);
        } catch (Exception e) {
            // 일반 예외 처리
            throw new RuntimeException("파일 삭제 도중 문제가 발생했습니다. 관리자에게 문의하세요.", e);
        }
    }


}
