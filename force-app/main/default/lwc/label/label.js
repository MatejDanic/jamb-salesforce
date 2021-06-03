/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 7.5.2021.
 * @modified 3.6.2021.
 * ____________________________________________________________
 * 
*/

import { LightningElement, api } from 'lwc';

export default class Label extends LightningElement {

    @api text;
    @api body;
    @api title;
    @api icon;
    @api image;
    @api width;
    @api height;

    @api showModal = false;

    @api
    toggleModal() {
        this.showModal = !this.showModal;
    }
}