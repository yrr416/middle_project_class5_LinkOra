/**
 * partner 테이블 컬럼과 매핑되는 사업자 값 객체(사업자번호·연락처·프로필 등).
 */
package org.study.project05.partner.vo;

public class PartnerVO {
    private int ptnIdx;
    private String partnerId;
    private String password;
    private String name;
    private String email;
    private String address;
    private String phone;
    private String businessNo;
    private String profileImage;
    private Integer active;

    public int getPtnIdx() {
        return ptnIdx;
    }

    public void setPtnIdx(int ptnIdx) {
        this.ptnIdx = ptnIdx;
    }

    public String getPartnerId() {
        return partnerId;
    }

    public void setPartnerId(String partnerId) {
        this.partnerId = partnerId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getBusinessNo() {
        return businessNo;
    }

    public void setBusinessNo(String businessNo) {
        this.businessNo = businessNo;
    }

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }

    public Integer getActive() {
        return active;
    }

    public void setActive(Integer active) {
        this.active = active;
    }
}
