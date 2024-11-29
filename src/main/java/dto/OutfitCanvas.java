package dto;

import java.io.Serializable;
import java.sql.Timestamp;

public class OutfitCanvas implements Serializable {

    private int id;                   // 작업 ID
    private int outfitId;             // 코디 ID (outfits 테이블의 ID)
    private int clothId;              // 옷 ID (clothes 테이블의 ID)
    private float positionX;          // 이미지의 X 위치
    private float positionY;          // 이미지의 Y 위치
    private float width;              // 이미지의 너비
    private float height;             // 이미지의 높이
    private float rotationAngle;      // 이미지의 회전 각도
    private Timestamp createdAt;      // 작업 생성 시간

    // 기본 생성자
    public OutfitCanvas() {}

    // 생성자
    public OutfitCanvas(int id, int outfitId, int clothId, float positionX, float positionY,
                        float width, float height, float rotationAngle, Timestamp createdAt) {
        this.id = id;
        this.outfitId = outfitId;
        this.clothId = clothId;
        this.positionX = positionX;
        this.positionY = positionY;
        this.width = width;
        this.height = height;
        this.rotationAngle = rotationAngle;
        this.createdAt = createdAt;
    }

    // Getter and Setter 메서드
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOutfitId() {
        return outfitId;
    }

    public void setOutfitId(int outfitId) {
        this.outfitId = outfitId;
    }

    public int getClothId() {
        return clothId;
    }

    public void setClothId(int clothId) {
        this.clothId = clothId;
    }

    public float getPositionX() {
        return positionX;
    }

    public void setPositionX(float positionX) {
        this.positionX = positionX;
    }

    public float getPositionY() {
        return positionY;
    }

    public void setPositionY(float positionY) {
        this.positionY = positionY;
    }

    public float getWidth() {
        return width;
    }

    public void setWidth(float width) {
        this.width = width;
    }

    public float getHeight() {
        return height;
    }

    public void setHeight(float height) {
        this.height = height;
    }

    public float getRotationAngle() {
        return rotationAngle;
    }

    public void setRotationAngle(float rotationAngle) {
        this.rotationAngle = rotationAngle;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "OutfitCanvas{" +
                "id=" + id +
                ", outfitId=" + outfitId +
                ", clothId=" + clothId +
                ", positionX=" + positionX +
                ", positionY=" + positionY +
                ", width=" + width +
                ", height=" + height +
                ", rotationAngle=" + rotationAngle +
                ", createdAt=" + createdAt +
                '}';
    }
}
