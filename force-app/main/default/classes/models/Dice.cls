/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 17.5.2021
 * ____________________________________________________________
 * 
*/


public with sharing class Dice {

    private Integer value;
    private Integer order;
    private Boolean held;

    public Dice(Integer order) {
        this.order = order;
        this.value = 6; 
        this.held = false;
    }

    public Integer getValue() {
        return this.value;
    }

    public void setValue(Integer value) {
        this.value = value;
    }

    public Integer getOrder() {
        return this.order;
    }

    public void setOrder(Integer order) {
        this.order = order;
    }

    public Boolean isHeld() {
        return this.held;
    }

    public void setHeld(Boolean held) {
        this.held = held;
    }


}
