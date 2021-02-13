import React from "react"

class SettingWantsForm extends React.Component {
    wantedPositions = {}

    constructor(props) {
        super(props);
        this.props.info.wantedPositions.map((wantedPosition) => {
            this.wantedPositions[wantedPosition.name_id] = {
                id: wantedPosition.id,
                amount: wantedPosition.amount
            };
        });
        if (this.wantedPositions[this.props.info.positions[0].id]) {
            this.state = {
                action: `/settings/${this.props.info.team.permalink}/wants/${this.wantedPositions[this.props.info.positions[0].id].id}`,
                method: "PATCH",
                submit: "更新",
                submitClass: "update",
                minValue: 0,
                isWanted: true,
                defaultAmount: this.wantedPositions[this.props.info.positions[0].id].amount
            };
        } else {
            this.state = {
                action: `/settings/${this.props.info.team.permalink}/wants`,
                method: "POST",
                submit: "追加",
                submitClass: "add",
                minValue: 1,
                isWanted: false,
                defaultAmount: 1
            };
        }

    }

    onChangePositionName(e) {
        if (this.wantedPositions[e.target.value]) {
            this.setState({
                action: `/settings/${this.props.info.team.permalink}/wants/${this.wantedPositions[e.target.value].id}`,
                method: "PATCH",
                submit: "更新",
                submitClass: "update",
                minValue: 0,
                isWanted: true
            }, () => {
                document.getElementById("wanted-position-amount").value = this.wantedPositions[e.target.value].amount;
            });
        } else {
            this.setState({
                action: `/settings/${this.props.info.team.permalink}/wants`,
                method: "POST",
                submit: "追加",
                submitClass: "add",
                minValue: 1,
                isWanted: false
            }, () => {
                document.getElementById("wanted-position-amount").value = 1;
            });
        }
    }

    onChangeAmount(e) {
        console.log(e.target.value);
        if (this.state.isWanted) {
            if (e.target.value === "0") {
                this.setState({
                    method: "DELETE",
                    submit: "削除",
                    submitClass: "delete",
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
        let positions;

        if (this.props.info.wantedPositions.length > 0) {
            positions = (
                <ul>
                    {
                        this.props.info.wantedPositions.map((wantedPosition) => {
                            return (
                                <li>
                                    <div className={"wanted-position"}>
                                        <div className={"wanted-position-name"}>
                                            {wantedPosition.name}
                                        </div>
                                        <div className={"wanted-position-amount"}>
                                            {wantedPosition.amount}名
                                        </div>
                                    </div>
                                </li>
                            )
                        })
                    }
                </ul>
            );
        } else {
            positions = (
                <div className={"nothing"}>
                    現在、募集ポジションはありません
                </div>
            );
        }
        return (
            <form action={this.state.action} method={"POST"}
                  className={"general-form team-setting-form wants-form"}>
                <input type={"hidden"} name={"authenticity_token"} value={this.props.info.authenticityToken}/>
                <input type={"hidden"} name={"_method"} value={this.state.method}/>
                <input type={"hidden"} name={"wanted_position[team_id]"} value={this.props.info.team.id}/>
                <h3>募集ポジション設定</h3>
                <div className={"positions"}>
                    <h4>現在の募集ポジション一覧</h4>
                    {positions}
                </div>
                <div className={"field"}>
                    <h4>募集ポジション</h4>
                    <div className={"select-field"}>
                        <select name={"wanted_position[name_id]"} defaultValue={this.props.info.positions[0].id}
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
                <div className={"field"}>
                    <h4>人数<small>（0~99）</small></h4>
                    <input type={"number"} name={"wanted_position[amount]"} max={99} min={this.state.minValue}
                           onChange={(e) => {
                               this.onChangeAmount(e)
                           }} id={"wanted-position-amount"} defaultValue={this.state.defaultAmount}/>
                    <div className={"explanation"}>
                        削除したい場合は「0」を入力してください
                    </div>
                </div>
                <div className={"actions"}>
                    <input type={"submit"} value={this.state.submit} className={this.state.submitClass}/>
                </div>
            </form>
        )
    }
}

export default SettingWantsForm
