class TimelinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_timeline, only: [:show, :edit, :update, :destroy]

  # GET /timelines
  # GET /timelines.json
  def index
    @timelines = current_user.timelines
    shared_ids = SharedTimeline.where(email: current_user.email).pluck(:timeline_id)
    @shared_timelines = Timeline.where(id: shared_ids)
  end

  # GET /timelines/1
  # GET /timelines/1.json
  def show
    @timeline = Timeline.find(params[:id])
    @events = @timeline.events.order(:duedate)
  end

  # GET /timelines/new
  def new
    @timeline = Timeline.new
    @statues = TimelineStatus.all.map { |status| [status.name, status.id] }
  end

  # GET /timelines/1/edit
  def edit
  end

  # POST /timelines
  # POST /timelines.json
  def create
    @timeline = current_user.timelines.build(timeline_params)
    respond_to do |format|
      if @timeline.save
        format.html { redirect_to @timeline, notice: 'Timeline was successfully created.' }
        format.json { render :show, status: :created, location: @timeline }
      else
        format.html { render :new }
        format.json { render json: @timeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /timelines/1
  # PATCH/PUT /timelines/1.json
  def update
    respond_to do |format|
      if @timeline.update(timeline_params)
        format.html { redirect_to @timeline, notice: 'Timeline was successfully updated.' }
        format.json { render :show, status: :ok, location: @timeline }
      else
        format.html { render :edit }
        format.json { render json: @timeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timelines/1
  # DELETE /timelines/1.json
  def destroy
    @timeline.destroy
    respond_to do |format|
      format.html { redirect_to timelines_url, notice: 'Timeline was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timeline
      @timeline = Timeline.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def timeline_params
      params.require(:timeline).permit(:name, :timeline_status_id)
    end
end
