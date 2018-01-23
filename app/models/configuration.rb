# The configurations of jail that contains the cost of meeting
# time buckets and available modules for app user for specify jail.
class Configuration < ApplicationRecord
  belongs_to :jail
end
