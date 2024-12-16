package com.example.workus.common.dto;

import jakarta.servlet.http.HttpServletResponse;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class RestResponseDto<T> {
	
	private int status;
	private String message;
	private T data;
	
	public RestResponseDto(int status, String message, T data) {
		this.status = status;
		this.message = message;
		this.data = data;
	}
	
	/**
	 * 요청처리를 성공했을 때 응답을 생성해서 반환한다.
	 * @param <T> 데이터의 타입
	 * @param data 응답으로 보내는 데이터
	 * @return REST 표준 응답객체
	 */
	public static <T> RestResponseDto<T> success(T data) {
		RestResponseDto<T> dto = new RestResponseDto<>();
		dto.setStatus(HttpServletResponse.SC_OK);
		dto.setMessage("success");
		dto.setData(data);
		
		return dto;
	}
	
	/**
	 * 요청처리를 실패했을 때 응답을 생성해서 반환한다.
	 * @param <T> 데이터 타입, 데이터가 없기 때문에 void로 설정한다.
	 * @param message 오류 메시지
	 * @return REST 표준 응답객체
	 */
	public static <T> RestResponseDto<T> fail(String message) {
		RestResponseDto<T> dto = new RestResponseDto<>();
		dto.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		dto.setMessage(message);
		dto.setData(null);
		
		return dto;
	}
	
	/**
	 * 요청처리를 실패했을 때 응답을 생성해서 반환한다.
	 * @param <T> 데이터 타입, 데이터가 없기 때문에 void로 설정한다.
	 * @param status 상태 번호
	 * @param message 오류 메시지
	 * @return REST 표준 응답객체
	 */
	public static <T> RestResponseDto<T> fail(int status, String message) {
		RestResponseDto<T> dto = new RestResponseDto<>();
		dto.setStatus(status);
		dto.setMessage(message);
		dto.setData(null);
		
		return dto;
	}
}
