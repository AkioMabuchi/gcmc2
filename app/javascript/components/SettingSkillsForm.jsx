import React, {Fragment} from "react"

class SettingSkillsForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            action: "/settings/skills",
            method: "POST",
            submit: "追加",
            submitClass: "create",
            selectedSkillId: 0,
        };
    }

    onClickButtonName(id, name, level) {
        let skillId;
        if (this.state.selectedSkillId === id) {
            skillId = 0;
        } else {
            skillId = id;
        }
        this.setState({selectedSkillId: skillId}, () => {
            if (this.state.selectedSkillId === 0) {
                document.getElementsByName("skill[name]")[0].value = "";
                document.getElementsByName("skill[level]")[0].value = "";
                this.setState({
                    action: "/settings/skills",
                    method: "POST",
                    submit: "追加",
                    submitClass: "create"
                });
            } else {
                document.getElementsByName("skill[name]")[0].value = name;
                document.getElementsByName("skill[level]")[0].value = level;
                this.setState({
                    action: `/settings/skills/${id}`,
                    method: "PATCH",
                    submit: "更新",
                    submitClass: "update"
                });
            }
        });
    }

    onChangeInputFieldLevel(e) {
        if (this.state.selectedSkillId !== 0) {
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
        let skills;
        let nameWarning;
        let levelWarning;

        if (this.props.info.skills.length > 0) {
            skills = (
                <ul>
                    {
                        this.props.info.skills.map((skill) => {
                            let className;
                            if(this.state.selectedSkillId === skill.id){
                                className = "skill-name selected";
                            }else{
                                className = "skill-name";
                            }
                            return (
                                <li>
                                    <button type={"button"} className={className} onClick={() => {
                                        this.onClickButtonName(skill.id, skill.name, skill.level)
                                    }}>
                                        {skill.name}
                                    </button>
                                    <div className={"skill-level"}>
                                        {skill.level}
                                    </div>
                                </li>
                            );
                        })
                    }
                </ul>
            )
        } else {
            skills = (
                <div className={"nothing"}>
                    現在、登録されているスキルはありません
                </div>
            );
        }
        if (this.props.info.nameWarning !== null) {
            nameWarning = (
                <div className={"warning"}>
                    {this.props.info.nameWarning}
                </div>
            );
        }

        if (this.props.info.levelWarning !== null) {
            levelWarning = (
                <div className={"warning"}>
                    {this.props.info.levelWarning}
                </div>
            );
        }

        return (
            <form action={this.state.action} method={"POST"}
                  className={"general-form user-setting-form skills-form"}>
                <input type={"hidden"} name={"authenticity_token"} value={this.props.info.authenticityToken}/>
                <input type={"hidden"} name={"_method"} value={this.state.method}/>
                <input type={"hidden"} name={"skill[user_id]"} value={this.props.info.userId}/>
                <h3>スキルセット設定</h3>
                <div className={"skills"}>
                    <h4>現在のスキルセット</h4>
                    {skills}
                </div>
                <div className={"field"}>
                    <h4>スキル名<small>（必須）</small></h4>
                    <input type={"text"} name={"skill[name]"} placeholder={"例）C#、Photoshop"}/>
                    {nameWarning}
                </div>
                <div className={"field"}>
                    <h4>レベル</h4>
                    <input type={"text"} name={"skill[level]"} placeholder={"例）初級レベル、実務経験1年"} onChange={(e) => {
                        this.onChangeInputFieldLevel(e)
                    }}/>
                    {levelWarning}
                </div>
                <div className={"description"}>
                    既存のスキル情報を更新、削除するには、上記のリストにあるスキル名をクリックしてください。
                    また、削除する場合は、レベルを空欄にしてください。
                </div>
                <div className={"actions"}>
                    <input type={"submit"} value={this.state.submit} className={this.state.submitClass}/>
                </div>
            </form>
        );
    }
}

export default SettingSkillsForm
