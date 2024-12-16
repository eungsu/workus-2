package com.example.workus.community.controller;

import com.example.workus.common.util.WebContentFileUtils;
import com.example.workus.community.dto.*;
import com.example.workus.community.service.CommunityService;
import com.example.workus.community.vo.Feed;
import com.example.workus.community.vo.Reply;
import com.example.workus.security.LoginUser;
import com.example.workus.user.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.IllformedLocaleException;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/community")
public class CommunityController {

    @Autowired
    CommunityService communityService;
    @Autowired
    private WebContentFileUtils webContentFileUtils;

    @GetMapping("/list")
    public String list() {
        return "community/list";
    }

    @GetMapping("/items")
    @ResponseBody
    public List<Feed> getFeeds(@RequestParam(name = "page", required = false, defaultValue = "1") int page,
                               @RequestParam(name = "opt", required = false) String opt,
                               @RequestParam(name = "keyword", required = false) String keyword) {
        Map<String, Object> condition = new HashMap<>();
        condition.put("page", page);

        if (StringUtils.hasText(opt) && StringUtils.hasText(keyword)) {
            condition.put("opt", opt);
            condition.put("keyword", keyword);
        }

        List<Feed> feeds = communityService.getFeeds(condition);
        if (feeds.isEmpty()) {
            throw new RuntimeException("검색오류");
        }
        return feeds;
    }

    @GetMapping("form")
    public String form() {
        return "community/form";
    }

    @PostMapping("/insertFeed")
    public String addFeed(FeedForm form, @AuthenticationPrincipal LoginUser loginUser) {
        Long userNo = loginUser.getNo();

        communityService.insertFeed(form, userNo);
        return "redirect:/community/list";
    }

    @PostMapping("/insertReply")
    @ResponseBody
    public Reply insertReply(CommentForm commentForm, @AuthenticationPrincipal LoginUser loginUser) {
        Long userNo = loginUser.getNo();
        Reply reply = communityService.insertReply(commentForm, userNo);

        return reply;
    }

    @GetMapping("/feed/{feedNo}")
    @ResponseBody
    public Feed getFeedDetail(@PathVariable Long feedNo) {
        Feed feed = communityService.getFeed(feedNo);
        return feed;
    }

    @PostMapping("deleteFeed")
    public String deleteFeed(long feedNo, @AuthenticationPrincipal LoginUser loginUser) {
        Feed feed = communityService.getFeed(feedNo);
        Long userNo = loginUser.getNo();
        communityService.deleteFeed(feedNo, userNo);
        return "redirect:/community/list";
    }

    @PostMapping("deleteReply")
    @ResponseBody
    public String deleteReply(long replyNo, @AuthenticationPrincipal LoginUser loginUser) {
        communityService.deleteReply(replyNo, loginUser.getNo());

        return "redirect:/community/list";
    }

    @GetMapping("modify")
    public String modifyFeed(long feedNo, @AuthenticationPrincipal LoginUser loginUser, Model model) {
        long userNo = loginUser.getNo();
        Feed feed = communityService.getFeedByFeedNo(feedNo);
        feed.setHashTags(communityService.getHashTagByFeedNo(feedNo));
        if (feed.getUser().getNo() != userNo ) {
            return "redirect:/community/list";
        }
        model.addAttribute("feed", feed);

        return "community/modify";
    }


    @PostMapping("updateFeed")
    public String updateFeeed(ModifyFrom form, @AuthenticationPrincipal LoginUser loginUser) {
        Long userNo = loginUser.getNo();
        communityService.updateFeed(form,userNo);
        return "redirect:/community/list";
    }

    @PostMapping("like")
    @ResponseBody
    public LikeCountDto feedLike(long feedNo, @AuthenticationPrincipal LoginUser loginUser) {
        Long userNo = loginUser.getNo();
        LikeCountDto likeFeed = communityService.LikeByFeedNo(feedNo,userNo);


        return likeFeed;
    }
}