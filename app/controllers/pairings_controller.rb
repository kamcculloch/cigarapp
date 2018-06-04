class PairingsController < ApplicationController
  before_action :current_user_must_be_pairing_user, :only => [:edit, :update, :destroy]

  def current_user_must_be_pairing_user
    pairing = Pairing.find(params[:id])

    unless current_user == pairing.user
      redirect_to :back, :alert => "You are not authorized for that."
    end
  end

  def index
    @pairings = Pairing.all

    render("pairings/index.html.erb")
  end

  def show
    @pairing = Pairing.find(params[:id])

    render("pairings/show.html.erb")
  end

  def new
    @pairing = Pairing.new

    render("pairings/new.html.erb")
  end

  def create
    @pairing = Pairing.new

    @pairing.alcohol_id = params[:alcohol_id]
    @pairing.cigar_id = params[:cigar_id]
    @pairing.user_id = params[:user_id]

    save_status = @pairing.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/pairings/new", "/create_pairing"
        redirect_to("/pairings")
      else
        redirect_back(:fallback_location => "/", :notice => "Pairing created successfully.")
      end
    else
      render("pairings/new.html.erb")
    end
  end

  def edit
    @pairing = Pairing.find(params[:id])

    render("pairings/edit.html.erb")
  end

  def update
    @pairing = Pairing.find(params[:id])

    @pairing.alcohol_id = params[:alcohol_id]
    @pairing.cigar_id = params[:cigar_id]
    @pairing.user_id = params[:user_id]

    save_status = @pairing.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/pairings/#{@pairing.id}/edit", "/update_pairing"
        redirect_to("/pairings/#{@pairing.id}", :notice => "Pairing updated successfully.")
      else
        redirect_back(:fallback_location => "/", :notice => "Pairing updated successfully.")
      end
    else
      render("pairings/edit.html.erb")
    end
  end

  def destroy
    @pairing = Pairing.find(params[:id])

    @pairing.destroy

    if URI(request.referer).path == "/pairings/#{@pairing.id}"
      redirect_to("/", :notice => "Pairing deleted.")
    else
      redirect_back(:fallback_location => "/", :notice => "Pairing deleted.")
    end
  end
end
