import React from "react"

class SettingPortfolioForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            method: "PATCH",
            submit: "更新",
            submitClass: "update",
            isFieldDisabled: false,
            image: this.props.info.image
        }
    }

    onChangeDeleteModeCheckBox(e) {
        let value = document.getElementById("delete-mode-check-box").checked;
        if (value) {
            this.setState({method: "DELETE", submit: "削除", submitClass: "delete", isFieldDisabled: true});
        } else {
            this.setState({method: "PATCH", submit: "更新", submitClass: "update", isFieldDisabled: false});
        }
    }

    render() {
        return (
            <form action={`/settings/portfolios/${this.props.info.id}`} method={"POST"}
                  className={"general-form user-setting-form portfolio-form"} encType={"multipart/form-data"}>
                <input type={"hidden"} name={"authenticity_token"} value={this.props.info.authenticityToken}/>
                <input type={"hidden"} name={"_method"} value={this.state.method}/>
                <h3>ポートフォリオ編集</h3>
                <div>
                    <h4>編集中のポートフォリオ</h4>
                    <div className={"portfolio-image"}>
                        <img src={this.props.info.image} alt={""}/>
                    </div>
                    <div className={"portfolio-name"}>
                        {this.props.info.name}
                    </div>
                    <div>
                        <a href={"/settings/portfolios"}>
                            元に戻る
                        </a>
                    </div>
                </div>
                <div className={"field"}>
                    <h4>ポートフォリオ名<small>（必須）</small></h4>
                    <input type={"text"} name={"portfolio[name]"} defaultValue={this.props.info.name}
                           disabled={this.state.isFieldDisabled}/>
                </div>
                <div className={"field"}>
                    <h4>ポートフォリオ画像</h4>
                    <h5>2MB以内のgif、png、jpgファイル<br/>600x315推奨</h5>
                    <div>
                        <div className={"portfolio-image"}>
                            <img src={this.state.image} alt={""}/>
                        </div>
                    </div>
                    <input type={"file"} name={"portfolio[image]"} disabled={this.state.isFieldDisabled}/>
                </div>
                <div className={"field"}>
                    <h4>制作期間</h4>
                    <input type={"text"} name={"portfolio[period]"} defaultValue={this.props.info.period}
                           disabled={this.state.isFieldDisabled}/>
                </div>
                <div className={"field"}>
                    <h4>ポートフォリオ説明</h4>
                    <textarea name={"portfolio[description]"} defaultValue={this.props.info.description}
                              disabled={this.state.isFieldDisabled}/>
                </div>
                <div className={"field"}>
                    <h4>ポートフォリオURL</h4>
                    <input type={"url"} name={"portfolio[url]"} defaultValue={this.props.info.url}
                           disabled={this.state.isFieldDisabled}/>
                </div>
                <div className={"field"}>
                    <input type={"checkbox"} id={"delete-mode-check-box"} onChange={(e) => {
                        this.onChangeDeleteModeCheckBox(e)
                    }}/>ポートフォリオを削除する
                </div>
                <div className={"actions"}>
                    <input type={"submit"} value={this.state.submit} className={this.state.submitClass}/>
                </div>
            </form>
        );
    }
}

export default SettingPortfolioForm
