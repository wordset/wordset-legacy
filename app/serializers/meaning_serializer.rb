class MeaningSerializer < BaseSerializer
  attributes :id, :def
  has_many :quotes

  #params :hi
end