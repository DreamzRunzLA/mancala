class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @cups = Array.new(14) {Array.new()}
    place_stones
    @name1 = name1
    @name2 = name2
  end

  def place_stones
    @cups = @cups.each_with_index do |cup, i|
      if i == 6 || i == 13
        next
      else
        cup << :stone
        cup << :stone
        cup << :stone
        cup << :stone
      end
    end
  end

  def valid_move?(start_pos)
    if start_pos < 0 || start_pos > 13
      raise "Invalid starting cup"
    elsif @cups[start_pos].length == 0
      raise "Starting cup is empty"
    else
      return true
    end
  end

  def make_move(start_pos, current_player_name)
    #6 = player1 store, 13 = player2 store
    #player.side tells you whether 6 or 13 is own cup
    #Board goes 0, 1, 2, 3, 4, 5, [6], 7, 8, 9, 10, 11, 12, [13]
    #Each cup within the board is an array of stones
    stones_left = @cups[start_pos].length
    index = start_pos + 1
    while stones_left > 0
      if index >= 14
        index -=14
      end
      if current_player_name == @name1
        if index == 13
          index += 1
        else
          temp = @cups[start_pos].pop
          @cups[index] << temp
          stones_left -= 1
          index += 1
        end
      else
        if index == 6
          index += 1
        else
          temp = @cups[start_pos].pop
          @cups[index] << temp
          stones_left -= 1
          index += 1
        end
      end
    end
    render
    next_turn(index - 1)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    if ending_cup_idx == 6 || ending_cup_idx == 13
      return :prompt
    elsif @cups[ending_cup_idx].length > 1
      return ending_cup_idx
    else
      return :switch
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    (0..5).to_a.all? { |idx| @cups[idx].length == 0 } || (7..12).to_a.all? { |idx| @cups[idx].length == 0 }
  end

  def winner
    if @cups[6].length > @cups[13].length
      return @name1
    elsif @cups[6].length < @cups[13].length
      return @name2
    else
      return :draw
    end
  end
end
