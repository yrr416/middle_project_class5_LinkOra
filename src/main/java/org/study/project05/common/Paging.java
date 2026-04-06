package org.study.project05.common;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * Paging - 페이징 처리를 위한 공통 VO
 * 참조 프로젝트의 로직을 기반으로 하되, 자바 표준 규약을 준수합니다.
 */
@Getter
@Setter
@ToString
public class Paging {

    // 현재 페이지
    private int nowPage = 1;
    // 현재 블록
    private int nowBlock = 1;
    // 한 페이지당 게시물의 수
    private int numPerPage = 10;
    // 페이지당 블록의 수
    private int pagePerBlock = 5;
    // DB 전체 게시물의 수
    private int totalRecord = 0;
    // 전체 페이지의 수
    private int totalPage = 0;
    // 전체 블록의 수
    private int totalBlock = 0;
    // 블록의 시작 페이지 번호
    private int beginBlock = 0;
    // 블록의 끝 페이지 번호
    private int endBlock = 0;

    // MySQL/MariaDB LIMIT 쿼리용 offset (시작 포인트)
    private int offset = 0;
}
