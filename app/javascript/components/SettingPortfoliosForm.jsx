import React from "react"

class SettingPortfoliosForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            action: "/settings/portfolios",
            method: "POST",
            submit: "追加",
            submitClass: "create",
            isCheckBoxDisabled: true,
            isFieldDisabled: false,
            selectedId: 0,
            image: "/NoPortfolioImage.png",
            currentImage: "/NoPortfolioImage.png"
        };
    }

    onChangedFileImage(e) {
        let createObjectUrl = (window.URL || window.webkitURL).createObjectURL || window.createObjectURL;
        let input = document.getElementsByName("portfolio[image]")[0];
        let file = input.files[0];
        if (input.value === "") {
            this.setState({image: this.state.currentImage});
        } else {
            let fileNameRegExp = /\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF)$/;
            if (!(file.type.match("image.*"))) {
                alert("画像ファイルをアップロードしてください");
                this.setState({image: this.state.currentImage});
                input.value = "";
            } else if (!(fileNameRegExp.test(file.name))) {
                alert("gif、png、jpgのいずれかのファイルをアップロードしてください");
                this.setState({image: this.state.currentImage});
                input.value = "";
            } else if (file.size > 2097152) {
                alert("2MB以内の画像ファイルをアップロードしてください");
                this.setState({image: this.state.currentImage});
                input.value = "";
            } else {
                this.setState({image: createObjectUrl(file)});
            }
        }
    }

    onClickButtonPortfolio(id, name, image, period, description, url) {
        let portfolioId;
        if (this.state.selectedId === id) {
            portfolioId = 0;
        } else {
            portfolioId = id;
        }
        this.setState({selectedId: portfolioId}, () => {
            if (this.state.selectedId === 0) {
                this.setState({
                    action: "/settings/portfolios",
                    method: "POST",
                    submit: "追加",
                    submitClass: "create",
                    isCheckBoxDisabled: true,
                    isFieldDisabled: false,
                    image: "/NoPortfolioImage.png",
                    currentImage: "/NoPortfolioImage.png"
                });
                document.getElementsByName("portfolio[name]")[0].value = "";
                document.getElementsByName("portfolio[image]")[0].value = "";
                document.getElementsByName("portfolio[period]")[0].value = "";
                document.getElementsByName("portfolio[description]")[0].value = "";
                document.getElementsByName("portfolio[url]")[0].value = "";
                document.getElementById("delete-mode-check-box").checked = false;
            } else {
                this.setState({
                    action: `/settings/portfolios/${this.state.selectedId}`,
                    method: "PATCH",
                    submit: "更新",
                    submitClass: "update",
                    isCheckBoxDisabled: false,
                    isFieldDisabled: false,
                    image: image,
                    currentImage: image
                });
                document.getElementsByName("portfolio[name]")[0].value = name
                document.getElementsByName("portfolio[image]")[0].value = "";
                document.getElementsByName("portfolio[period]")[0].value = period;
                document.getElementsByName("portfolio[description]")[0].value = description;
                document.getElementsByName("portfolio[url]")[0].value = url;
                document.getElementById("delete-mode-check-box").checked = false;
            }
        });
    }

    onChangeDeleteModeCheckBox(e) {
        let value = document.getElementById("delete-mode-check-box").checked;
        if (value) {
            this.setState({
                method: "DELETE",
                submit: "削除",
                submitClass: "destroy",
                isFieldDisabled: true
            });
        } else {
            this.setState({
                method: "PATCH",
                submit: "更新",
                submitClass: "update",
                isFieldDisabled: false
            });
        }
    }

    render() {
        let portfolios;
        let nameWarning;

        if (this.props.info.portfolios.length > 0) {
            portfolios = (
                <ul>
                    {
                        this.props.info.portfolios.map((portfolio) => {
                            let className = "button-portfolio-name";
                            if (this.state.selectedId === portfolio.id) {
                                className = "button-portfolio-name selected";
                            }
                            return (
                                <li>
                                    <div className={"portfolio-image"}>
                                        <button type={"button"} onClick={(e) => {
                                            this.onClickButtonPortfolio(
                                                portfolio.id,
                                                portfolio.name,
                                                portfolio.image.url,
                                                portfolio.period,
                                                portfolio.description,
                                                portfolio.url
                                            )
                                        }}>
                                            <img src={portfolio.image.url} alt={""}/>
                                        </button>
                                    </div>
                                    <div className={"portfolio-name"}>
                                        <button type={"button"} onClick={(e) => {
                                            this.onClickButtonPortfolio(
                                                portfolio.id,
                                                portfolio.name,
                                                portfolio.image.url,
                                                portfolio.period,
                                                portfolio.description,
                                                portfolio.url
                                            )
                                        }} className={className}>
                                            {portfolio.name}
                                        </button>
                                    </div>
                                </li>
                            );
                        })
                    }
                </ul>
            )
        } else {
            portfolios = (
                <div className={"nothing"}>
                    ポートフォリオがありません
                </div>
            );
        }

        if (this.props.info.warnings.name !== null) {
            nameWarning = (
                <div className={"warning"}>
                    {this.props.info.warnings.name}
                </div>
            );
        }

        return (
            <form action={this.state.action} method={"POST"}
                  className={"general-form user-setting-form portfolios-form"} encType={"multipart/form-data"}>
                <input type={"hidden"} name={"authenticity_token"} value={this.props.info.authenticityToken}/>
                <input type={"hidden"} name={"_method"} value={this.state.method}/>
                <input type={"hidden"} name={"portfolio[user_id]"} value={this.props.info.user.id}/>
                <h3>ポートフォリオ設定</h3>
                <div className={"portfolios"}>
                    <h4>現在のポートフォリオ</h4>
                    {portfolios}
                </div>
                <div className={"field"}>
                    <h4>ポートフォリオ名<small>（必須）</small></h4>
                    <input type={"text"} name={"portfolio[name]"} disabled={this.state.isFieldDisabled}/>
                    {nameWarning}
                </div>
                <div className={"field"}>
                    <h4>ポートフォリオ画像</h4>
                    <h5>2MB以内のgif、png、jpgファイル<br/>600x315推奨</h5>
                    <div className={"upload-image"}>
                        <img src={this.state.image} alt={""}/>
                    </div>
                    <input type={"file"} name={"portfolio[image]"} onChange={(e) => {
                        this.onChangedFileImage(e)
                    }} disabled={this.state.isFieldDisabled}/>
                </div>
                <div className={"field"}>
                    <h4>制作期間</h4>
                    <input type={"text"} name={"portfolio[period]"} disabled={this.state.isFieldDisabled}/>
                </div>
                <div className={"field"}>
                    <h4>ポートフォリオ説明</h4>
                    <textarea name={"portfolio[description]"} disabled={this.state.isFieldDisabled}/>
                </div>
                <div className={"field"}>
                    <h4>ポートフォリオURL</h4>
                    <input type={"url"} name={"portfolio[url]"} disabled={this.state.isFieldDisabled}/>
                </div>
                <div className={"description"}>
                    既存のポートフォリオ情報を更新、削除するには、上記のリストにあるポートフォリオの画像もしくは名前をクリックしてください
                </div>
                <div className={"field"}>
                    <input type={"checkbox"} id={"delete-mode-check-box"} onChange={(e) => {
                        this.onChangeDeleteModeCheckBox(e)
                    }} disabled={this.state.isCheckBoxDisabled}/>ポートフォリオを削除する
                </div>
                <div className={"actions"}>
                    <input type={"submit"} value={this.state.submit} className={this.state.submitClass}/>
                </div>
            </form>
        )
    }
}

export default SettingPortfoliosForm
