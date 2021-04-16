import consumer from "../channels/consumer"
import React from "react"

class Message extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            messages: this.props.info.messages
        };
        window.onUpdateMessage = (data) => {
            let rawMessage = data.message;
            if(rawMessage.userId === this.props.info.receiverUser.id) {
                let message = [
                    {
                        image: rawMessage.image,
                        name: rawMessage.name,
                        date: rawMessage.date,
                        content: rawMessage.content
                    }
                ];

                fetch(`/messages/${rawMessage.id}/read`,{
                    method: "PATCH",
                    body: JSON.stringify({
                        authenticity_token: this.props.info.authenticityToken
                    }),
                    headers:{
                        "Content-Type": "application/json"
                    }
                }).then((response)=>{
                    return response.json();
                }).then((result)=>{

                })
                this.setState({messages: message.concat(this.state.messages)});
            }
        }
    }

    componentDidMount() {
        let messageChannel = consumer.subscriptions.create({
            channel: "MessageChannel",
            room: this.props.info.senderUser.id
        }, {
            received(data) {
                window.onUpdateMessage(data);
            }
        });
    }

    sendMessage(e) {
        let content = document.getElementsByName("message[content]")[0].value;
        fetch("/messages", {
            method: "POST",
            body: JSON.stringify({
                authenticity_token: this.props.info.authenticityToken,
                message: {
                    sender_user_id: this.props.info.senderUser.id,
                    receiver_user_id: this.props.info.receiverUser.id,
                    content: content
                }
            }),
            headers: {
                "Content-Type": "application/json"
            }
        }).then((response) => {
            return response.json();
        }).then((result) => {
            if (result.status) {
                let rawMessage = result.message;
                let message = [
                    {
                        image: rawMessage.image,
                        name: rawMessage.name,
                        date: rawMessage.date,
                        content: rawMessage.content
                    }
                ];
                this.setState({messages: message.concat(this.state.messages)},()=>{
                    document.getElementsByName("message[content]")[0].value = "";
                });
            } else {
                alert(result.messages.content);
            }
        });
    }

    render() {
        return (
            <div className={"messages"}>
                <form>
                    <h4>送信先ユーザー</h4>
                    <div className={"user-image-name"}>
                        <div className={"user-image"}>
                            <a href={`/users/${this.props.info.receiverUser.permalink}`}>
                                <img src={this.props.info.receiverUser.image} alt={""}/>
                            </a>
                        </div>
                        <div className={"user-name"}>
                            <a href={`/users/${this.props.info.receiverUser.permalink}`}>
                                {this.props.info.receiverUser.name}
                            </a>
                        </div>
                    </div>
                    <h4>メッセージ内容<small>（240字以内）</small></h4>
                    <textarea name={"message[content]"}/>
                    <button type={"button"} onClick={(e) => {
                        this.sendMessage(e)
                    }}>
                        送信
                    </button>
                </form>
                <ul>
                    {
                        this.state.messages.map((message) => {
                            return (
                                <li>
                                    <div className={"message-header"}>
                                        <div className={"message-image"}>
                                            <img src={message.image} alt={""}/>
                                        </div>
                                        <div className={"message-name"}>
                                            {message.name}
                                        </div>
                                        <div className={"message-date"}>
                                            {message.date}
                                        </div>
                                    </div>
                                    <div className={"message-content"}>
                                        {message.content}
                                    </div>
                                </li>
                            );
                        })
                    }
                </ul>
            </div>
        );
    }
}

export default Message
