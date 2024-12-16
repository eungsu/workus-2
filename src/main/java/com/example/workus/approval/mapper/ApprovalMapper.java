package com.example.workus.approval.mapper;

import com.example.workus.approval.dto.*;
import com.example.workus.approval.vo.ApprovalCategory;
import com.example.workus.user.vo.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ApprovalMapper {
    // 결재 양식 종류 조회
    List<ApprovalCategory> getAllCategories();

    // 결재 신청 (기본 폼)
    void insertApprovalFormBase(@Param("apvForm") ApvApprovalForm apvForm);
    // 결재 신청 (옵션 텍스트)
    void insertApprovalFormOption(@Param("termName") String termName
                                , @Param("termValue") String termValue
                                , @Param("apvNo") Long apvNo);

    // 내 결재 요청 리스트 조회
    List<ApvListViewDto> getReqList(@Param("userNo") Long userNo);
    // 내 결재함 조회
    List<ApvListViewDto> getWaitList();
    List<ApvListViewDto> getEndList();
    List<ApvListViewDto> getDenyList();
    // 내 결재함 조회 중 열람건 조회
    List<ApvListViewDto> getRefListByLeaderNo(@Param("leaderNo") Long leaderNo);

    // 결재 요청 상세 조회
    ApvDetailViewDto getReqDetailByApvNo(@Param("apvNo") Long apvNo);

    // 승인 및 반려 로직
    void updateApprovalStatusCompleted(@Param("reqDto") ApvApprovalRequestDto requestDto);
    void updateApprovalStatusRejected(@Param("rejectDto") ApvRejectionRequestDto rejectionDto);
}
