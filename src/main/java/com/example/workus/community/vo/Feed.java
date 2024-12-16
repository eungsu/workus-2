package com.example.workus.community.vo;

import com.example.workus.user.vo.User;
import lombok.*;
import org.apache.ibatis.type.Alias;

import java.util.Date;
import java.util.List;
import java.util.Set;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Alias("Feed")
@Builder
public class Feed {
    private Long no;
    private String title;
    private String content;
    private String mediaUrl;
    private String mediaType;
    private Date createDate;
    private Date updateDate;

    private User user;

    private List<HashTag> hashTags;

    private Reply reply;
    private List<Reply> replys;

    private List<Like> likes;
    private int likesCount;
    public String getUserName() {
        return likes == null || likes.isEmpty() ? "" : likes.get(0).getUser().getName();
    }

    public int getLikeCount() {
        return likes == null ? 0 : likes.size();
    }

    private static Set<String> images = Set.of("png", "jpg", "jpeg");
    private static Set<String> videos = Set.of("mp4", "avi", "mpg", "mpeg");

    public String getMediaType() {
        if (mediaUrl != null) {
            String extension = mediaUrl.substring(mediaUrl.lastIndexOf(".") + 1).toLowerCase();

            if (images.contains(extension)) {
                return "image";
            } else if (videos.contains(extension)) {
                return "video";
            }
        }
        return null;
    }

}
