class CompaniesController < ApiController
  before_action :authenticate_user!
  before_action :set_pagination
  before_action :set_company, only: %i[ show update destroy ]


  # GET /companies
  def index
    @companies = current_user.companies.page(@page).per(@per_page)

    render json: @companies
  end

  # GET /companies/1
  def show
    render json: @company
  end

  # POST /companies
  def create
    @company = Company.new(company_params.merge(user_id: current_user.id))

    if @company.save
      render json: @company, status: :created, location: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      render json: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/1
  def destroy
    @company.destroy
    render json: "Company deleted succesfully", status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      # @company = Company.find(params[:id])
      @company = current_user.companies.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: e.message, status: 401
    end

    # Only allow a list of trusted parameters through.
    def company_params
      params.require(:company).permit(:name, :established_year, :address, :user_id)
    end
end
