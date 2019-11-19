# frozen_string_literal: true

require "rbvore/version"

module Rbvore
  class Error < StandardError; end
  # Your code goes here...
end

require 'rbvore/api'
require 'rbvore/link'
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
