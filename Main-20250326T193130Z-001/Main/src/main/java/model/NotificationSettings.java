/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class NotificationSettings {
    private int notificationID;
    private String rollNumber;
    private String notificationInterval;
    private boolean enabled;

    public NotificationSettings() {
    }

    public NotificationSettings(int notificationID, String rollNumber, String notificationInterval, boolean enabled) {
        this.notificationID = notificationID;
        this.rollNumber = rollNumber;
        this.notificationInterval = notificationInterval;
        this.enabled = enabled;
    }

    public int getNotificationID() {
        return notificationID;
    }

    public void setNotificationID(int notificationID) {
        this.notificationID = notificationID;
    }

    public String getRollNumber() {
        return rollNumber;
    }

    public void setRollNumber(String rollNumber) {
        this.rollNumber = rollNumber;
    }
    
    public String getNotificationInterval() {
        return notificationInterval;
    }

    public void setNotificationInterval(String notificationInterval) {
        this.notificationInterval = notificationInterval;
    }

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }
}
