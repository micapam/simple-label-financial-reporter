require 'active_model'
require 'activemodel/assocations'
require 'active_support/concern'

module Model < ActiveSupport::Concern

  included do
    include ActiveModel::Model
    include ActiveModel::Associations
  end
  
end