# frozen_string_literal: true

require_relative 'queue'
require_relative 'node'

# A class for the path of a Knight on a chess board
class KnightPath
  BOARD_SIZE = 8
  attr_accessor :adj_list, :bfs_result

  def initialize
    self.adj_list = []
    self.bfs_result = []
    BOARD_SIZE.times do |row|
      @adj_list[row] = [] unless adj_list[row].is_a? Array
      BOARD_SIZE.times do |col|
        @bfs_result[row][col] = Node.new unless adj_list[row].is_a? Array
        @adj_list[row][col] =
          [
            knight_pos([row, col], 2, 1),
            knight_pos([row, col], 2, -1),
            knight_pos([row, col], -2, 1),
            knight_pos([row, col], -2, -1),
            knight_pos([row, col], 1, 2),
            knight_pos([row, col], 1, -2),
            knight_pos([row, col], -1, 2),
            knight_pos([row, col], -1, -2)
          ].compact
      end
    end
  end

  def knight_pos(pos, vertical, horizontal)
    new_pos = [pos[0] + vertical, pos[1] + horizontal]
    return nil unless new_pos[0].between?(0, BOARD_SIZE - 1) && new_pos[1].between?(0, BOARD_SIZE - 1)

    new_pos
  end

  def each(matrix, &block)
    (0..matrix.length - 1).each do |row|
      matrix[row] = [] unless matrix[row]
      (0..matrix[row].length - 1).each { |col| block.call(row, col) }
    end
  end

  def bfs(start_vertex, end_vertex)
    queue = BFSQueue.new
    queue.enqueue(start_vertex)

    each(adj_list) do |row, col|
      @bfs_result[row] = [] unless bfs_result[row]
      @bfs_result[row][col] = [] unless bfs_result[row][col]
      @bfs_result[row][col] = Node.new
    end

    @bfs_result[start_vertex[0]][start_vertex[1]].distance = 0

    until queue.empty?
      parent = queue.dequeue
      adj_list[parent[0]][parent[1]].each do |vertex|
        bfs_info = bfs_result[vertex[0]][vertex[1]]
        next unless bfs_info.distance.nil?

        bfs_info.predecessor = parent
        bfs_info.distance = bfs_result[parent[0]][parent[1]].distance + 1
        queue.enqueue(vertex)
        p bfs_info
        puts "queue: #{queue.queue}"
      end
    end
    bfs_result[end_vertex[0]][end_vertex[1]]
  end
end

knight = KnightPath.new

bfs_search = knight.bfs([4, 4], [7, 4])

p bfs_search
