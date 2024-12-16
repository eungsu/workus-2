package com.example.workus.chat.dto;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;

@JsonTypeInfo(
        use = JsonTypeInfo.Id.NAME,
        include = JsonTypeInfo.As.PROPERTY,
        property = "type"    // 명시적으로 'type' 속성 사용
)
@JsonSubTypes({
        @JsonSubTypes.Type(value = TextPayload.class, name = "text"),
        @JsonSubTypes.Type(value = FilePayload.class, name = "file"),
        @JsonSubTypes.Type(value = EmojiPayload.class, name = "emoji")
})
public interface Payload {
}