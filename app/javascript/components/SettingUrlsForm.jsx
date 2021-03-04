import React from "react"

class SettingUrlsForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            action: `/teams/${this.props.info.team.permalink}/settings/urls`,
            method: "POST",
            submit: "追加",
            submitClass: "create",
            selectedUrlId: 0
        };
    }

    onClickUrlName(id, name, url, isPublic) {
        let urlId;
        if (this.state.selectedUrlId === id) {
            urlId = 0;
        } else {
            urlId = id;
        }
        this.setState({selectedUrlId: urlId}, () => {
            if (this.state.selectedUrlId === 0) {
                document.getElementsByName("team_url[name]")[0].value = "";
                document.getElementsByName("team_url[url]")[0].value = "";
                document.getElementsByName("team_url[is_public]")[0].checked = true;
                this.setState({
                    action: `/teams/${this.props.info.team.permalink}/settings/urls/`,
                    method: "POST",
                    submit: "追加",
                    submitClass: "create"
                });
            } else {
                document.getElementsByName("team_url[name]")[0].value = name;
                document.getElementsByName("team_url[url]")[0].value = url;
                if (isPublic) {
                    document.getElementsByName("team_url[is_public]")[0].checked = true;
                } else {
                    document.getElementsByName("team_url[is_public]")[1].checked = true;
                }
                this.setState({
                    action: `/teams/${this.props.info.team.permalink}/settings/urls/${id}`,
                    method: "PATCH",
                    submit: "更新",
                    submitClass: "update"
                });
            }
        });
    }

    onChangeUrlUrl(e) {
        if(this.state.selectedUrlId!==0) {
            if (e.target.value === "") {
                this.setState({
                    method: "DELETE",
                    submit: "削除",
                    submitClass: "destroy"
                });
            } else {
                this.setState({
                    method: "PATCH",
                    submit: "更新",
                    submitClass: "update"
                });
            }
        }
    }

    render() {
        let urls;

        if (this.props.info.team.urls.length > 0) {
            urls = (
                <ul>
                    {
                        this.props.info.team.urls.map((url) => {
                            let className;
                            if (this.state.selectedUrlId === url.id) {
                                className = "url-name selected";
                            } else {
                                className = "url-name";
                            }
                            let isPublic = url.is_public ? "（一般公開）" : "（メンバー限定公開）";
                            return (
                                <li>
                                    <button type={"button"} className={className} onClick={() => {
                                        this.onClickUrlName(url.id, url.name, url.url, url.is_public)
                                    }}>
                                        {url.name}
                                    </button>
                                    <span className={"url-public"}>{isPublic}</span>
                                    <div className={"url-url"}>
                                        {url.url}
                                    </div>
                                </li>
                            );
                        })
                    }
                </ul>
            );
        } else {
            urls = (
                <div className={"nothing"}>
                    現在、外部リンクは存在しません
                </div>
            );
        }

        return (
            <form action={this.state.action} method={"POST"}
                  className={"general-form team-setting-form urls-form"}>
                <input type={"hidden"} name={"authenticity_token"} value={this.props.info.authenticityToken}/>
                <input type={"hidden"} name={"_method"} value={this.state.method}/>
                <input type={"hidden"} name={"team_url[team_id]"} value={this.props.info.team.id}/>
                <h3>外部リンク設定</h3>
                <div className={"urls"}>
                    <h4>現在の外部リンク</h4>
                    {urls}
                </div>
                <div className={"field"}>
                    <h4>リンク名<small>（必須）</small></h4>
                    <input type={"text"} name={"team_url[name]"}/>
                </div>
                <div className={"field"}>
                    <h4>URL</h4>
                    <input type={"url"} name={"team_url[url]"} onChange={(e) => {
                        this.onChangeUrlUrl(e);
                    }}/>
                </div>
                <div className={"field"}>
                    <h4>公開</h4>
                    <div className={"radio-buttons"}>
                        <input type={"radio"} name={"team_url[is_public]"} value={true} defaultChecked={true}/>
                        <span className={"radio-name"}>一般公開</span>
                        <input type={"radio"} name={"team_url[is_public]"} value={false}/>
                        <span className={"radio-name"}>メンバー限定公開</span>
                    </div>
                </div>
                <div className={"description"}>
                    既存のリンク情報を更新、削除するには、上記のリストにあるリンク名をクリックしてください。
                    また、削除する場合は、URLを空欄にしてください。
                </div>
                <div className={"actions"}>
                    <input type={"submit"} value={this.state.submit} className={this.state.submitClass}/>
                </div>
            </form>
        );
    }
}

export default SettingUrlsForm
