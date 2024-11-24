package dto;

import java.io.Serializable;

public class Cloth implements Serializable {

    private int id;
    private String name;
    private String category;
    private String color;
    private String size;
    private String season;
    private String imageUrl;

    // 생성자
    public Cloth() {}

    public Cloth(int id, String name, String category, String color, String size, String season, String imageUrl) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.color = color;
        this.size = size;
        this.season = season;
        this.imageUrl = imageUrl;
    }

    // Getter/Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getSeason() {
        return season;
    }

    public void setSeason(String season) {
        this.season = season;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
