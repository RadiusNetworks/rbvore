# frozen_string_literal: true

module Rbvore
  class Employee < Resource
    attr_accessor :id, :check_name, :first_name, :last_name, :login, :middle_name,
                  :pos_id, :start_date

    def initialize(hash)
      set_attributes(hash)
    end
  end
end
