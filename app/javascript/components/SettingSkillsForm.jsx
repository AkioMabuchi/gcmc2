import React, {Fragment} from "react"

class SettingSkillsForm extends React.Component {
    skills = {}

    constructor(props) {
        super(props);
        this.state = {
            action: "/settings/skills",
            method: "POST",
            submit: "追加",
            selectedSkillId: 0,
            isLevelBlank: true
        };
        this.props.info.skills.map((skill) => {
            this.skills[skill.name] = skill.id;
        });
    }

    onClickButtonName(id, name, level) {
        document.getElementById("skill-name").value = name;
        document.getElementById("skill-level").value = level;
        this.setState({selectedSkillId: id, isLevelBlank: false}, () => {
            this.changeActionMethod();
        });
    }

    onChangeInputFieldName(e) {
        let selectedSkillId = 0;
        if (this.skills[e.target.value]) {
            selectedSkillId = this.skills[e.target.value];
        }
        this.setState({selectedSkillId: selectedSkillId}, () => {
            this.changeActionMethod();
        });
    }

    onChangeInputFieldLevel(e) {
        let isLevelBlank = e.target.value === "";
        this.setState({isLevelBlank: isLevelBlank}, () => {
            this.changeActionMethod();
        });
    }

    changeActionMethod() {
        if (this.state.selectedSkillId === 0) {
            this.setState({action: "/settings/skills", method: "POST"});
        } else if (this.state.isLevelBlank) {
            this.setState({action: `/settings/skills/${this.state.selectedSkillId}`, method: "DELETE"});
        } else {
            this.setState({action: `/settings/skills/${this.state.selectedSkillId}`, method: "PATCH"});
        }
    }

    render() {
        return (
            <form action={this.state.action} method={"POST"}
                  className={"general-form user-setting-form skills-form"}>
                <input type={"hidden"} name={"authenticity_token"} value={this.props.info.authenticityToken}/>
                <input type={"hidden"} name={"_method"} value={this.state.method}/>
                <input type={"hidden"} name={"skill[user_id]"} value={this.props.info.userId}/>
                <h3>スキルセット設定</h3>
                <div className={"skills"}>
                    <h4>現在のスキルセット</h4>
                    <ul>
                        {
                            this.props.info.skills.map((skill) => {
                                return (
                                    <li>
                                        <button type={"button"} onClick={() => {
                                            this.onClickButtonName(skill.id, skill.name, skill.level)
                                        }}>
                                            {skill.name}
                                        </button>
                                        <div className={"level"}>
                                            {skill.level}
                                        </div>
                                    </li>
                                );
                            })
                        }
                    </ul>
                </div>
                <div className={"field"}>
                    <h4>スキル名<small>（必須）</small></h4>
                    <input type={"text"} name={"skill[name]"} placeholder={"例）C#、Photoshop"} onChange={(e) => {
                        this.onChangeInputFieldName(e)
                    }} id={"skill-name"}/>
                </div>
                <div className={"field"}>
                    <h4>レベル</h4>
                    <input type={"text"} name={"skill[level]"} placeholder={"例）初級レベル、実務経験1年"} onChange={(e) => {
                        this.onChangeInputFieldLevel(e)
                    }} id={"skill-level"}/>
                </div>
                <div className={"actions"}>
                    <input type={"submit"} value={this.state.submit}/>
                </div>
            </form>
        );
    }
}

export default SettingSkillsForm
