# -*- coding: utf-8 -*-
require 'json'
require 'zip_code_jp/export'
require 'zip_code_jp/address'

module ZipCodeJp
  DATA_DIR = File.dirname(__FILE__) + '/../data'

  module_function
  def export_json
    ZipCodeJp::Export.execute
  end

  def find(zip_code)
    zip_code = zip_code.gsub(/-/, '')
    json_file = DATA_DIR + '/zip_code/' + zip_code.slice(0,3) + '.json'
    if (File.exist?(json_file))
      data = JSON.parse(File.open(json_file).read)
      address_data = data[zip_code.slice(3,4)]

      if address_data.instance_of?(Array)
        results = []
        address_data.each do |a|
          results.push ZipCodeJp::Address.new(a)
        end
        return results
      end

      return address_data ? ZipCodeJp::Address.new(address_data) : false
    end
    return false
  end

  def find_first(zip_code)
    result = find(zip_code)
    if result.is_a? Array
      result.first
    else
      result
    end
  end
end
