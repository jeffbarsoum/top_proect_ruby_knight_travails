# frozen_string_literal: true

# A simple FIFO queue for BFS
class BFSQueue
  attr_accessor :queue

  def initialize
    self.queue = []
  end

  def enqueue(data)
    @queue << data
  end

  def dequeue
    @queue.shift
  end

  def empty?
    queue.empty?
  end

  def to_s
    queue
  end
end
