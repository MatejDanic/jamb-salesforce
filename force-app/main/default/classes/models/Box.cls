/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 17.5.2021
 * @modified 19.5.2021
 * ____________________________________________________________
 * 
*/

public with sharing class Box {
    
    private Integer value;
    private BoxType type;
    private Boolean filled;
    private Boolean available;

    public Box(BoxType type, Boolean available) {
        this.type = type;
        this.available = available;
        this.value = 0;
        this.filled = false;
    }

    public Integer getValue() {
        return this.value;
    }

    public void setValue(Integer value) {
        this.value = value;
    }

    public BoxType getType() {
        return this.type;
    }

    public void setType(BoxType type) {
        this.type = type;
    }

    public Boolean isFilled() {
        return this.filled;
    }

    public void setFilled(Boolean filled) {
        this.filled = filled;
    }

    public Boolean isAvailable() {
        return this.available;
    }

    public void setAvailable(Boolean available) {
        this.available = available;
    }

    public void fill(Integer value) {
        this.value = value;
        this.filled = true;
        this.available = false;
    }

}
