require 'base64'
require 'time'
require 'digest'
require 'savon'
require 'active_model'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/array/wrap'
require 'active_support/ordered_hash'
require 'enumerator/memoizing'

require "allegro_api/version"
require "allegro_api/response_helpers"
require "allegro_api/exceptions"
require "allegro_api/fid"
require "allegro_api/field"
require "allegro_api/category"
require "allegro_api/country"
require "allegro_api/client"
require "allegro_api/session"
require "allegro_api/account"
require "allegro_api/company"
require "allegro_api/item"
require "allegro_api/auction"
require "allegro_api/image"
require "allegro_api/journal_event"
require "allegro_api/deal_event"
require "allegro_api/purchase_detail"
require "allegro_api/state"
require "allegro_api/transaction_address"
require "allegro_api/transaction_item_deal"
require "allegro_api/transaction_item"
require "allegro_api/transaction"

require "allegro_api/repository/base"
require "allegro_api/repository/account"
require "allegro_api/repository/auction"
require "allegro_api/repository/category"
require "allegro_api/repository/deal_event"
require "allegro_api/repository/field"
require "allegro_api/repository/item"
require "allegro_api/repository/journal_event"
require "allegro_api/repository/purchase_detail"
require "allegro_api/repository/transaction"

module AllegroApi

  # umożliwia ustawienie cacha do przechowywania lokalnych dancyh,
  # bez potrzeby ciągłego ich pobierania z allegro (lista pól, kategorii)
  # jako parametr należy podać obiekt implementujący metody:
  #   fetch(collection, key) - metoda zwraca obiekt z danej kolekcji
  #   store(collection, key, value) - metoda zapisuje w cachu obiekt w danej kolekcji
  def self.cache=(cache)
    @cache = cache
  end

  def self.cache
    @cache
  end

  def self.wsdl=(wsdl)
    @wsdl = wsdl
  end

  def self.wsdl
    @wsdl
  end

  def self.webapi_key=(webapi_key)
    @webapi_key = webapi_key
  end

  def self.webapi_key
    @webapi_key
  end

end
