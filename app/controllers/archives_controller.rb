# coding: utf-8
class ArchivesController < ApplicationController
  # caches_page_for_anonymous :index, :show
  def index
    @start_year = @first.year
    @end_year = @last.year
  end

  DATE_REGEXP = /\A(\d{4})-?(\d{1,2})?-?(\d{1,2})?\z/.freeze
  def show
    @date = params[:id]
    @date.strip!
    @date.chomp!
    match = DATE_REGEXP.match(@date)
    match = match.to_a.collect{|i| i && i.to_i}
    _, @year, @month, @day = match

    if !@month and !@day
      year
    elsif !@day
      month
    else
      day
    end
  end

  protected
  def year
    return show_404 unless @year
    @start_year = @first.year
    @end_year = @last.year
    return show_404 if @year < @start_year or @year > @end_year
    render :year
  end

  def month
    @start_day = Date.civil(@year, @month, 1)
    @end_day = (@start_day >> 1) - 1
    @articles = @scope.hottest.by_period(@start_day, @end_day).page(params[:page])
    render :month
  rescue ArgumentError
    return show_error "无效的日期 #{params[:year]}-#{params[:month]}"
  end

  def day
    @start_day = Date.civil(@year, @month, 1)
    @end_day = (@start_day >> 1) - 1
    @date = Date.civil(@year, @month, @day)
    @articles = @scope.hottest.by_period(@date, @date+1).page(params[:page])

    #fresh_when :last_modified => @date.to_time.utc, :public => true
    render :day
  rescue ArgumentError
    return show_error "无效的日期 #{params[:year]}-#{params[:month]}-#{params[:day]}"
  end

  before_filter :find_scope
  protected

  def find_scope
    @group = Group.wrap(params[:group_id]) unless params[:group_id].blank?
    @user = User.wrap(params[:user_id]) unless params[:user_id].blank?
  end

  def find_border
    if @group
      @scope = @group.public_articles
    elsif @user
      @scope = @user.articles
    else
      return show_404
    end
    @first = @scope.min(:created_at).try(:to_date)
    @last = @scope.max(:created_at).try(:to_date)
    return show_404 unless @first && @last
  end
  before_filter :find_border
end
