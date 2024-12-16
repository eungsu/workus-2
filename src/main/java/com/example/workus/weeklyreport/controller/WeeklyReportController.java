package com.example.workus.weeklyreport.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("weeklyreport")
public class WeeklyReportController {

    @GetMapping("list")
    public String list() {
        return "weeklyreport/list";
    }

    @GetMapping("detail")
    public String detail() {
        return "weeklyreport/detail";
    }
}
