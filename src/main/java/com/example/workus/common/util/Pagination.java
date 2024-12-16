package com.example.workus.common.util;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class Pagination {

    private int page;			// 현재 페이지
    private int totalRows;		// 총 데이터 갯수
    private int rowsPerPage;	    // 페이지당 표시할 데이터 갯수
    private int pagesPerBlock;	// 한 번에 표시할 페이지번호 개수
    private int totalPages;		// 총 페이지 갯수
    private int totalBlocks;     // 총 블록 갯수
    private int currentBlock;    // 현재 블록 번호
    private int begin;			// 조회 시작 번호
    private int end;			    // 조회 끝 번호
    private int beginPage;		// 페이지 내비게이션에 표시할 시작 페이지번호
    private int endPage;		    // 페이지 내비게이션에 표시할 끝 번호
    private boolean isFirst;	    // 첫 페이지면 true
    private boolean isLast; 	    // 마지막 페이지면 true
    private int prevPage;		// 현재 페이지의 이전 페이지번호
    private int nextPage;		// 현재 페이지의 다음 페이지번호
    private int offset;

    /**
     * 현재 페이지번호와 총 데이터갯수를 전달받아서 객체를 초기화하고,
     * 페이징 처리에 필요한 값을 계산한다.
     * @param page 현재 페이지번호
     * @param totalRows 총 데이터 갯수
     */
    public Pagination(int page, int totalRows) {
        this.page = page;
        this.totalRows = totalRows;
        this.rowsPerPage = 10;
        this.pagesPerBlock = 5;
        init();
    }

    /**
     * 현재 페이지번호와 총 데이터갯수, 한 화면에 표시할 데이터 갯수를
     * 전달받아서 객체를 초기화하고, 페이징처리에 필요한 값을 계산한다.
     * @param page 현재 페이지 번호
     * @param totalRows 총 데이터 갯수
     * @param rowsPerPage 한 화면에 표시할 데이터 갯수
     */
    public Pagination(int page, int totalRows, int rowsPerPage) {
        this.page = page;
        this.totalRows = totalRows;
        this.rowsPerPage = rowsPerPage;
        this.pagesPerBlock = 5;
        init();
    }

    /**
     * 현재 페이지번호와 총 데이터갯수, 한 화면에 표시할 데이터 갯수
     * 페이지 내비게이션에 한번에 표시할 페이지번호 갯수를
     * 전달받아서 객체를 초기화하고, 페이징처리에 필요한 값을 계산한다.
     * @param page 현재 페이지 번호
     * @param totalRows 총 데이터 갯수
     * @param rowsPerPage 한 화면에 표시할 데이터 갯수
     * @param pagesPerBlock 페이지 내비게이션의 한 블록에 표시할 페이지번호 갯수
     */
    public Pagination(int page, int totalRows, int rowsPerPage, int pagesPerBlock) {
        this.page = page;
        this.totalRows = totalRows;
        this.rowsPerPage = rowsPerPage;
        this.pagesPerBlock = pagesPerBlock;
        init();
    }

    private void init() {
        if (totalRows > 0) {
            if (page <= 0) {
                page = 1;
            }
            totalPages = (int) Math.ceil((double)totalRows/rowsPerPage);
            if (page >= totalPages) {
                page = totalPages;
            }

            begin = (page - 1)*rowsPerPage + 1;
            end = page*rowsPerPage;
            offset = begin - 1;

            totalBlocks = (int) Math.ceil((double)totalPages/pagesPerBlock);
            currentBlock = (int) Math.ceil((double)page/pagesPerBlock);

            beginPage = (currentBlock - 1)*pagesPerBlock + 1;
            endPage = currentBlock*pagesPerBlock;
            if (currentBlock == totalBlocks) {
                endPage = totalPages;
            }

            isFirst = page == 1;
            isLast = page == totalPages;

            prevPage = page - 1;
            nextPage = page + 1;
        }
    }
}
