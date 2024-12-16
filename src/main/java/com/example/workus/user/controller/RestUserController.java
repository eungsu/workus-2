package com.example.workus.user.controller;

import com.example.workus.common.dto.RestResponseDto;
import com.example.workus.user.service.UserService;
import com.example.workus.user.vo.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/ajax")
public class RestUserController {

    private UserService userService;

    @Autowired
    public RestUserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/chat/profile/{userNo}")
    ResponseEntity<RestResponseDto<User>> getProfileByUserNo(@PathVariable("userNo") Long userNo) {
        return ResponseEntity.ok(RestResponseDto.success(userService.getUserByUserNo(userNo)));
    }

    @GetMapping("/user/check-no/{userNo}") // 로그인 전에는 userNo 사용 가능. 로그인 이후에는 userNo는 무조건 Authentication으로만
    ResponseEntity<RestResponseDto<Boolean>> checkUserNo(@PathVariable("userNo") Long userNo) {
        boolean isUserExist = userService.isUserExistByUserNo(userNo);
        return ResponseEntity.ok(RestResponseDto.success(isUserExist)); // 유저가 존재하면 true
    }

    @GetMapping("/user/check-id/{userId}")
    ResponseEntity<RestResponseDto<Boolean>> checkUserId(@PathVariable("userId") String userId) {
        boolean isUserExist = userService.isUserExistByUserId(userId);
        return ResponseEntity.ok(RestResponseDto.success(isUserExist)); // 유저가 존재하면 true
    }

    @GetMapping("/chatroom/user/search/{userName}")
    ResponseEntity<RestResponseDto<List<User>>> getAllUsersByUserName(@PathVariable("userName") String userName) {
        return ResponseEntity.ok(RestResponseDto.success(userService.getAllUsersByName(userName)));
    }

    @GetMapping("/user/get-sequence/userNo") // 현재 사번을 조회해온다.
    ResponseEntity<RestResponseDto<Long>> getUserSequence() {
        return ResponseEntity.ok(RestResponseDto.success(userService.getNextUserSequence()));
    }

    @GetMapping("/user/count-annualLeave/{positionNo}") // 기본 연차 개수를 조회해온다.
    ResponseEntity<RestResponseDto<Double>> getAnnualLeave(@PathVariable("positionNo") Long positionNo) {
        return ResponseEntity.ok(RestResponseDto.success(userService.getBasicAnnualLeave(positionNo)));
    }
}
