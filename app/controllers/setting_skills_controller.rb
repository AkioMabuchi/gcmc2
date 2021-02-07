class SettingSkillsController < ApplicationController
  def index
    @react_info = {
        authenticityToken: form_authenticity_token,
        userId: current_user.id,
        skills: current_user.skills.select(:id, :name, :level)
    }
  end

  def create
    skill = Skill.new(skill_params)
    if skill.save
      redirect_to setting_skills_path, notice: "スキルセットに追加しました"
    else
      redirect_to setting_skills_path
    end
  end

  def update
    skill = Skill.find(params[:id])
    skill.update skill_params
    skill.save!
    redirect_to setting_skills_path, notice: "スキルセットを更新しました"
  end

  def destroy
    skill = Skill.find(params[:id])
    skill.destroy!
    redirect_to setting_skills_path, notice: "スキルセットから削除しました"
  end

  private

  def skill_params
    params.require(:skill).permit(:user_id, :name, :level)
  end
end
