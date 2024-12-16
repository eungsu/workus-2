package com.example.workus.common.dto;

import com.example.workus.common.util.Pagination;
import lombok.*;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Builder
public class ListDto<T> {

    // 목록화면에 표시되는 데이터
    List<T> data;
    // 목록화면에 표시되는 페이징처리정보
    Pagination paging;
}
