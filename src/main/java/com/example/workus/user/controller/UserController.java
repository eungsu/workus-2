package com.example.workus.user.controller;

import com.example.workus.security.LoginUser;
import com.example.workus.user.dto.*;
import com.example.workus.user.service.UserService;
import com.example.workus.user.vo.User;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Controller
@Slf4j
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/login")
    public String loginform() {
        return "user/login-form";
    }

    @GetMapping("/signup")
    public String signup(Model model) {
        model.addAttribute("signupForm", new UserSignUpForm());
        return "user/signup-form";
    }

    @PostMapping("/signup")
    public String signup(@Valid @ModelAttribute("signupForm")UserSignUpForm form, BindingResult errors) {

        if (errors.hasErrors()) {
            return "user/signup-form";
        }

        if(!form.getPassword().equals(form.getPasswordConfirm())) {
            errors.rejectValue("passwordConfirm", "passwordConfirm.invalid");
            return "user/signup-form";
        }

        userService.addSignUpUser(form); // Form에 담긴 데이터를 서비스에 전달한다.

        return "redirect:/login"; // 회원 가입 완료되면 로그인 페이지로 이동한다.
    }


    @GetMapping("/findpw")
    public String findpw() {
        return "user/findpw-form";
    }

    @GetMapping("/user/myinfo")
    @PreAuthorize("isAuthenticated()")
    public String myinfo(@AuthenticationPrincipal LoginUser loginUser, Model model) { // userNo는 반드시 존재해야 하는 값
        User user = userService.getUserByUserNo(loginUser.getNo()); // userNo로 사용자 정보를 조회한다.
        model.addAttribute("user", user); // 사용자 정보를 model에 담는다. (view에 전달)
        return "user/myinfo-modify"; // View 페이지를 요청한다. [ View 페이지는 모델에 담은 값으로 구성된다. ]
    }

    @PostMapping("/user/myinfo")
    @PreAuthorize("isAuthenticated()")
    public String changeMyInfo(@ModelAttribute("myModifyForm") MyModifyForm form, BindingResult errors, RedirectAttributes redirectAttributes) { // view에서 MyModifyForm에 데이터를 담는다.
        if (errors.hasErrors()) {
            System.out.println("바인딩 시 에러가 발생했습니다.");
        }
        log.info("입력된 사번은 : " + form.getNo());
        log.info("입력된 자기소개는 : " + form.getPr());
        log.info("입력된 주소는 : " + form.getAddress());
        log.info("입력된 이미지는 : " + form.getImage().getOriginalFilename());

        userService.modifyMyUser(form); // Form에 담긴 데이터를 서비스에 전달한다.

        // GET 방식 URL로 localhost/user/myinfo?userNo=사번으로 redirect 하기.
        RedirectAttributes message = redirectAttributes.addFlashAttribute("message", "일반 정보 변경에 성공했습니다.");
        return "redirect:/user/myinfo"; // GET 방식으로 리다이렉트
    }

    @GetMapping("/user/changePw")
    @PreAuthorize("isAuthenticated()")
    public String changePw(@AuthenticationPrincipal LoginUser loginUser, Model model) {
        User user = userService.getUserByUserNo(loginUser.getNo());
        model.addAttribute("user", user);
        return "user/myinfo-changePw"; // View 페이지를 요청한다.
    }

    @PostMapping("/user/changePw")
    @PreAuthorize("isAuthenticated()")
    public String changePw(@Valid @ModelAttribute("myChangePwForm")MyChangePwForm form, BindingResult errors, RedirectAttributes redirectAttributes) { // view에서 MyChangePwForm에 데이터를 담는다.
        if (errors.hasErrors()) {
            System.out.println("바인딩 시 에러가 발생했습니다.");
        }
        log.info("입력된 사번은 : " + form.getNo());
        log.info("입력된 비밀번호는 : " + form.getPassword());

        userService.modifyMyPwd(form); // 비밀번호 변경을 수행한다.

        redirectAttributes.addFlashAttribute("message", "비밀번호가 성공적으로 변경되었습니다.");
        return "redirect:/user/changePw"; // 비밀번호 변경 후 원래 페이지로 리다이렉트
    }

    @GetMapping("/user/changePhone")
    @PreAuthorize("isAuthenticated()")
    public String changePhone(@AuthenticationPrincipal LoginUser loginUser, Model model) {
        User user = userService.getUserByUserNo(loginUser.getNo());
        model.addAttribute("user", user);
        return "user/myinfo-changePhone";
    }

    @PostMapping("/user/changePhone")
    @PreAuthorize("isAuthenticated()")
    public String changePhone(@Valid @ModelAttribute("mychangePhoneForm")MyChangePhoneForm form, BindingResult errors, RedirectAttributes redirectAttributes) {
        if (errors.hasErrors()) {
            System.out.println("바인딩 시 에러가 발생했습니다.");
        }
        log.info("입력된 사번은 : " + form.getNo()); 
        log.info("입력된 연락처는 : " + form.getPhone());

        userService.modifyMyPhone(form); // 연락처 변경을 수행한다.

        redirectAttributes.addFlashAttribute("message", "연락처가 성공적으로 변경되었습니다.");
        return "redirect:/user/changePhone"; // 연락처 변경 후 원래 페이지로 리다이렉트
    }

    @GetMapping("/address-book/manage/list") // 직원 정보 조회 ( 여기서는 휴직 및 퇴직한 직원까지 다 조회한다. )
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public String manageList(
            @RequestParam(name = "page", required = false, defaultValue = "1") int page,
            @RequestParam(name = "dept", required = false) String dept,
            @RequestParam(name = "name", required = false) String name,
            @RequestParam(name = "status", required = false) String status,
            Model model) {

        log.info("페이지번호: {}", page);
        log.info("부서: {}", dept);
        log.info("직원명: {}", name);
        log.info("재직상태: {}", status);

        Map<String, Object> condition = new HashMap<>(); // 검색 조건을 담을 Map 객체
        condition.put("page", page); // 페이지 번호
        if (!"all".equals(status)) {
            condition.put("status", status); // 재직 상태
        }
        if (!"all".equals(dept)) {
            condition.put("dept", dept); // 부서 선택 옵션
        }
        if (StringUtils.hasText(name)) {
            condition.put("name", name); // 직원명
        }

        System.out.println("---------------------------" + condition);
        // 검색 조건으로 유저 목록을 조회해야 한다.
        UserListDto<User> dto = userService.getUserListByCondition(condition);
        System.out.println(dto.toString());
        System.out.println(dto.getData());
        // UserListDto<User>를 "users"로 모델에 저장한다.
        model.addAttribute("userList", dto.getData()); // 유저 목록

        System.out.println("-----------------------------------------" + dto.getPaging().toString());
        // Pagination을 "paging"으로 모델에 저장한다.
        model.addAttribute("paging", dto.getPaging()); // 페이지네이션 객체

        return "addressbook/manage-list";
    }

    @GetMapping("/address-book/insert")
    @PreAuthorize("hasRole('ADMIN')") // 관리자 권한이 있을 때만 접근 가능하도록 한다.
    public String insertEmployeeForm() {
        return "addressbook/insert-employee";
    }

    @PostMapping("/address-book/insert")
    @PreAuthorize("hasRole('ADMIN')")
    public String registerNewEmployee(@ModelAttribute("registerNewEmployeeForm")RegisterNewEmployeeForm form, BindingResult errors, RedirectAttributes redirectAttributes) {
        if (errors.hasErrors()) {
            System.out.println("바인딩 시 에러가 발생했습니다.");
        }

        log.info("입력된 프로필 사진은" + form.getImage().getOriginalFilename());
        log.info("입력된 사번은 : " + form.getNo());
        log.info("입력된 이름은 : " + form.getName());
        log.info("입력된 생년월일은 : " + form.getBirthDate());
        log.info("입력된 입사일은 : " + form.getHireDate());
        log.info("입력된 부서 번호는 : " + form.getDeptNo());
        log.info("입력된 직책 번호는 : " + form.getPositionNo());
        log.info("입력된 권한 번호는 : " + form.getRoleNo());
        log.info("입력된 미사용 연차일수는 : " + form.getUnusedAnnualLeave());

        userService.registerNewEmployeee(form); // 신규 유저 등록을 수행한다.

        redirectAttributes.addFlashAttribute("insert", "신규 직원이 성공적으로 등록되었습니다.");
        return "redirect:/address-book/detail?no=" + form.getNo(); // 연락처 변경 후 등록한 회원의 상세 페이지로 리다이렉트
    }

    @GetMapping("/address-book/detail")
    public String detail(int no, Model model) {
        User user = userService.getUserByUserNo(no); // 사번으로 해당 유저를 조회한다.
        model.addAttribute("user", user); // 유저를 view 객체에 전달한다.

        return "addressbook/detail-info";
    }

    @GetMapping("/address-book/list") // 직원 정보 조회 ( 여기서는 재직중인 직원만 조회한다. )
    public String list(
            @RequestParam(name = "page", required = false, defaultValue = "1") int page,
            @RequestParam(name = "dept", required = false) String dept,
            @RequestParam(name = "name", required = false) String name,
            @RequestParam(name = "status", required = false, defaultValue = "Y") String status,
            Model model) {

        log.info("페이지번호: {}", page);
        log.info("부서: {}", dept);
        log.info("직원명: {}", name);
        log.info("재직상태: {}", status);

        Map<String, Object> condition = new HashMap<>(); // 검색 조건을 담을 Map 객체
        condition.put("page", page); // 페이지 번호
        if (!"all".equals(status)) {
            condition.put("status", status); // 재직 상태
        }
        if (!"all".equals(dept)) {
            condition.put("dept", dept); // 부서 선택 옵션
        }
        if (StringUtils.hasText(name)) {
            condition.put("name", name); // 직원명
        }

        System.out.println("---------------------------" + condition);
        // 검색 조건으로 재직중인 유저 목록을 조회해야 한다.
        UserListDto<User> dto = userService.getUserListByCondition(condition);
        System.out.println(dto.toString());
        System.out.println(dto.getData());
        // UserListDto<User>를 "users"로 모델에 저장한다.
        model.addAttribute("userList", dto.getData()); // 유저 목록

        System.out.println("-----------------------------------------" + dto.getPaging().toString());
        // Pagination을 "paging"으로 모델에 저장한다.
        model.addAttribute("paging", dto.getPaging()); // 페이지네이션 객체

        return "addressbook/list";
    }

    @GetMapping("/address-book/modify")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')") // 인사팀 이상의 권한이 있을 때만 접근 가능하도록 한다.
    public String modifyEmployeeForm(int no, Model model) {
        User user = userService.getUserByUserNo(no); // 사번으로 해당 유저를 조회한다.
        model.addAttribute("user", user); // 유저를 view 객체에 전달한다.

        return "addressbook/modify-employee";
    }

    @PostMapping("/address-book/modify")
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public String modifyEmployee(@ModelAttribute("modifyEmployeeForm")ModifyEmployeeForm form, BindingResult errors, RedirectAttributes redirectAttributes) {
        if (errors.hasErrors()) {
            System.out.println("바인딩 시 에러가 발생했습니다.");
        }

        log.info("입력된 프로필 사진은" + form.getImage().getOriginalFilename());
        log.info("입력된 이름은 : " + form.getName());
        log.info("입력된 생년월일은 : " + form.getBirthDate());
        log.info("입력된 입사일은 : " + form.getHireDate());
        log.info("입력된 부서 번호는 : " + form.getDeptNo());
        log.info("입력된 직책 번호는 : " + form.getPositionNo());
        log.info("입력된 권한 번호는 : " + form.getRoleNo());
        log.info("입력된 미사용 연차일수는 : " + form.getUnusedAnnualLeave());

//        userService.registerNewEmployeee(form); // 신규 유저 등록을 수행한다.

        redirectAttributes.addFlashAttribute("insert", "신규 직원이 성공적으로 등록되었습니다.");
        return "redirect:/address-book/detail?no="; // + form.getNo(); // 연락처 변경 후 등록한 회원의 상세 페이지로 리다이렉트
    }
}
