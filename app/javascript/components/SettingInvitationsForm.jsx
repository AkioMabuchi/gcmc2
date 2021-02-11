import React from "react"

class SettingInvitationsForm extends React.Component {
    positions = {}

    constructor(props) {
        super(props);
        this.props.info.invitations.map((invitation) => {
            this.positions[invitation.name_id] = invitation.id;
        });
        if (this.positions[this.props.info.positions[0].id]) {
            this.state = {
                action: `/settings/invitations/${this.positions[this.props.info.positions[0].id]}`,
                method: "DELETE",
                submit: "削除",
                submitClass: "delete"
            }
        } else {
            this.state = {
                action: "/settings/invitations",
                method: "POST",
                submit: "追加",
                submitClass: "add"
            }
        }
    }

    onChangePositionName(e) {
        if (this.positions[e.target.value]) {
            this.setState({
                action: `/settings/invitations/${this.positions[e.target.value]}`,
                method: "DELETE",
                submit: "削除",
                submitClass: "delete"
            });
        } else {
            this.setState({
                action: "/settings/invitations",
                method: "POST",
                submit: "追加",
                submitClass: "add"
            });
        }
    }

    render() {
        let positions;

        if (this.props.info.invitations.length > 0) {
            positions = (
                <ul>
                    {
                        this.props.info.invitations.map((invitation) => {
                            return (
                                <li>
                                    {invitation.name}
                                </li>
                            );
                        })
                    }
                </ul>
            );
        } else {
            positions = (
                <div className={"nothing"}>
                    現在、招待ポジションはありません
                </div>
            );
        }

        return (
            <form action={this.state.action} method={"POST"}
                  className={"general-form user-setting-form invitations-form"}>
                <input type={"hidden"} name={"authenticity_token"} value={this.props.info.authenticityToken}/>
                <input type={"hidden"} name={"_method"} value={this.state.method}/>
                <input type={"hidden"} name={"position[user_id]"} value={this.props.info.userId}/>
                <h3>招待設定</h3>
                <div className={"positions"}>
                    <h4>現在の招待ポジション</h4>
                    {positions}
                </div>
                <div className={"field"}>
                    <h4>招待ポジション</h4>
                    <div className={"select-field"}>
                        <select name={"position[name_id]"} defaultValue={this.props.info.positions[0].id}
                                onChange={(e) => {
                                    this.onChangePositionName(e)
                                }}>
                            {
                                this.props.info.positions.map((position) => {
                                    return (
                                        <option value={position.id}>
                                            {position.name}
                                        </option>
                                    );
                                })
                            }
                        </select>
                    </div>
                </div>
                <div className={"description"}>
                    どのポジションにも招待されたくない場合は、上記にあるポジションを選択して、全て削除してください
                </div>
                <div className={"actions"}>
                    <input type={"submit"} value={this.state.submit} className={this.state.submitClass}/>
                </div>
            </form>
        );
    }
}

export default SettingInvitationsForm
