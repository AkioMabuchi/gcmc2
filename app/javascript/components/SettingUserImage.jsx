import React from "react"

class SettingUserImage extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            image: this.props.info.image
        };
        window.settingUserImageOnFileChanged = () => {
            this.setState({image: "singleton"});
        };
    }

    render() {
        return (
            <div>
                <div className={"user-image"}>
                    <img src={this.state.image} alt={""}/>
                </div>
            </div>
        );
    }
}

export default SettingUserImage
