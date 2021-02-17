import React from "react"

class InviteForm extends React.Component {
    teams = []
    wantedPositions = {}
    positions = {}

    constructor(props) {
        super(props);
        this.props.info.positions.map((position) => {
            this.positions[position.id] = position.name;
        });
        this.props.info.teams.map((team) => {
            let isInvitable = false;
            team.positionIds.map((id) => {
                if (this.positions[id]) {
                    isInvitable = true;
                }
            });
            if (isInvitable) {
                this.teams.push({id: team.id, permalink: team.permalink, name: team.name});
                this.wantedPositions[team.id] = team.positionIds;
            }
        });
        if (this.teams.length > 0) {
            let id = this.teams[0].id;
            let positions = [];
            if (this.wantedPositions[id]) {
                this.wantedPositions[id].map((position) => {
                    if (this.positions[position]) {
                        positions.push(position);
                    }
                });
            }
            this.state = {
                positions: positions
            };
        } else {
            this.state = {
                positions: []
            };
        }
    }

    onChangeSelectTeam(e) {
        let id = e.target.value;
        if (this.wantedPositions[id]) {
            let positions = [];
            this.wantedPositions[id].map((positionId) => {
                if (this.positions[positionId]) {
                    positions.push(positionId);
                }
            });
            this.setState({positions: positions});
        }
    }

    render() {
        return (
            <div className={"invite"}>
                <form action={"/invitations"} method={"POST"} className={"invite-form"}>
                    <input type={"hidden"} name={"authenticity_token"} value={this.props.info.authenticityToken}/>
                    <input type={"hidden"} name={"invitation[user_id"} value={this.props.info.user.id}/>
                    <h3>あなたのチームに招待できます！</h3>
                    <div className={"phrase"}>
                        是非とも{this.props.info.user.name}さんを、あなたのチーム
                        {
                            this.teams.map((team) => {
                                return (
                                    <span>
                                      「<a href={`/teams/${team.permalink}`}>{team.name}</a>」
                                  </span>
                                );
                            })
                        }
                        に招待しよう！
                    </div>
                    <div className={"field"}>
                        <h4>招待したいチーム</h4>
                        <div className={"select-field"}>
                            <select name={"invitation[team_id]"} onChange={(e) => {
                                this.onChangeSelectTeam(e)
                            }}>
                                {
                                    this.teams.map((team) => {
                                        return (
                                            <option value={team.id}>
                                                {team.name}
                                            </option>
                                        );
                                    })
                                }
                            </select>
                        </div>
                    </div>
                    <div className={"field"}>
                        <h4>招待ポジション</h4>
                        <div className={"select-field"}>
                            <select name={"invitation[position_name_id"}>
                                {
                                    this.state.positions.map((position) => {
                                        return (
                                            <option value={position}>
                                                {this.positions[position]}
                                            </option>
                                        );
                                    })
                                }
                            </select>
                        </div>
                    </div>
                    <div className={"actions"}>
                        <input type={"submit"} value={"招待"}/>
                    </div>
                </form>
            </div>
        );
    }
}

export default InviteForm
