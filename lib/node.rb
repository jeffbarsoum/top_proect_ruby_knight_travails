# frozen_string_literal: true

# Parent Node class, for Hashes and LinkedLists, keys and values are added by children
class Node
  include Comparable
  # setters and getters for "value" and "next_node"
  attr_accessor :distance, :predecessor

  def <=>(other)
    return 0 if distance.nil? && other&.distance.nil?
    return -1 if distance.nil? && !other.distance.nil?
    return 1 if !distance.nil? && other&.value.nil?

    distance <=> other.distance
  end

  def initialize(distance = nil, predecessor = nil)
    self.distance = distance
    self.predecessor = predecessor
  end

  def to_s
    "[ { distance: #{distance},  predecessor: #{predecessor} }"
  end
end
