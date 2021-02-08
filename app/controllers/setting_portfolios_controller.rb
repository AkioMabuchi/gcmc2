class SettingPortfoliosController < ApplicationController
  def index
    @portfolio = Portfolio.new
  end

  def show
    portfolio = Portfolio.find(params[:id])
    @react_info = {
        authenticityToken: form_authenticity_token,
        id: portfolio.id,
        name: portfolio.name,
        image: portfolio.image.url,
        period: portfolio.period,
        description: portfolio.description,
        url: portfolio.url
    }
  end

  def create
    portfolio = Portfolio.new(portfolio_params)
    if portfolio.save
      redirect_to setting_portfolios_path, notice: "ポートフォリオを追加しました"
    else
      redirect_to setting_portfolios_path
    end
  end

  def update
    portfolio = Portfolio.find(params[:id])
    portfolio.update portfolio_params
    portfolio.save!
    redirect_to setting_portfolio_path(params[:id]), notice: "ポートフォリオを更新しました"
  end

  def destroy
    portfolio = Portfolio.find(params[:id])
    portfolio.destroy!
    redirect_to setting_portfolios_path, notice: "ポートフォリオを削除しました"
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:user_id, :name, :image, :period, :description, :url)
  end
end
