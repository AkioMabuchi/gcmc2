class SettingSkillsController < ApplicationController
  def index
    @react_info = {
      authenticityToken: form_authenticity_token,
      userId: current_user.id,
      skills: current_user.skills.select(:id, :name, :level),
      nameWarning: flash[:skill_name_warning],
      levelWarning: flash[:skill_level_warning]
    }
  end

  def create
    skill = Skill.new(skill_params)
    if skill.save
      redirect_to setting_skills_path, notice: "スキルセットに追加しました"
    else
      if skill.errors.messages[:name]
        flash[:skill_name_warning] = skill.errors.messages[:name][0]
      end
      if skill.errors.messages[:level]
        flash[:skill_level_warning] = skill.errors.messages[:level][0]
      end
      redirect_to setting_skills_path
    end
  end

  def update
    skill = Skill.find(params[:id])
    skill.update skill_params
    if skill.save
      redirect_to setting_skills_path, notice: "スキルセットを更新しました"
    else
      if skill.errors.messages[:name]
        flash[:skill_name_warning] = skill.errors.messages[:name][0]
      end
      if skill.errors.messages[:level]
        flash[:skill_level_warning] = skill.errors.messages[:level][0]
      end
      redirect_to setting_skills_path
    end
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
