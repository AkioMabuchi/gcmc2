import React from "react"

class NewTeamImage extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            image: "/NoTeamImage.png"
        };
        window.newTeamImageOnFileChanged = () => {
            let createObjectUrl = (window.URL || window.webkitURL).createObjectURL || window.createObjectURL;
            let input = document.getElementsByName("team[image]")[0];
            let file = input.files[0];
            if (input.value === "") {
                this.setState({image: "/NoTeamImage.png"});
            } else {
                let fileNameRegExp = /\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF)$/;
                if (!(file.type.match("image.*"))) {
                    alert("画像ファイルをアップロードしてください");
                    this.setState({image: "/NoTeamImage.png"});
                    input.value = "";
                } else if (!(fileNameRegExp.test(file.name))) {
                    alert("gif、png、jpgのいずれかのファイルをアップロードしてください");
                    this.setState({image: "/NoTeamImage.png"});
                    input.value = "";
                } else if (file.size > 4194304) {
                    alert("4MB以内の画像ファイルをアップロードしてください");
                    this.setState({image: "/NoTeamImage.png"});
                    input.value = "";
                } else {
                    this.setState({image: createObjectUrl(file)});
                }
            }
        };
    }

    render() {
        return (
            <div className={"team-image"}>
                <img src={this.state.image} alt={""}/>
            </div>
        );
    }
}

export default NewTeamImage
