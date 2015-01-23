require 'base64'
require 'digest'
require 'savon'

require "allegro_api/version"
require "allegro_api/exceptions"
require "allegro_api/fid"
require "allegro_api/field"
require "allegro_api/category"
require "allegro_api/client"
require "allegro_api/session"
require "allegro_api/item"
require "allegro_api/auction"

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
