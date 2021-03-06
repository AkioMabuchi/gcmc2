import React from "react"

class SettingUserImage extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            image: this.props.info.image,
        };
        window.settingUserImageOnFileChanged = () => {
            let createObjectUrl = (window.URL || window.webkitURL).createObjectURL || window.createObjectURL;
            let input = document.getElementsByName("user[image]")[0];
            let file = input.files[0];
            if (input.value === "") {
                this.setState({image: this.props.info.image});
            } else {
                let fileNameRegExp = /\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF)$/;
                if (!(file.type.match("image.*"))) {
                    alert("画像ファイルをアップロードしてください");
                    this.setState({image: this.props.info.image});
                    input.value = "";
                } else if (!(fileNameRegExp.test(file.name))) {
                    alert("gif、png、jpgのいずれかのファイルをアップロードしてください");
                    this.setState({image: this.props.info.image});
                    input.value = "";
                } else if (file.size > 1048576) {
                    alert("1MB以内の画像ファイルをアップロードしてください");
                    this.setState({image: this.props.info.image});
                    input.value = "";
                } else {
                    this.setState({image: createObjectUrl(file)});
                }
            }
        };
    }

    render() {
        return (
            <div className={"user-image"}>
                <img src={this.state.image} alt={""}/>
            </div>
        );
    }
}

export default SettingUserImage
