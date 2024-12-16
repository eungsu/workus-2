package com.example.workus.common.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@AllArgsConstructor
@Getter
@Setter
public class DeleteFileData {

    private String filename;
    private String message;
}
