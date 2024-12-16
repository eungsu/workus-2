package com.example.workus.user.mapper;

import com.example.workus.user.dto.DeptDto;
import com.example.workus.user.vo.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface UserMapper {

    List<User> getUsersNotMe(@Param("userNo") long userNo);

    User getUserByUserNo(@Param("userNo") long userNo);

    User getUserById(@Param("id") String id);

    void insertUser(User user);

    List<User> getAllUsersByName(@Param("name") String userName);

    void updateSignUpUser(@Param("user") User user); // 사이트 회원가입 진행

    int getTotalRows(@Param("condition") Map<String, Object> condition); // 재직상태와 일치하는 회원수 조회

    List<User> getUsersByCondition(@Param("condition") Map<String, Object> condition); // 재직상태 조건에 맞는 회원 정보 조회

    List<DeptDto> getAllDepts();

    void updateMyUser(@Param("user") User user); // 내 정보를 수정한다.

    List<DeptDto> getDeptByUserNo(@Param("userNo") long userNo);

    void updateMyPhone(@Param("user") User user); // 내 연락처를 수정한다.

    void updateMyPassword(@Param("user") User user); // 내 비밀번호를 수정한다

    int getUserRoleNo(@Param("userNo") Long userNo); // 권한 조회

    User getLeaderByDeptNo(@Param("deptNo") long deptNo); // 팀장 조회

    double getAnnualLeaveByPositionNo(@Param("positionNo") long positionNo); // 직급에 맞는 기본 연차수를 조회한다.

    long getNextUserNoSequence(); // 다음번 유저 사번을 획득한다.

    void insertNewEmployee(@Param("user") User user); // 신규 직원을 등록한다.

    List<User> getUsersByRoleNos(@Param("roleNos") List<Integer> roleNos); // 특정 권한으로 유저들을 조회한다.
}
