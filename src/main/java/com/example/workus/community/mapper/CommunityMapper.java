package com.example.workus.community.mapper;

import com.example.workus.community.vo.Feed;
import com.example.workus.community.vo.HashTag;
import com.example.workus.community.vo.Like;
import com.example.workus.community.vo.Reply;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface CommunityMapper {

    // 게시글 해쉬태그 조회
    List<HashTag> getHashTagsByFeedNo(@Param("feedNo") long feedNo);
    int getTotalRows();

    // 게시글 번호로 팝업 조회
    Feed getFeedByNo(@Param("feedNo") long feedNo);
    // 게시글에 해당하는 모든 댓글 조회
    List<Reply> getReplysByFeedNo(@Param("feedNo") long feedNo);

    // 게시글 작성
    void insertFeed(@Param("feed") Feed feed);
    // 게시글에 해쉬태그 추가
    void insertHashTag(@Param("hashTag") HashTag hashTag);

    // 게시글 검색
    List<Feed> getSearchFeeds(@Param("condition")Map<String, Object> condition);
    int getTotalRows2(@Param("condition")Map<String, Object> condition);

    // 댓글 작성
    void insertReply(@Param("reply") Reply reply);
    // 최신댓글 한개 조회
    Reply getReplyByFeedNo(@Param("feedNo") long feedNo);


    // 게시글 번호로 게시글,댓글,해쉬태그 삭제
    // 게시글 댓글 삭제
    void deleteReplysByFeedNo(@Param("feedNo") long feedNo);
    // 게시글 좋아요 삭제
    void deleteLikeByFeedNo(@Param("feedNo") long feedNo);
    // 게시글 해쉬태그 삭제
    void deleteHashTagsByFeedNo(@Param("feedNo") long feedNo);
    // 게시글 삭제
    void deleteFeedsByFeedNo(@Param("feedNo") long feedNo,@Param("userNo") long userNo);


    // 게시글 수정
    void updateFeed(@Param("feed") Feed feed);
    // 게시글 해쉬태그 수정
    void updateHashTag(@Param("hashTag") HashTag hashTag);


    // 게시글 좋아요 개수 조회
    int getlikeCountByFeedNo(@Param("feedNo") long feedNo);
    //
    String getLikeUsersByFeedNo(@Param("feedNo") long feedNo);
    // 좋아요 여부확인
    boolean isLiked(@Param("feedNo") long feedNo,@Param("userNo") long userNo);
    // 좋아요 추가
    void insertLike(@Param("like") Like like);
    // 좋아요 취소
    void cancelLikeByFeedNo(@Param("feedNo") long feedNo,@Param("userNo") long userNo);
    // 해당 게시글 좋아요 유저닉네임 조회
    List<Like> getLikesByFeedNo(@Param("feedNo") long feedNo);


    Reply getReplyByReplyNo(@Param("replyNo") long replyNo);
    // 게시글 댓글 삭제
    void deleteReplyByReplyNo(@Param("replyNo") long replyNo);

}
