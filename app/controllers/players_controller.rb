class PlayersController < ApplicationController
  def index
    @players = Player.all.order("id DESC")
  end

  def new
    @player = Player.new
    
    @player.player_no = params[:player_no].to_i


    @player.score = 0
  end

  def create

    @player = Player.new(player_params)

    

    respond_to do |format|
      if @player.save
        format.html { redirect_to update_scores_players_path }
        remove_player_no(@player.player_no)
      else
        format.html { render action: 'new' }
      end
    end
  end

	def status
    create_sample_players(0)
    @player_one = Player.where(:player_no => 1).last
    @player_two = Player.where(:player_no => 2).last
    @leader = Player.order("score DESC").first
    
  end

  def update_scores
    max_id = Player.maximum(:id)
    create_sample_players(max_id)
    @player_one = Player.where(:player_no => 1).last
    @player_two = Player.where(:player_no => 2).last
  end


  def score
    @player = Player.find(params[:id])
    @player.score += params[:value].to_i
    @player.save
    respond_to do |format|
      format.html { redirect_to update_scores_players_path }
    end
  end
  def update
    @player = Player.find(params[:id])
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to update_scores_players_path }
      else
        format.html { render action: 'edit' }
      end
    end

  end

  def edit
    @player = Player.find(params[:id])

  end

  def remove_player_no(player_no)
    @old_player = Player.where(player_no: player_no).first
    @old_player.player_no = nil
    @old_player.save

  end

  def assign_player_no
    @player_no = params[:player_no].to_i
    @player = Player.find(params[:id])
    if @player.player_no == nil
      remove_player_no(@player_no)
      @player.player_no = @player_no
      @player.save
    elsif @player.player_no != @player_no
      @old_player = Player.where(player_no: @player_no).first
      @old_player.player_no = @player.player_no
      @old_player.save
      @player.player_no = @player_no
      @player.save
    end
    respond_to do |format|
      format.html { redirect_to players_url }
    end
  end

  def destroy
    max_id = Player.maximum(:id)
    Player.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to players_url }
    end
    create_sample_players(max_id)
  end
    

  def remove_all
    Player.delete_all
    Player.reset_pk_sequence
    create_sample_players(0)
    respond_to do |format|
      format.html { redirect_to players_url }
    end

  end

  def create_sample_player(x,max_id)
    Player.create(name: "Player #{max_id + 1}", score: 0, player_no: x)
  end

  def create_sample_players(max_id)
    i = 0
    [1,2].each do |y|
      if Player.where(player_no: y).first == nil
        create_sample_player(y,max_id + i)
        i += 1
      end
    end
  end



  private
    def player_params
      params.require(:player).permit(:name, :score, :player_no)
    end

end
