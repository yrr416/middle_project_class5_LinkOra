package org.study.project05.common;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Paging {

    // 현재 페이지
    private int nowPage = 1 ;
    // 현재 블록
    private int nowBlock = 1 ;
    // 한 페이지당 게시물의 수
    private int numPerPage = 10;
    // 페이지당 블록의 수
    private int pagePerBlock = 3 ;
    // DB 게시물의 수
    private int totalRecord = 0 ;
    // 전체 페이지의 수
    private int totalPage = 0 ;
    // 전체 블록의 수
    private int totalBlock = 0 ;
    // 블록의 시작과 끝
    private int beginBlock = 0 ;
    private int endBlock = 0 ;

    // 한번에 가져올 게시물을 처리하는 변수 (MySQL O, MariaDB O, Oracle X)
    private int offset = 0;
}
