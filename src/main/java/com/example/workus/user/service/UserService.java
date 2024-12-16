package com.example.workus.user.service;

import com.example.workus.common.exception.WorkusException;
import com.example.workus.common.util.Pagination;
import com.example.workus.common.util.WebContentFileUtils;
import com.example.workus.user.dto.DeptDto;
import com.example.workus.user.dto.MyModifyForm;
import com.example.workus.user.dto.UserListDto;
import com.example.workus.user.dto.UserSignUpForm;
import com.example.workus.user.dto.*;
import com.example.workus.user.mapper.UserMapper;
import com.example.workus.user.vo.User;
import com.example.workus.util.UserUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@Transactional
public class UserService {

    // 파일 경로를 담을 path 설정.
    private String path = "resources/repository/userprofile/";

    @Autowired
    WebContentFileUtils webContentFileUtils;

    @Autowired
    private UserMapper userMapper;
    @Autowired
    private PasswordEncoder passwordEncoder;

    public UserService(UserMapper userMapper, PasswordEncoder passwordEncoder) {
        this.userMapper = userMapper;
        this.passwordEncoder = passwordEncoder;
    }

    /**
     * (본인 제외, 퇴사한 상태 제외) 유저 전체를 조회한다.
     *
     * @return 유저 정보 전체 리스트
     */
    public List<User> getUsersExceptMe(Long userNo) {
        return userMapper.getUsersNotMe(userNo);
    }

    /**
     * 회원가입을 통해 그룹웨어의 신규 회원을 등록한다.
     *
     * @Param 회원가입 폼에 담긴 정보들
     */
    public void addSignUpUser(UserSignUpForm form) {
        User user = new User(); // 폼에 담긴 정보를 User 객체에 담자.
        user.setId(form.getId());
        user.setPassword(passwordEncoder.encode(form.getPassword()));
        // 비밀번호는 passwordEncoder에 의해 암호화된 비밀번호를 DB 저장
        user.setPhone(UserUtils.getFormatPhoneNumber(form.getPhone()));
        // 휴대폰 번호는 UserUtils를 통해 포맷팅해서 DB에 저장한다.
        user.setAddress(form.getAddress() + " " + form.getDetailAddress());
        // 주소는 API를 통해 입력된 주소 + 상세 주소
        user.setNo(form.getNo()); // 사번으로 조회해야 하니 사번을 전달한다.

        try {
            userMapper.updateSignUpUser(user);
        } catch (DataAccessException e) {
            throw new WorkusException("회원가입 처리 중 오류가 발생함" + e);
        }
    }

    public User getUserByUserNo(long userNo) {
        return userMapper.getUserByUserNo(userNo);
    }

    /**
     * 사번으로 해당 사원이 존재하는지 확인한다.
     *
     * @param userNo 사번
     * @return 해당 사원이 존재하면 true, 존재하지 않으면 false
     */
    public boolean isUserExistByUserNo(long userNo) {
        return userMapper.getUserByUserNo(userNo) != null; // 조회해왔는데 null 아니면 해당 유저가 존재하는 것이므로
    }

    /**
     * 아이디로 일치하는 사원이 존재하는지 확인한다.
     *
     * @param userId 유저 아이디
     * @return 해당 아이디를 가진 사원이 존재하면 true, 존재하지 않으면 false
     */
    public boolean isUserExistByUserId(String userId) {
        return userMapper.getUserById(userId) != null; // 조회해왔는데 null이 아니면 해당 유저가 존재하는 것이므로
    }


    /**
     * 조회 조건에 맞는 회원 목록을 돌려준다. [ 전체 사원 조회용 ]
     *
     * @param condition page(페이지 번호), dept(부서 옵션), name(직원명), status(재직상태)
     * @return 조회 조건에 맞는 회원목록
     */
    public UserListDto<User> getUserListByCondition(Map<String, Object> condition) {
        // 조회조건에 맞는 총 데이터 갯수를 조회한다.
        int totalRows = userMapper.getTotalRows(condition);
        System.out.println("==================================" + condition);
        log.info(totalRows + "건의 데이터가 조회되었습니다.");

        // 현재 페이지번호, 총 데이터 개수로 Pagination 객체를 만든다.
        int page = (Integer) condition.get("page"); // page의 default값은 1
        System.out.println("----------------------------------" + condition);
        Pagination pagination = new Pagination(page, totalRows, 10);
        System.out.println("===================================" + pagination.toString());

        // 페이지번호에 맞는 데이터 조회범위를 검색 조건에 추가한다.
        if (pagination.getBegin() != 0) {
            condition.put("begin", pagination.getBegin() - 1); // 시작 범위
        } else {
            condition.put("begin", 0);
        }
        System.out.println("begin in IF" + condition.get("begin"));
        System.out.println("begin out IF" + condition.get("begin"));
        condition.put("end", pagination.getEnd()); // 끝 범위
        System.out.println("------------------------" + condition);

        // 검색 조건에 맞는 게시글 데이터를 조회한다.
        // 현재 검색 조건 -> page, dept, name, status, begin, end
        List<User> users = userMapper.getUsersByCondition(condition);

        // 조회된 게시글 목록과, 생성한 Pagination을 AddressListDto 객체에 저장한다.
        UserListDto<User> dto = new UserListDto<>(users, pagination);

        return dto;
    }

    public List<User> getAllUsersByName(String userName) {
        return userMapper.getAllUsersByName(userName);
    }

    /**
     * 내 정보 수정에서 프로필 사진, 자기 소개, 주소와 같은 기본적인 정보를 수정한다.
     * @param form 내 정보 수정 폼을 통해 전달되는 데이터
     */
    public void modifyMyUser(MyModifyForm form) {

        User preUser = userMapper.getUserByUserNo(form.getNo()); // 기존에 입력되어 있던 유저 데이터
        User user = new User();
        user.setNo(form.getNo()); // form에 입력된 사번을 새로 전달할 유저의 사번으로 담아야 한다.

        // 입력폼에 값을 입력하지 않은 경우에는 기존의 값을 그대로 가져가자.
        if (form.getPr() != null) {
            user.setPr(form.getPr()); // form에 입력한 자기소개 글귀
        } else {
            user.setPr(preUser.getPr()); // 기존에 입력한 자기소개 글귀
        }

        if(form.getAddress() != null) {
            user.setAddress(form.getAddress()); // form에 입력한 주소
        } else {
            user.setAddress(preUser.getAddress()); // 기존에 입력한 주소
        }

        if (!form.getImage().isEmpty()) { // 이미지 파일을 입력했을 때만
            MultipartFile imageFile = form.getImage(); // 첨부파일
            String originalFilename = imageFile.getOriginalFilename(); // 실제 파일명
            String filename = form.getNo() +  originalFilename.substring(originalFilename.lastIndexOf("."));
            System.out.println("DB에 저장할 파일명은 " + filename);
            user.setProfileSrc(filename); // profileSrc에는 파일명을 입력한다.
            webContentFileUtils.saveWebContentFile(imageFile, path, filename);
        } else {
            user.setProfileSrc(preUser.getProfileSrc()); // 첨부하지 않은 경우에는 기존의 프로필 사진을 그대로 가져간다.
        }

        userMapper.updateMyUser(user); // 유저 정보를 수정한다.
    }

    public List<DeptDto> getAllDepts() {
        return userMapper.getAllDepts(); // 부서 목록을 가져오는 Mapper 메서드 호출
    }

    public List<DeptDto> getDeptsForUser(Long userNo) {
        return userMapper.getDeptByUserNo(userNo); // 사용자 ID로 부서 조회하는 Mapper 메서드
    }

    /**
     * 내 정보 수정에서 비밀번호만 변경한다.
     * @param form 내 비밀번호 변경 폼을 통해 전달되는 데이터
     */
    public void modifyMyPwd(MyChangePwForm form) {
        User user = new User();
        user.setNo(form.getNo()); // 어떤 사용자의 비밀번호를 변경할 지 사번을 전달한다.
        user.setPassword(passwordEncoder.encode(form.getPassword())); // 암호화된 비밀번호를 DB에 전달한다.

        userMapper.updateMyPassword(user);
    }

    /**
     * 내 정보 수정에서 연락처만 변경한다.
     * @param form 내 연락처 변경 폼을 통해 전달되는 데이터
     */
    public void modifyMyPhone(MyChangePhoneForm form) {
        User user = new User();
        user.setNo(form.getNo());
        user.setPhone(UserUtils.getFormatPhoneNumber(form.getPhone())); // 양식에 따라 변경된 연락처를 DB에 전달한다.

        userMapper.updateMyPhone(user);
    }

    /**
     * 신규 직원등록 시 사번 등록을 위해 다음 번 사번을 가져온다.
     * @return 사번 (Sequence)
     */
    public long getNextUserSequence() {
        return userMapper.getNextUserNoSequence();
    }

    /**
     * 신규 직원등록 시 직책에 따른 기본 연차개수를 가져온다.
     * @param positionNo 직책 번호
     * @return 기본 연차 개수
     */
    public double getBasicAnnualLeave(long positionNo) {
        return userMapper.getAnnualLeaveByPositionNo(positionNo);
    }

    /**
     * 신규 직원 등록폼의 데이터를 가지고 DB에 저장하는 작업을 수행한다.
     * @param form 신규 직원 등록폼
     */
    public void registerNewEmployeee(RegisterNewEmployeeForm form) {
        User user = new User();
        user.setNo(form.getNo());
        user.setName(form.getName());
        user.setBirthday(form.getBirthDate());
        user.setHireDate(form.getHireDate());
        user.setDeptNo(form.getDeptNo());
        user.setPositionNo(form.getPositionNo());
        user.setUnusedAnnualLeave(form.getUnusedAnnualLeave());
        user.setRoleNo(form.getRoleNo());

        // 프로필 사진 업로드
        if (!form.getImage().isEmpty()) { // 이미지 파일을 입력했을 때만
            MultipartFile imageFile = form.getImage(); // 첨부파일
            String originalFilename = imageFile.getOriginalFilename(); // 실제 파일명
            String filename = form.getNo() +  originalFilename.substring(originalFilename.lastIndexOf("."));
            System.out.println("DB에 저장할 파일명은 " + filename);
            user.setProfileSrc(filename); // profileSrc에는 파일명을 입력한다.
            webContentFileUtils.saveWebContentFile(imageFile, path, filename);
        }

        userMapper.insertNewEmployee(user); // 신규 직원을 등록한다.
    }

    /**
     * roleNo를 Constants에서 선택해서 해당 권한을 갖고 있는 유저들을 조회한다.
     * @param roleNos 권한 번호(들)
     * @return 권한 조건에 해당하는 유저들
     */
    public List<User> getUsersByRoleNos(List<Integer> roleNos) {
        return userMapper.getUsersByRoleNos(roleNos);
    }
}
