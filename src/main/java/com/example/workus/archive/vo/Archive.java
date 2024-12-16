package com.example.workus.archive.vo;

import com.example.workus.user.vo.User;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Alias("Archive")
public class Archive {

    private Long no; // ARCHIVE_NO
    private Date uploadTime; // ARCHIVE_UPLOAD_TIME
    private String originalName; // ARCHIVE_ORIGINAL_NAME
    private String savedFileName; // ARCHIVE_MODIFIED_NAME
    private Long fileSize; // ARCHIVE_FILE_SIZE
    private String fileExtension; // ARCHIVE_FILE_EXTENSION
    private char fileStatus; // ARCHIVE_FILE_STATUS
    private char division; // ARCHIVE_DIVISION
    private User user; // USER_NO
    private Long deptNo; // DEPT_NO
    private String archiveCol; // WORKUS_ARCHIVEcol
    private String userName;


}
