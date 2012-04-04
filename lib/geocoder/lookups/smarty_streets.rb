require 'geocoder/lookups/base'
require "geocoder/results/smarty_streets"

module Geocoder::Lookup
  class SmartyStreets < Base

    #def map_link_url(coordinates)
    #  #"http://maps.google.com/maps?q=#{coordinates.join(',')}"
    #end

    private # ---------------------------------------------------------------

    def results(query, reverse = false)
      return [] unless doc = fetch_data(query, reverse)
      case doc['status']; when "OK" # OK status implies >0 results
        return doc['results']
      when "OVER_QUERY_LIMIT"
        raise_error(Geocoder::OverQueryLimitError) ||
          warn("Google Geocoding API error: over query limit.")
      when "REQUEST_DENIED"
        warn "Google Geocoding API error: request denied."
      when "INVALID_REQUEST"
        warn "Google Geocoding API error: invalid request."
      end
      return []
    end

    def query_url(query, reverse = false)
      params = {
        'auth-token' => Geocoder::Configuration.api_key
      }
      "#{protocol}://api.qualifiedaddress.com/street-address/?" + hash_to_query(params)
    end
  end
end

