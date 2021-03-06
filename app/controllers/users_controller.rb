require 'steam-condenser'

class UsersController < ApplicationController
  def search
    redirect_to action: :show, controller: 'users', id: params[:id]
  end

  def show
  	if params[:id]
      	search = params[:id].gsub(' ', '+')
      	# @user = SteamId.resolve_vanity_url(search)

        # steam_id = SteamId.resolve_vanity_url(search)

        # WebApi.api_key = "210A1FCA770E55BDE2E4C8950A2B873B"
        # output = WebApi.json! 'ISteamUser', 'GetOwnedGames', 1, { :steamids => steam_id.to_s}
        @user_name = search.gsub('+', ' ')
        @user = SteamId.new(search) 
        @nickname= @user.nickname
        @played_times = @user.games.map do |key, game|
          {name: game.name,
           play_time: @user.total_playtime(key)
          }
        end
        @played_times = @played_times.sort_by do |game|
          game[:play_time]
        end.reverse
    else
      nil
  	end	
    rescue SteamCondenserError 
      flash[:alert] = "User could not be found, or has profile set to private."
      redirect_to index
  end

  def index
    @nickname = ""
  end

end
 # <%= image_tag("http://media.steampowered.com/steamcommunity/public/images/apps/#{game.app_id}/#{game.logo_hash}.jpg") %>