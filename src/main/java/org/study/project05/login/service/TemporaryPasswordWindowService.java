package org.study.project05.login.service;

import java.util.Collection;

public interface TemporaryPasswordWindowService {

    void markMemberTemporaryPasswords(Collection<String> userIds);

    void markPartnerTemporaryPasswords(Collection<String> partnerIds);

    boolean isMemberTemporaryPasswordExpired(String userId);

    boolean isPartnerTemporaryPasswordExpired(String partnerId);

    void clearMemberTemporaryPassword(String userId);

    void clearPartnerTemporaryPassword(String partnerId);
}
