class Api::V1::ShopsController < Api::V1::BaseController  
  before_action :load_place
  
  def index
    shops = @place.shops.where(floor_id: params[:floor_id]).includes(:coordinate)
    json_response :ok, serialize_data(ShopSerializer, shops), I18n.t("actions.success")
  end

  def create
    shop = Shop.find_or_initialize_by name: item_params[:name]
    raise ApiError::RecordNotUnique unless shop.new_record?

    shop.save!
    json_response :ok, serialize_data(ShopSerializer, shop), I18n.t("actions.success")
  end
  
  def show
    json_response :ok, serialize_data(ShopSerializer, @shop), I18n.t("actions.success")
  end

  def update
    shop = Shop.first
    shop.update! update_params
    json_response :ok, serialize_data(ShopSerializer, shop), I18n.t("actions.success")
  end
  
  def destroy
    @shop.destroy
    json_response(:no_content)
  end

  private
  def update_params
    params.permit(Shop::ATTR)
  end

  def load_shop
    @shop = Shop.find(params[:id])
  end

  def filtering_params
    params.permit(Shop::FILTERING_PARAM)
  end

  def load_place
    @place = Place.find(params[:place_id])
  end
end