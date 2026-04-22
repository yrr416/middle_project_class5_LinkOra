package org.study.project05.login.service.impl;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.study.project05.login.service.TemporaryPasswordWindowService;

import java.util.Collection;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class TemporaryPasswordWindowServiceImpl implements TemporaryPasswordWindowService {

    private final long ttlMillis;
    private final Map<String, Long> memberExpiresAt = new ConcurrentHashMap<>();
    private final Map<String, Long> partnerExpiresAt = new ConcurrentHashMap<>();

    public TemporaryPasswordWindowServiceImpl(
            @Value("${app.temp-password.ttl-minutes:10}") long ttlMinutes
    ) {
        long safeMinutes = ttlMinutes <= 0 ? 10 : ttlMinutes;
        this.ttlMillis = safeMinutes * 60_000L;
    }

    @Override
    public void markMemberTemporaryPasswords(Collection<String> userIds) {
        long expiresAt = System.currentTimeMillis() + ttlMillis;
        if (userIds == null) {
            return;
        }
        for (String id : userIds) {
            if (id != null && !id.isBlank()) {
                memberExpiresAt.put(id.strip(), expiresAt);
            }
        }
    }

    @Override
    public void markPartnerTemporaryPasswords(Collection<String> partnerIds) {
        long expiresAt = System.currentTimeMillis() + ttlMillis;
        if (partnerIds == null) {
            return;
        }
        for (String id : partnerIds) {
            if (id != null && !id.isBlank()) {
                partnerExpiresAt.put(id.strip(), expiresAt);
            }
        }
    }

    @Override
    public boolean isMemberTemporaryPasswordExpired(String userId) {
        return isExpired(memberExpiresAt, userId);
    }

    @Override
    public boolean isPartnerTemporaryPasswordExpired(String partnerId) {
        return isExpired(partnerExpiresAt, partnerId);
    }

    @Override
    public void clearMemberTemporaryPassword(String userId) {
        if (userId != null && !userId.isBlank()) {
            memberExpiresAt.remove(userId.strip());
        }
    }

    @Override
    public void clearPartnerTemporaryPassword(String partnerId) {
        if (partnerId != null && !partnerId.isBlank()) {
            partnerExpiresAt.remove(partnerId.strip());
        }
    }

    private static boolean isExpired(Map<String, Long> store, String rawId) {
        if (rawId == null || rawId.isBlank()) {
            return false;
        }
        String id = rawId.strip();
        Long expiresAt = store.get(id);
        if (expiresAt == null) {
            return false;
        }
        if (System.currentTimeMillis() <= expiresAt) {
            return false;
        }
        store.remove(id);
        return true;
    }
}
