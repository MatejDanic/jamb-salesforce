import { LightningElement, api, wire } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import { getRecord, createRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import SOCKET_IO from '@salesforce/resourceUrl/SocketIO';
import USER_ID from '@salesforce/user/Id';
import WEBSOCKET_SERVER_URL from '@salesforce/label/c.WebSocket_Server_URL';

import FIELD_USER_ACTIVE from '@salesforce/schema/User.IsActive';
import getActiveUsers from '@salesforce/apex/UserController.getActiveUsers';

const ERROR_TITLE = "Error";
const ERROR_VARIANT = "Error";

export default class WebsocketChat extends LightningElement {
    @api userId = USER_ID;
    @api timeString;
    @api message;
    @api error;

    _socketIOInitialized = false;
    _socket;

    @wire(getRecord, { recordId: USER_ID, fields: [FIELD_USER_ACTIVE] })
    wiredUser({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            this.isUserActive = data.fields.IsActive.value;
        }
    }

    @wire(getActiveUsers)
    wiredActiveUsers

    /**
     * Loading the socket.io script.
     */
    renderedCallback() {
        if (this._socketIOInitialized) {
            return;
        }
        this._socketIOInitialized = true;

        Promise.all([
            loadScript(this, SOCKET_IO),
        ])
            .then(() => {
                this.initSocketIO();
            })
            .catch(error => {
                console.error(error);
                this.dispatchEvent(new ShowToastEvent({
                    title: ERROR_TITLE,
                    message: error.body ? error.body.message : error,
                    variant: ERROR_VARIANT,
                }));
                return false;
            });
    }

    /**
     * After socket.io has initialized, make our socket connection and register listeners. 
     */
    initSocketIO() {
        // eslint-disable-next-line no-undef
        // eslint-disable-next-line no-undef
        this._socket = io.connect(WEBSOCKET_SERVER_URL);

        if (this._socket !== undefined) {

            /**
             * Not necessary for functionality. We are just demonstrates the socket 
             * connection with the server by display a counting timestring on the frontend.
             */
            this._socket.on('time', (timeString) => {
                this.timeString = timeString;
            });

            /**
             * Listening for activity on the message input field. 
             * Handling the socket event emit for when the user is typing 
             * and if a chat message was submitted (enter key is pressed).
             */
            messageInput.addEventListener('keydown', (event) => {
                this._socket.emit('usertyping', { userId: this.userId });
                // Tab key for when input field is put into focus.
                if (event.keyCode !== 9) {
                    this._socket.emit('usertyping', { userId: this.userId });
                }
                if (event.which === 13 && event.shiftKey === false) {
                    event.preventDefault();

                    const fields = {};
                    fields[CONTENT_FIELD.fieldApiName] = messageInput.value;
                    fields[USER_FIELD.fieldApiName] = this.userId;
                    const message = { apiName: MESSAGE_OBJECT.objectApiName, fields };

                    createRecord(message)
                        .then(() => {
                            // Reset the form input field.
                            messageInput.value = '';
                            // Refresh the message data for other active users.
                            this._socket.emit('transmit');
                            // Refresh the message data for the current user.
                            return refreshApex(this.wiredMessages);
                        })
                        .catch(error => {
                            // eslint-disable-next-line no-console
                            console.error('error', error);
                            this.error = 'Error creating message';
                        });
                }
            });

            /**
             * When the user has released typing, debounce the release.
             * After 1 second, emit that the user as not typing at longer. 
             * Useful for displaying the typing indicator to the other connected users.
             */
            messageInput.addEventListener('keyup', this.debounce(() => {
                this._socket.emit('usernottyping', { userId: this.userId });
            }, 1000));

            /**
             * If we received an event indicating that a user is typing, display 
             * the typing indicator if it's not the current user.
             * TODO: Handle specific users typing.
             */
            this._socket.on('istyping', (data) => {
                if (data.userId !== this.userId) {
                    this.isTyping = true;
                }
            });

            /**
             * If we received an event indicating that a user has stopped typing,
             * stop displaying the typing indicator if it's not the current user.
             * TODO: Handle specific users typing.
             */
            this._socket.on('nottyping', (data) => {
                if (data.userId !== this.userId) {
                    this.isTyping = false;
                }
            });

            /**
             * Utility socket event to display the chat data for demo
             * purposes only.
             */
            this._socket.on('output', (data) => {
                // eslint-disable-next-line no-console
                console.log('on output', data);
            });

            /**
             * Setting various messages received back from the socket connection.
             */
            this._socket.on('status', (data) => {
                if (data.success) {
                    messageInput.value = '';
                    this.message = data.message;
                    this.messageResetDelay('message');
                    this.error = '';
                } else if (!data.success) {
                    this.error = data.message;
                    this.messageResetDelay('error');
                    this.message = '';
                }
            })

            /**
             * If we're told that a message was sent to the chatroom,
             * refresh the stale messages data.
             */
            this._socket.on('chatupdated', () => {
                return refreshApex(this.wiredMessages);
            });

            this._socket.on('refreshChatUsers', () => {
                return refreshApex(this.wiredChatUsers);
            });
        }
    }

    // handleEnterChat() {
    //     setUserChatActive()
    //         .then((res) => {
    //             this.isChatActive = res.Chat_Active__c;
    //             this._socket.emit('userEnteredChat');
    //             return refreshApex(this.wiredChatUsers);
    //         })
    //         .catch(error => {
    //             // eslint-disable-next-line no-console
    //             console.error('error', error);
    //             this.error = 'Error updating user record';
    //         });
    // }

    // handleLeaveChat() {
    //     // eslint-disable-next-line no-undef
    //     //const socket = io.connect(WEBSOCKET_SERVER_URL);
    //     setUserChatInactive()
    //         .then((res) => {
    //             this.isChatActive = res.Chat_Active__c;
    //             this._socket.emit('userLeftChat');
    //             return refreshApex(this.wiredChatUsers);
    //         })
    //         .catch(error => {
    //             // eslint-disable-next-line no-console
    //             console.error('error', error);
    //             this.error = 'Error updating user record';
    //         });
    // }

    // get isInputDisabled() {
    //     return this.isChatActive ? false : true;
    // }

    // get inputPlaceholderText() {
    //     return this.isInputDisabled ? '' : 'Type your message and press enter';
    // }

    // get displayChatUserList() {
    //     return this.isChatActive && this.wiredChatUsers;
    // }

    // /**
    //  * Utility debounce function.
    //  * @param {Function} callback - The function to debounce.
    //  * @param {Number} wait - The number of milliseconds to debounce.
    //  */
    // debounce(callback, wait) {
    //     let timeout;
    //     return (...args) => {
    //         const context = this;
    //         clearTimeout(timeout);
    //         // eslint-disable-next-line @lwc/lwc/no-async-operation
    //         timeout = setTimeout(() => callback.apply(context, args), wait);
    //     };
    // }

    // /**
    //  * Utility function to remove any displayed message after 1 second.
    //  * @param {Text} msgType - Maps to the component message attribute.
    //  */
    // messageResetDelay(msgType) {
    //     // eslint-disable-next-line @lwc/lwc/no-async-operation
    //     setTimeout(() => {
    //         this[msgType] = '';
    //     }, 1000)
    // }
}