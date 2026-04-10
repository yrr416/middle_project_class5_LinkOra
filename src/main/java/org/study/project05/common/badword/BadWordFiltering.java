package org.study.project05.common.badword;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.regex.Pattern;

public class BadWordFiltering extends HashSet<String> implements BadWords, ReadURL, ReadFile {
    private String substituteValue = "*";

    //대체 문자 지정
    //기본값 : *
    public BadWordFiltering() {
        addAll(List.of(koreaWord1));
    }

    public BadWordFiltering(String substituteValue) {
        this.substituteValue = substituteValue;
    }

    //비속어 있다면 대체 (긴 단어 먼저 처리 → 겹치는 단어 누락 방지)
    public String change(String text) {
        List<String> words = new ArrayList<>(this);
        // 길이 내림차순 정렬: "개새끼"(3)가 "개새"(2), "새끼"(2)보다 먼저 처리됨
        words.sort(Comparator.comparingInt(String::length).reversed());
        for (String v : words) {
            if (text.contains(v)) {
                String sub = this.substituteValue.repeat(v.length());
                text = text.replace(v, sub);
            }
        }
        return text;
    }

    public String change(String text, String[] sings) {
        StringBuilder singBuilder = new StringBuilder("[");
        for (String sing : sings) singBuilder.append(Pattern.quote(sing));
        singBuilder.append("]*");
        String patternText = singBuilder.toString();

        // 긴 단어 먼저 처리
        List<String> words = new ArrayList<>(this);
        words.sort(Comparator.comparingInt(String::length).reversed());
        for (String word : words) {
            if (word.length() == 1) {
                text = text.replace(word, substituteValue);
                continue;
            }
            String[] chars = word.chars().mapToObj(Character::toString).toArray(String[]::new);
            text = Pattern.compile(String.join(patternText, chars))
                    .matcher(text)
                    .replaceAll(v -> substituteValue.repeat(v.group().length()));
        }

        return text;
    }

    //비속어가 1개라도 존재하면 true 반환
    public boolean check(String text) {
        return stream().anyMatch(text::contains);
    }

    //공백을 없는 상태 체크
    public boolean blankCheck(String text) {
        return check(text.replace(" ", ""));
    }
}