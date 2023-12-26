class Ad < ApplicationRecord
  enum status: %i[draft published].index_with(&:to_s), _default: :draft
end
