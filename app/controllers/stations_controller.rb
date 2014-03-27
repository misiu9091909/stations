class StationsController < ApplicationController
  before_action :set_station, only: [:show, :edit, :update, :destroy]



  # GET /stations
  # GET /stations.json
  def index
    if params[:brand_id]
      @brand = Brand.find_by_id(params[:brand_id])
      @prices = @brand.prices
      @types = @prices.pluck(:fuel_type).uniq.sort


      render 'show_stations_prices'
    else
      @stations = Station.all
    end
  end

  # GET /stations/1
  # GET /stations/1.json
  def show
    @stations = Station.all
    @my_location = my_location
    @types = @station.prices.pluck(:fuel_type).uniq.sort
    @hash = Gmaps4rails.build_markers(@stations) do |station, marker|
      marker.lat station[0]
      marker.lng station[1]
    end
  end

  def show_nearest_stations
    @site = [51.1, 17.03]
    @range = params[:range]
    @nearest_stations = Station.within(@range, :origin => @site)

    @types = []
    if @nearest_stations
      @types = all_types.uniq.sort
    end

    @nearest_stations = []
    @nearest_stations.each do |station|
      @nearest_stations << [station.latitude, station.longitude, "#{station.name}, #{station.address}, #{station.city}"]
    end

    @hash = Gmaps4rails.build_markers(@nearest_stations) do |station, marker|
      marker.lat station[0]
      marker.lng station[1]
    end

  end



  def show_nearest_stations_dev
    @my_location = my_location
    @fuel_type = params[:fuel_type]
    @types_list = all_types
    @range = params[:range]
    if @fuel_type == "all"
      @nearest_stations = Station.joins(:prices).where("price > ?", 1).within(@range, :origin => my_location).uniq
    else
      @nearest_stations = Station.joins(:prices).where("price > ? and fuel_type = ?", 1, @fuel_type).within(@range, :origin => my_location)
    end

    if @fuel_type == 'all'
      @types_show = @all_types
    else
      @types_show = []
      @types_show << @fuel_type
    end


    @sites_list = Gmaps4rails.build_markers(@nearest_stations) do |station, marker|
      marker.lat station['latitude']
      marker.lng station['longitude']

      if @fuel_type == 'all'
        marker.title station['name']
      else
        marker.title "#{station['name']}, #{@fuel_price} "
      end


            @infowindow_text = "#{station['name']}, #{station['address']}, #{station['city']}"
      fuel = station.prices.find_by(fuel_type: @fuel_type)
      @fuel_price = fuel.price if fuel and fuel !=0

      @all_types.each do |type|
        fuel = station.prices.find_by(fuel_type: type)
        @infowindow_text << " - #{fuel.fuel_type}: #{fuel.price}" if fuel and fuel != 0
      end

      marker.infowindow @infowindow_text

    end

  end




  # GET /stations/new
  def new
    @station = Station.new
  end

  # GET /stations/1/edit
  def edit
  end

  # POST /stations
  # POST /stations.json
  def create
    @station = Station.new(station_params)

    respond_to do |format|
      if @station.save
        format.html { redirect_to @station, notice: 'Station was successfully created.' }
        format.json { render action: 'show', status: :created, location: @station }
      else
        format.html { render action: 'new' }
        format.json { render json: @station.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stations/1
  # PATCH/PUT /stations/1.json
  def update
    respond_to do |format|
      if @station.update(station_params)
        format.html { redirect_to @station, notice: 'Station was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @station.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stations/1
  # DELETE /stations/1.json
  def destroy
    @station.destroy
    respond_to do |format|
      format.html { redirect_to stations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_station
      @station = Station.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def station_params
      params.require(:station).permit(:name, :address, :city, :longitude, :latitude, :brand_id)
    end

    def my_location
      lat = request.cookies['lat']
      lng = request.cookies['lon']
      my_location = [lat, lng]
    end

    def all_types
      @all_types = []
      @stations = Station.all

      @stations.each do |station|
        station.prices.each do |price|
          @all_types << price['fuel_type']
        end
      end
      @all_types = @all_types.uniq.sort
    end

end
