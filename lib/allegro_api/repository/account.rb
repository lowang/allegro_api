module AllegroApi
  module Repository
    class Account < Base
      def current
        response = @session.client.call(:do_get_my_data, session_handle: @session.id)[:do_get_my_data_response]
        account_from_api(response)
      end

      private

      # from_api should be kept in repository as different api calls returns data in different format
      def account_from_api(response)
        user_data = response[:user_data]
       company = AllegroApi::Company.new(
         name: response[:invoice_data][:company_name],
         type: response[:company_extra_data][:company_type],
         nip: response[:company_extra_data][:company_nip],
         regon: response[:company_extra_data][:company_regon],
         krs: response[:company_extra_data][:company_krs],
         activity_sort: response[:company_extra_data][:company_activity_sort],
         worker_first_name: response[:company_second_address][:company_worker_first_name],
         worker_last_name:  response[:company_second_address][:company_worker_last_name])
       AllegroApi::Account.new(id: user_data[:user_id].to_i, login: user_data[:user_login],
         rating: user_data[:user_rating].to_i ,
         first_name: user_data[:user_first_name],
         last_name: user_data[:user_last_name],
         maiden_name: user_data[:user_maiden_name],
         company: user_data[:user_company],
         country_id: user_data[:user_country_id].to_i,
         state_id: user_data[:user_state_id].to_i,
         post_code: user_data[:user_postcode],
         city: user_data[:user_city],
         address: user_data[:user_address],
         email: user_data[:user_email],
         phone: user_data[:user_phone],
         phone2: user_data[:user_phone2],
         is_super_seller: !user_data[:user_ss_status].to_i.zero?,
         is_junior: !user_data[:user_junior_status].to_i.zero?,
         has_shop: !user_data[:user_has_shop].to_i.zero?,
         is_company: !user_data[:user_company_icon].to_i.zero?,
         is_allegro_standard: !user_data[:user_is_allegro_standard].to_i.zero?,
         company: company)
      end
    end
  end
end
