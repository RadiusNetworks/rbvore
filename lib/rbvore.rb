# frozen_string_literal: true

require "rbvore/version"

module Rbvore
  class Error < StandardError; end
  # Your code goes here...
end

require 'rbvore/api'
require 'rbvore/link'
require 'rbvore/parsers'
require 'rbvore/resource'
require 'rbvore/menu_item'
require 'rbvore/item_modifier'
require 'rbvore/item'
require 'rbvore/tender_type'
require 'rbvore/payment'
require 'rbvore/table'
require 'rbvore/employee'
require 'rbvore/ticket_service_charge'
require 'rbvore/discount'
require 'rbvore/ticket_discount'
require 'rbvore/order_type'
require 'rbvore/revenue_center'
require 'rbvore/ticket'
require 'rbvore/location'

module Rbvore
  def self.resource_subclass?(klass)
    klass.respond_to?(:superclass) && klass.superclass == Resource
  end

  def self.resource_classes
    @resource_classes ||= Rbvore.constants.map { |const|
      klass = Rbvore.const_get(const)
      klass if resource_subclass?(klass)
    }.compact
  end

  # constantize attempts to turn a class name string into a proper constant that
  # is a subclass of Rbvore::Resource
  def self.constantize(name)
    return name if resource_subclass?(name)

    resource_classes.each do |klass|
      return klass if [klass.singularize, klass.list_name, klass.pluralize].include?(name.to_s)
    end

    raise Rbvore::Error, "No Rbvore resource classes found for #{name.inspect}"
  end
end
