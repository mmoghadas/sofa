class WatchdogsController < ApplicationController
  before_action :set_watchdog, only: [:show, :edit, :update, :destroy]

  # GET /watchdogs
  # GET /watchdogs.json
  def index
    @watchdogs = Watchdog.all
  end

  # GET /watchdogs/1
  # GET /watchdogs/1.json
  def show
  end

  # GET /watchdogs/new
  def new
    @watchdog = Watchdog.new
  end

  # GET /watchdogs/1/edit
  def edit
  end

  # POST /watchdogs
  # POST /watchdogs.json
  def create
    @watchdog = Watchdog.new(watchdog_params)

    respond_to do |format|
      if @watchdog.save
        format.html { redirect_to @watchdog, notice: 'Watchdog was successfully created.' }
        format.json { render :show, status: :created, location: @watchdog }
      else
        format.html { render :new }
        format.json { render json: @watchdog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /watchdogs/1
  # PATCH/PUT /watchdogs/1.json
  def update
    respond_to do |format|
      if @watchdog.update(watchdog_params)
        format.html { redirect_to @watchdog, notice: 'Watchdog was successfully updated.' }
        format.json { render :show, status: :ok, location: @watchdog }
      else
        format.html { render :edit }
        format.json { render json: @watchdog.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_state
    name = params['name']
    state = params['state']

    Watchdog.where(name: name).find_and_modify({ "$set" => { state: state }}, upsert: true)

    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end

  # DELETE /watchdogs/1
  # DELETE /watchdogs/1.json
  def destroy
    @watchdog.destroy
    respond_to do |format|
      format.html { redirect_to watchdogs_url, notice: 'Watchdog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_state
    if params['name']
      get_service_health
    else
      get_all_health_status
    end
  end

  def get_service_health
    name = params['name']
    data = Watchdog.where(name: name).first
    result = "#{data[:name]} : #{data[:state]}"
    render json: result
  end

  def get_all_health_status
    result = "you need to pass parameter 'name'"
    render json: result
  end

  def get_healthy
    display('healthy')
  end

  def get_unhealthy
    display('unhealthy')
  end

  def display(state)
    data = Watchdog.where(state: /#{state}/i)
    results = data.map{|r| "#{r[:name]} : #{r[:state]}"}
    results.insert(0, results.count)
    render json: results
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_watchdog
      @watchdog = Watchdog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def watchdog_params
      params.require(:watchdog).permit(:name, :state)
    end
end
