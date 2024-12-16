package com.example.workus.archive.mapper;

import com.example.workus.archive.vo.Archive;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ArchiveMapper {

    void insertArchive(@Param("archive") Archive archive);
    List<Archive> selectArchiveList();
    Archive selectArchiveByNo(@Param("no") Long no);
    void deleteArchiveByNo(@Param("no") Long no);
}
