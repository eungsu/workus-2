package com.example.workus.attendance.controller;

import com.example.workus.attendance.dto.*;
import com.example.workus.attendance.service.AttendanceService;
import com.example.workus.attendance.vo.AttendanceCategory;
import com.example.workus.common.dto.ListDto;
import com.example.workus.security.LoginUser;
import com.example.workus.user.service.UserService;
import com.example.workus.user.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/attendance")
public class AttendanceController {

    private final AttendanceService attendanceService;
    private final UserService userService;

    @Autowired
    public AttendanceController(AttendanceService attendanceService, UserService userService) {
        this.attendanceService = attendanceService;
        this.userService = userService;
    }

    @GetMapping("/list")
    public String list(@AuthenticationPrincipal LoginUser loginUser
                        , Model model)
    {
        AttendanceDto attendanceDto = attendanceService.getAttendance(loginUser.getNo());
        model.addAttribute("attendanceDto", attendanceDto);

        int myApvCount = attendanceService.getTotalRowsMyApv(loginUser.getNo());
        model.addAttribute("myApvCount", myApvCount);

        return "attendance/list";
    }

    @GetMapping("/atdFormInUser")
    @ResponseBody
    public List<User> usersInAtdForm(@AuthenticationPrincipal LoginUser loginUser) {
        return (List<User>) userService.getUsersExceptMe(loginUser.getNo());
    }

    @GetMapping("/atdFormInCtgr")
    @ResponseBody
    public List<AttendanceCategory> categoriesInAtdForm() {
        return (List<AttendanceCategory>) attendanceService.getCategories();
    }

    @PostMapping("/getApproval")
    public String getApproval(AtdApprovalForm form
                            , @AuthenticationPrincipal LoginUser loginUser
                            , @RequestParam(required = false) int dayTotal)
    {
        AtdApprovalForm apvForm = new AtdApprovalForm();
        apvForm.setNo(form.getNo());
        apvForm.setReason(form.getReason());
        apvForm.setFromDate(form.getFromDate());
        apvForm.setToDate(form.getToDate());
        apvForm.setCategoryNo(form.getCategoryNo());
        apvForm.setUserNo(loginUser.getNo());
        apvForm.setTime(form.getTime());
        List<AtdApprovalUserDto> users = new ArrayList<>();
        String[] apvs = form.getApv().split(",");
        String[] refs = form.getRef().split(",");
        // 승인자 리스트 추가
        int index = 0;
        for (String value : apvs) {
            Long intValue = Long.valueOf(value);

            AtdApprovalUserDto userDto = AtdApprovalUserDto.builder()
                    .status("A")
                    .userNo(intValue)
                    .sequence(index++)
                    .formNo(form.getNo())
                    .build();
            users.add(userDto);
        }
        // 참조자 리스트 추가
        index = 0;
        for (String value : refs) {
            Long intValue = Long.valueOf(value);
            AtdApprovalUserDto userDto = AtdApprovalUserDto.builder()
                    .status("R")
                    .userNo(intValue)
                    .sequence(index++)
                    .formNo(form.getNo())
                    .build();
            users.add(userDto);
        }

        // ApprovalRequestDto 생성 및 dayTotal 설정
        AtdApprovalRequestDto atdApprovalRequestDto = new AtdApprovalRequestDto();
        atdApprovalRequestDto.setAtdNo(form.getNo());
        atdApprovalRequestDto.setDayTotal(BigDecimal.valueOf(dayTotal));

        attendanceService.insertApprovalForm(apvForm, users);

        return "redirect:/attendance/list";
    }

    @GetMapping("/myReqList")
    public String myApvList(@AuthenticationPrincipal LoginUser loginUser
                            , Model model
                            , @RequestParam(required = false, defaultValue = "1") int page
                            , @RequestParam(required = false, defaultValue = "10") int rows
                            , @RequestParam(required = false) String status)
    {
        Map<String, Object> condition = new HashMap<>();
        condition.put("page", page);
        condition.put("rows", rows);
        if (StringUtils.hasText(status)) {
            condition.put("status", status);
        }

        ListDto<ReqViewDto> forms = attendanceService.getRequestForms(loginUser.getNo(), condition);

        model.addAttribute("condition", condition);
        model.addAttribute("forms", forms.getData());
        model.addAttribute("paging", forms.getPaging());

        return "attendance/myReqList";
    }

    @GetMapping("/myApvList")
    public String myReqList(@AuthenticationPrincipal LoginUser loginUser
                            , Model model
                            , @RequestParam(required = false, defaultValue = "1") int page
                            , @RequestParam(required = false, defaultValue = "10") int rows
                            , @RequestParam(required = false) String opt
                            , @RequestParam(required = false) String keyword)
    {
        Map<String, Object> condition = new HashMap<>();
        condition.put("page", page);
        condition.put("rows", rows);
        if (StringUtils.hasText(opt)) {
            condition.put("opt", opt);
            condition.put("keyword", keyword);
        }

        ListDto<ApvViewDto> forms = attendanceService.getApprovalForms(loginUser.getNo(), condition);
        model.addAttribute("condition", condition);
        model.addAttribute("forms", forms.getData());
        model.addAttribute("paging", forms.getPaging());

        return "attendance/myApvList";
    }

    @GetMapping("/myRefList")
    public String myRefList(@AuthenticationPrincipal LoginUser loginUser
                            , Model model
                            , @RequestParam(required = false, defaultValue = "1") int page
                            , @RequestParam(required = false, defaultValue = "10") int rows
                            , @RequestParam(required = false) String opt
                            , @RequestParam(required = false) String keyword)
    {
        Map<String, Object> condition = new HashMap<>();
        condition.put("page", page);
        condition.put("rows", rows);
        if (StringUtils.hasText(opt)) {
            condition.put("opt", opt);
            condition.put("keyword", keyword);
        }

        int roleNo = attendanceService.getUserRoleNo(loginUser.getNo());
        condition.put("roleNo", roleNo);

        ListDto<RefViewDto> forms = attendanceService.getReferenceForms(loginUser.getNo(), condition);
        model.addAttribute("condition", condition);
        model.addAttribute("forms", forms.getData());
        model.addAttribute("paging", forms.getPaging());

        return "attendance/myRefList";
    }
}
