class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all.reverse
    @current_game = Game.last
  end

  # GET /games/1
  # GET /games/1.json
  def show

  end

  def score
    @game= Game.find(params[:id])
    if params[:player] == "one"
      @game.score_one += params[:value].to_i
    elsif params[:player] == "two"
      @game.score_two += params[:value].to_i
    end
    @game.save
    respond_to do |format|
      format.html { redirect_to edit_game_path }
      format.json { head :no_content }
    end
  end

  # GET /games/new
  def new
    @game = Game.new
    
    
    last_game = Game.last
    if params[:player] == "1"
      @game.player_one = last_game.player_one
      @game.score_one = last_game.score_one
    elsif params[:player] == "2"
      @game.player_one = last_game.player_two
      @game.score_one = last_game.score_two
    end

       


    @game.score_two = 0
  end

  # GET /games/1/edit
  def edit

  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { render action: 'edit', notice: 'Game was successfully created.' }
        format.json { render action: 'show', status: :created, location: @game }
      else
        format.html { render action: 'new' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { render action: 'edit', notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

   def remove_all
    Game.delete_all
    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  def status
    @latest_game = Game.last || Game.create(player_one: "Player 1", player_two: "Player 2", score_one: "0", score_two: "0")
    @leader = get_leader
  end




  def get_leader
    max_one = Game.order("score_one DESC").first
    max_two = Game.order("score_two DESC").first

    if max_one.score_one >= max_two.score_two
      [max_one.player_one, max_one.score_one]
    else
      [max_two.player_two, max_two.score_two]
    end
  end

  def change_points(player,points)
    if player == 1 
      @game.score_one += points.to_i
    elsif player == 2
      @game.score_two += points.to_i
    end
    @game.save
    edit_game_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:player_one, :player_two, :score_one, :score_two)
    end
end
