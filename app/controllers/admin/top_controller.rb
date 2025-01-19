class Admin::TopController < ApplicationController
  before_action :require_admin

  def index
  end
end
