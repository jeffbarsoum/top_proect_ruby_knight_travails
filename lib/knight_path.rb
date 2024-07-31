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

  def init_search_result
    each(@adj_list) do |row, col|
      @search_result[row] = [] unless @search_result[row]
      # @search_result[row][col] = [] unless search_result[row][col]
      @search_result[row][col] = Node.new
    end
  end

  def adj_list(row, col)
    @adj_list[row][col]
  end

  def search_result(row, col)
    @search_result[row][col]
  end

  def bfs(start_vertex, end_vertex)
    queue = BFSQueue.new
    queue.enqueue(start_vertex)

    init_search_result
    search_result(*start_vertex).distance = 0

    until queue.empty?
      parent = queue.dequeue
      adj_list(*parent).each do |vertex|
        bfs_info = search_result(*vertex)
        next unless bfs_info.distance.nil?

        bfs_info.predecessor = parent
        bfs_info.distance = search_result(*parent).distance + 1
        queue.enqueue(vertex)
        p bfs_info
        p "vertex: [#{vertex[0]}, #{vertex[1]}]"
        puts "queue: #{queue.queue}"
      end
    end
    search_result(*end_vertex)
  end

  def dfs(start_vertex, end_vertex)
    init_search_result
    search_result(*start_vertex).time_discovered = 0
    search_result(*start_vertex).distance = 0

    adj_list(*start_vertex).each do |vertex|
      dfs_visit_vertex(vertex, start_vertex) if search_result(*vertex).time_discovered.nil?
    end
    search_result(*end_vertex)
  end

  def dfs_visit_vertex(vertex, start_vertex, time = 0, dfs_info = nil)
    return false if vertex == start_vertex

    dfs_info = search_result(*vertex)
    dfs_info.predecessor = vertex
    pred = search_result(*vertex)
    dfs_info.distance = pred.distance + 1
    dfs_info.time_discovered = time
    adj_list(*vertex).each do |adj_vertex|
      next unless dfs_info.time_discovered.nil? && dfs_info.predecessor.nil?

      dfs_visit_vertex(adj_vertex, start_vertex, time, dfs_info)
      time += 1
      dfs_info.time_finished = time
      p dfs_info
      p "vertex: [#{adj_vertex[0]}, #{adj_vertex[1]}]"
      p dfs_info.predecessor
    end
  end
end

knight = KnightPath.new

bfs_search = knight.bfs([0, 0], [7, 4])
p bfs_search

dfs_search = knight.dfs([0, 0], [7, 4])
puts dfs_search
