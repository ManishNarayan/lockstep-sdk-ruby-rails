class Lockstep::Payment < Lockstep::ApiRecord
  self.model_name_uri = "v1/Payments"
  self.id_ref = "payment_id"
  load_schema(Schema::Payment)
  ERP_WRITE = "erp_write"
  ERP_WRITE_PATH_PARAMS = "erp-write"
  belongs_to :connection, class_name: "Lockstep::Connection", foreign_key: :company_id

  # Overriding create to support erp-write in path params
  def create
    if attributes_for_saving.key?(ERP_WRITE)
      attributes_for_saving.delete(ERP_WRITE)
      attrs = attributes_for_saving.transform_keys { |key| key.camelize(:lower) }
      resp = resource.post(ERP_WRITE_PATH_PARAMS, body: attrs)
      result = post_result(resp)
    else
      attrs = attributes_for_saving.transform_keys { |key| key.camelize(:lower) }
      resp = resource.post('', body: [attrs])
      result = post_result(resp)
    end
  end

  def download_pdf
    response = resource.get "#{id}/pdf"
    response.body
  end
end
