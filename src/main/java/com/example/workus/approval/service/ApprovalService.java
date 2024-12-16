package com.example.workus.approval.service;

import com.example.workus.approval.dto.*;
import com.example.workus.approval.mapper.ApprovalMapper;
import com.example.workus.approval.util.CategoryReasonMapping;
import com.example.workus.approval.util.OptionTextMapping;
import com.example.workus.approval.vo.ApprovalCategory;
import com.example.workus.user.mapper.UserMapper;
import com.example.workus.user.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class ApprovalService {

    private final ApprovalMapper approvalMapper;
    private final UserMapper userMapper;

    @Autowired
    public ApprovalService(ApprovalMapper approvalMapper, UserMapper userMapper) {
        this.approvalMapper = approvalMapper;
        this.userMapper = userMapper;
    }

    /**
     * 신청할 수 있는 결재 문서의 종류를 조회한다.
     *
     * @return 결재 문서 종류들
     */
    public List<ApprovalCategory> getCategories() {
        return approvalMapper.getAllCategories();
    }

    /**
     * 팀장의 정보를 부서 번호로 조회한다.
     *
     * @param deptNo 부서 번호
     * @return 팀장 정보
     */
    public User getLeader(Long deptNo) {
        return userMapper.getLeaderByDeptNo(deptNo);
    }

    /**
     * 결재 양식을 작성하고 결재를 요청한다.
     *
     * @param form 결재 양식
     */
    public void addForm(ApvApprovalForm form) {
        validateApprovalForm(form);

        ApvApprovalForm apvBase = new ApvApprovalForm();
        apvBase.setUserNo(form.getUserNo());
        apvBase.setCategoryNo(form.getCategoryNo());
        apvBase.setTitle(form.getTitle());
        apvBase.setFromDate(form.getFromDate());
        apvBase.setReason(form.getReason());
        apvBase.setCommonText(form.getCommonText());

        approvalMapper.insertApprovalFormBase(apvBase);
        Long apvNo = apvBase.getNo();

        // 추가적인 데이터 삽입이 필요한 경우
        if (form.getOptionTexts() != null) {
            Map<String, String> texts = form.getOptionTexts();

            for (Map.Entry<String, String> entry : texts.entrySet()) {
                String termName = entry.getKey();
                String termValue = entry.getValue();

                approvalMapper.insertApprovalFormOption(termName, termValue, apvNo);
            }
        }
    }

    /**
     * 결재 양식에서 유효성을 검사한다.
     *
     * @param form 결재 양식
     */
    private void validateApprovalForm(ApvApprovalForm form) {
        if (form.getTitle() == null || form.getTitle().isEmpty()) {
            throw new IllegalArgumentException("Title cannot be null or empty");
        }
    }

    /**
     * 내 요청 내역을 조회한다.
     *
     * @param userNo 로그인한 사용자 번호
     * @return 결재 요청 리스트
     */
    public List<ApvListViewDto> getMyReqList(Long userNo) {
        return approvalMapper.getReqList(userNo);
    }

    /**
     * 결재 대기 건을 조회한다.
     *
     * @return 결재 대기 건 리스트
     */
    public List<ApvListViewDto> getMyWaitList() {
        List<ApvListViewDto> waitList = approvalMapper.getWaitList();
        setReqUserNames(waitList); // 요청자 이름 설정
        return waitList;
    }

    /**
     * 결재 완료 건을 조회한다.
     *
     * @return 결재 완료 건 리스트
     */
    public List<ApvListViewDto> getMyEndList() {
        List<ApvListViewDto> endList = approvalMapper.getEndList();
        setReqUserNames(endList); // 요청자 이름 설정
        return endList;
    }

    /**
     * 결재 반려 건을 조회한다.
     * @return 결재 반려 건 리스트
     */
    public List<ApvListViewDto> getMyDenyList() {
        List<ApvListViewDto> denyList = approvalMapper.getDenyList();
        setReqUserNames(denyList);
        return denyList;
    }

    /**
     * 팀장은 팀원들의 결재 요청들을 내 공람 내역에서 조회한다.
     *
     * @param leaderNo 팀장 번호
     * @return 팀원들의 결재 요청 리스트
     */
    public List<ApvListViewDto> getMyRefList(Long leaderNo) {
        List<ApvListViewDto> refList = approvalMapper.getRefListByLeaderNo(leaderNo);
        setReqUserNames(refList); // 요청자 이름 설정
        return refList;
    }

    /**
     * 요청자 이름을 설정하는 메서드
     *
     * @param apvListViewDtos 결재 요청 리스트
     */
    private void setReqUserNames(List<ApvListViewDto> apvListViewDtos) {
        for (ApvListViewDto dto : apvListViewDtos) {
            User reqUser = userMapper.getUserByUserNo(dto.getReqUserNo());
            dto.setReqUserName(reqUser.getName());
            dto.setReqUserDeptName(reqUser.getDeptName());
        }
    }

    /**
     * 요청 내역 리스트에서 특정 글을 클릭해서 상세 정보를 조회한다.
     *
     * @param apvNo 글 번호
     * @return 해당 글 상세 정보
     */
    public ApvDetailViewDto getMyReqDetail(Long apvNo) {
        ApvDetailViewDto approvalDetail = approvalMapper.getReqDetailByApvNo(apvNo);

        // 요청자 정보 가져오기
        User reqUser = userMapper.getUserByUserNo(approvalDetail.getReqUserNo());
        approvalDetail.setReqUserName(reqUser.getName());

        // 결재자 정보 가져오기
        if (approvalDetail.getApvUserNo() != null) {
            User apvUser = userMapper.getUserByUserNo(approvalDetail.getApvUserNo());
            if (apvUser != null) {
                approvalDetail.setApvUserName(apvUser.getName());
                approvalDetail.setApvUserPositionName(apvUser.getPositionName());
            }
        }

        // 카테고리 별로 상이한 reason name 매핑 처리
        String reason = CategoryReasonMapping.getReasonByCategory(approvalDetail.getCategoryNo());
        approvalDetail.setReasonTitle(reason);

        // 카테고리 별 optionText 매핑 처리
        Map<String, String> options = OptionTextMapping.getOptionsByCategory(approvalDetail.getCategoryNo());

        // optionTexts get
        List<Map<String, String>> optionTexts = approvalDetail.getOptionTexts();

        // 각 optionText의 textName을 새로 매핑된 entry.getValue()로 교체
        for (Map<String, String> optionMap : optionTexts) {
            String textName = optionMap.get("textName");
            // options에서 textName에 해당하는 값 매칭
            String newValue = options.get(textName);
            if (newValue != null) {
                optionMap.put("textName", newValue);
            }
        }
        return approvalDetail;
    }

    /**
     * 결재 요청이 온 건을 승인한다.
     *
     * @param requestDto 승인시 필요한 정보
     */
    public void approveRequest(ApvApprovalRequestDto requestDto) {
        approvalMapper.updateApprovalStatusCompleted(requestDto);
    }

    /**
     * 결재 요청이 온 건을 반려한다.
     * @param rejectDto 반려시 필요한 정보
     */
    public void rejectRequest(ApvRejectionRequestDto rejectDto) {
        approvalMapper.updateApprovalStatusRejected(rejectDto);
    }
}
