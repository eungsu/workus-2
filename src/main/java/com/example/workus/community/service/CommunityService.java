package com.example.workus.community.service;

import com.example.workus.common.s3.S3Service;
import com.example.workus.common.util.WebContentFileUtils;
import com.example.workus.community.dto.*;
import com.example.workus.community.mapper.CommunityMapper;
import com.example.workus.community.vo.Feed;
import com.example.workus.community.vo.HashTag;
import com.example.workus.community.vo.Like;
import com.example.workus.community.vo.Reply;
import com.example.workus.user.mapper.UserMapper;
import com.example.workus.user.vo.User;
import com.example.workus.common.util.FileUtils;
import com.example.workus.common.util.Pagination;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;

@Service
public class CommunityService {

    @Value("${cloud.aws.s3.bucket}")
    private String bucketName;

    @Value("${cloud.aws.s3.folder}")
    private String folder;

    private static final String COMMUNITY_DIR = "/communityfeedfile";


    @Autowired
    CommunityMapper communityMapper;
    @Autowired
    private WebContentFileUtils webContentFileUtils;
    @Autowired
    private S3Service s3Service;
    @Autowired
    private UserMapper userMapper;

    // 게시글 조회 무한스크롤
    public List<Feed> getFeeds(Map<String,Object> condtion){
        int totalRows = communityMapper.getTotalRows2(condtion);
        int page = (Integer) condtion.get("page");
        Pagination pagination = new Pagination(page, totalRows,1);

        if(pagination.getTotalPages() < page) {
                return null;
        }

        condtion.put("begin",pagination.getBegin());
        condtion.put("end",pagination.getEnd());

        List<Feed> feeds = communityMapper.getSearchFeeds(condtion);
        for (Feed feed : feeds) {
            List<HashTag> hashTags = communityMapper.getHashTagsByFeedNo(feed.getNo());
            feed.setHashTags(hashTags);
            Reply reply = communityMapper.getReplyByFeedNo(feed.getNo());
            feed.setReply(reply);
            List<Like> likes = communityMapper.getLikesByFeedNo(feed.getNo());
            feed.setLikes(likes);
        }
        return feeds;
    }

    // 게시글 작성 (제목,내용,해쉬태그,파일)
    public void insertFeed(FeedForm form, Long userNo){
        MultipartFile upfile = form.getUpfile();
        // 멀티파트 파일에 진짜 이름을 가져옴
        String filename = form.getUpfile().getOriginalFilename();
        // 첨부파일, 디렉토리 경로, 저장할 파일명을 전달받아서 파일을 저장한다.
        s3Service.uploadFile(upfile,bucketName,folder+COMMUNITY_DIR,filename);

        // 게시글 생성
        Feed feed = new Feed();
        // 입력한 내용 게시글에 전달
        feed.setTitle(form.getTitle());
        feed.setContent(form.getContent());
        feed.setUser(User.builder().no(userNo).build());
        feed.setMediaUrl(filename);
        feed.setReply(new Reply());
        // feed -> {no:0, title:'xxxx'}

        // 인서트 sql 내용에 데이터 넣음
        communityMapper.insertFeed(feed);
        // feed -> {no:34}

        try {
            // jsonText = [{"value":"#222"},{"value":"#333"}]
            String jsonText = form.getTags();
            ObjectMapper mapper = new ObjectMapper();

            // list ---> [map, map]
            // map -> {key:"value" value:"#222"}
            // map -> {key:"value" value:"#333"} 이렇게 담겨 있다.
            List<Map<String, String>> list = mapper.readValue(jsonText, new TypeReference<List<Map<String, String>>>() {});

            // 반복문 사용해서 객체 데이터 뽑아서 담음
            for (Map<String, String> map : list) {
                String value = map.get("value");

                HashTag hashTag = new HashTag();
                hashTag.setFeed(feed);
                hashTag.setName(value);

                communityMapper.insertHashTag(hashTag);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public Reply insertReply(CommentForm form, Long userNo) {
        // 댓글 객체 생성
        Reply reply = new Reply();
        reply.setContent(form.getComment());  // 댓글 내용

        // 피드 객체 생성
        Feed feed = new Feed();
        feed.setNo(form.getFeedNo());
        reply.setFeed(feed);

        // 사용자 객체 생성
        User user = new User();
        user.setNo(userNo);
        reply.setUser(user);

        // 댓글 저장
        communityMapper.insertReply(reply);

        // 최신 리플 조회
        reply = communityMapper.getReplyByFeedNo(form.getFeedNo());

        // 저장된 댓글 반환
        return reply;
    }

    public Feed  getFeed(long feedNo) {
        Feed feed = communityMapper.getFeedByNo(feedNo);
        feed.setLikesCount(communityMapper.getlikeCountByFeedNo(feedNo));
        List<Reply> replys = communityMapper.getReplysByFeedNo(feedNo);
        feed.setReplys(replys);
        return feed;
    }


    public void deleteFeed(Long feedNo, Long userNo) {
        Feed feed = communityMapper.getFeedByNo(feedNo); // 번호에 맞는 피드찾기
        communityMapper.deleteLikeByFeedNo(feedNo);// 게시글 삭제 맨 마지막에 삭제 되어야함
        communityMapper.deleteReplysByFeedNo(feedNo);         // 게시글에 맞는 댓글 삭제
        communityMapper.deleteHashTagsByFeedNo(feedNo);      // 게시글에 맞는 해쉬태그 삭제
        communityMapper.deleteFeedsByFeedNo(feedNo,userNo);
    }

    public Reply getReply(long feedNo) {
        Reply reply = communityMapper.getReplyByFeedNo(feedNo);
        return  reply;
    }

    public void deleteReply(long replyNo, long userNo){
        Reply reply = communityMapper.getReplyByReplyNo(replyNo);


        if (reply.getUser().getNo() == userNo) {
            communityMapper.deleteReplyByReplyNo(replyNo);
        } else {
            throw new RuntimeException();
        }

    }

    public Feed getFeedByFeedNo(long feedNo){
         return communityMapper.getFeedByNo(feedNo);
    }

    public List<HashTag> getHashTagByFeedNo(long feedNo){
        return communityMapper.getHashTagsByFeedNo(feedNo);
    }


    public void updateFeed(ModifyFrom form,long userNo) {
        Feed existingFeed = communityMapper.getFeedByNo(form.getFeedNo());
        existingFeed = communityMapper.getFeedByNo(form.getFeedNo());
        existingFeed.setTitle(form.getTitle());
        existingFeed.setContent(form.getContent());

        if (!form.getUpfile().isEmpty()) {
            MultipartFile upfile = form.getUpfile();
            // 멀티파트 파일에 진짜 이름을 가져옴
            String filename = form.getUpfile().getOriginalFilename();
            // 첨부파일, 디렉토리 경로, 저장할 파일명을 전달받아서 파일을 저장한다.
            s3Service.uploadFile(upfile,bucketName,folder,filename);
            existingFeed.setMediaUrl(filename);
        }

        communityMapper.updateFeed(existingFeed);

        communityMapper.deleteHashTagsByFeedNo(form.getFeedNo());
        try {
            // jsonText = [{"value":"#222"},{"value":"#333"}]
            String jsonText = form.getTags();
            ObjectMapper mapper = new ObjectMapper();

            // list ---> [map, map]
            // map -> {key:"value" value:"#222"}
            // map -> {key:"value" value:"#333"} 이렇게 담겨 있다.
            List<Map<String, String>> list = mapper.readValue(jsonText, new TypeReference<List<Map<String, String>>>() {});

            // 반복문 사용해서 객체 데이터 뽑아서 담음
            for (Map<String, String> map : list) {
                String value = map.get("value");

                HashTag hashTag = new HashTag();
                hashTag.setFeed(existingFeed);
                hashTag.setName(value);

                communityMapper.insertHashTag(hashTag);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public LikeCountDto LikeByFeedNo(long feedNo, long userNo) {
        // 중복여부를 확인한다.
        boolean isliked = communityMapper.isLiked(feedNo, userNo);
        // 중복이라면 좋아요 제거
        if (isliked) {
            communityMapper.cancelLikeByFeedNo(feedNo, userNo);
        } else {
            // 좋아요를 안 눌렀다면 , 새로운 좋아요 추가
            Like like = new Like();

            Feed feed = new Feed();
            feed.setNo(feedNo);
            like.setFeed(feed);

            User user = new User();
            user.setNo(userNo);
            like.setUser(user);

            // 좋아요 디비 저장
            communityMapper.insertLike(like);
        }
        int LikeCount = communityMapper.getlikeCountByFeedNo(feedNo);
        String LikeUserName = communityMapper.getLikeUsersByFeedNo(feedNo);
        LikeCountDto likeCountDto = new LikeCountDto();
        likeCountDto.setLikeCount(LikeCount);
        likeCountDto.setUserName(LikeUserName);
        return likeCountDto;
    }




}