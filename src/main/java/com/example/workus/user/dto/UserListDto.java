package com.example.workus.user.dto;

import com.example.workus.common.util.Pagination;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@AllArgsConstructor
@Getter
@Setter
public class UserListDto<T> {

    // 회원 주소록 목록화면에서 표시되는 데이터다.
    List<T> data; // 회원의 정보를 저장할 예정.
    Pagination paging; // 페이지네이션 정보를 담을 객체

    @Override
    public String toString() {
        return "UserListDto [data=" + data + ", paging=" + paging + "]";
    }
}
