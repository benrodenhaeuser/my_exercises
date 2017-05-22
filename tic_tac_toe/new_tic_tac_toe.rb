# solving tic tac toe

require 'benchmark'

LINE_LENGTH = 4 # 3 or 4
BOARD_SIZE = LINE_LENGTH ** 2
AVAILABLE = ' '
P1 = 'X'
P2 = 'O'
PLAYERS = [P1, P2]
INITIAL_STATE = (AVAILABLE * BOARD_SIZE).chars

def win_lines
  case LINE_LENGTH
  when 3
    [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ]
  when 4
    [
      [0, 1, 2], [1, 2, 3], [4, 5, 6], [5, 6, 7], [8, 9, 10], [9, 10, 11],
      [12, 13, 14], [13, 14, 15], [0, 4, 8], [4, 8, 12], [1, 5, 9], [5, 9, 13],
      [2, 6, 10], [6, 10, 14], [3, 7, 11], [7, 11, 15], [2, 5, 8], [3, 6, 9],
      [6, 9, 12], [7, 10, 13], [1, 6, 11], [0, 5, 10], [5, 10, 15], [4, 9, 14]
    ]
  end
end

def terminal?(state)
  (PLAYERS.any? { |player| winner?(player, state) }) || no_moves?(state)
end

def payoff(player, state)
  winner?(player, state) ? 1 : (winner?(opponent(player), state) ? -1 : 0)
end

def move_count(state)
  BOARD_SIZE - available_moves(state).size
end

def opponent(player)
  player == P1 ? P2 : P1
end

def winner?(player, state)
  win_lines.any? { |line| line.all? { |index| state[index] == player } }
end

def no_moves?(state)
  available_moves(state).empty?
end

def available_moves(state)
  (0...BOARD_SIZE).select { |move| state[move] == AVAILABLE }
end

def select_move(method, player, state)
  send(method, player, state, :top)
end

def play(method, player = P1, state = INITIAL_STATE)
  history = []
  loop do
    break if terminal?(state)
    move = select_move(method, player, state)
    history << move
    state[move] = player
    player = opponent(player)
  end
  [history, state]
end

def display(history, state)
  state.each_slice(LINE_LENGTH) { |slice| puts slice.join(' ') }
  puts history.join(' --> ')
end

# random choice (notice that the signature does not fit the earlier setup!)
def random_choice(player, state)
  available_moves(state).sample
end

# brute force negamax: returns the VALUE of the calling state
def value(player, state)
  if terminal?(state)
    payoff(player, state)
  else
    values = available_moves(state).map do |move|
      state[move] = player
      value = -value(opponent(player), state)
      state[move] = AVAILABLE
      value
    end
    values.max
  end
end

# brute force negamax: value/move
def best_nega(player, state, top = false)
  return payoff(player, state) if terminal?(state)
  best = available_moves(state).map do |move|
    state[move] = player
    value = -(best_nega(opponent(player), state))
    state[move] = AVAILABLE
    [move, value]
  end.max_by { |move, value| value }
  top ? best.first : best.last
end

# negamax with transposition table: value/move
def best_nega_memo(player, state, top = false, table = {})
  if table[state.join]
    table[state.join]
  elsif terminal?(state)
    table[state.join] = payoff(player, state)
  else
    best = available_moves(state).map do |move|
      state[move] = player
      value = -best_nega_memo(opponent(player), state, false, table)
      state[move] = AVAILABLE
      [move, value]
    end.max_by { |move, value| value }
    top ? best.first : table[state.join] = best.last
  end
end

# ----- Exploit symmetries

def reflect(state)
  matrix = []
  state.each_slice(LINE_LENGTH) { |line| matrix << line }
  transpose(matrix)
end

def rotate(state)
  matrix = []
  state.each_slice(LINE_LENGTH) { |line| matrix << line }
  rotate90(matrix)
end

def transpose(matrix)
  (0...matrix.size).inject([]) do |new_matrix, col_index|
    new_matrix << column(matrix, col_index)
  end
end

def rotate90(matrix)
  (0...matrix.first.size).inject([]) do |new_matrix, col_index|
    new_matrix << column(matrix, col_index).reverse
  end
end

def column(matrix, col_index)
  (0...matrix.size).inject([]) do |column, row_index|
    column << matrix[row_index][col_index]
  end
end

def find_value(state, table)
  case
  when table[state.join]
    table[state.join]
  when table[rotate(state).join]
    table[rotate(state).join]
  when table[rotate(rotate(state)).join]
    table[rotate(rotate(state)).join]
  when table[rotate(rotate(rotate(state))).join]
    table[rotate(rotate(rotate(state))).join]
  when table[reflect(state).join]
    table[reflect(state).join]
  when table[reflect(rotate(state)).join]
    table[reflect(rotate(state)).join]
  else
    nil
  end
end

# table = { '  X      ' => 0 }
# p find_value('X        '.chars, table)
# p find_value('      X  '.chars, table)

def best_nega_memo_sym(player, state, top = false, table = {})
  value = find_value(state, table)
  if value
    return value
  elsif terminal?(state)
    table[state.join] = payoff(player, state)
  else
    best = available_moves(state).map do |move|
      state[move] = player
      value = -best_nega_memo_sym(opponent(player), state, false, table)
      state[move] = AVAILABLE
      [move, value]
    end.max_by { |move, value| value }
    if top
      then best.first
    else
      table[state.join] = best.last
    end
  end
end

def alpha_beta(player, state, top = false, alpha = -10, beta = 10)
  if terminal?(state)
    payoff(player, state)
  else
    best = [nil, -10]
    available_moves(state).each do |move|
      state[move] = player
      value = [move, -alpha_beta(opponent(player), state, false, -beta, -alpha)]
      state[move] = AVAILABLE
      best = value if value.last > best.last
      alpha = [alpha, value.last].max
      break if alpha >= beta
    end
    top ? best.first : best.last
  end
end

# puts Benchmark.realtime { display(*play(:best_nega)) } # 3x3: 7.79
# puts Benchmark.realtime { display(*play(:best_nega_memo)) } # 3x3: 0.15
# puts Benchmark.realtime { display(*play(:best_nega_memo_sym)) } # 3x3: 0.21
# puts Benchmark.realtime { display(*play(:alpha_beta)) } # 3x3: 0.26, 4x4: 45.20




# tests and benchmarks
# display(play(:best_move_memo, 'O', 'XO  X    '.chars))

# on a 3x3 board
# p best_move_prune
# puts Benchmark.realtime{ display(play(:best_move_prune)) }
# {:value=>0, :move=>0}
# X X O
# O O X
# X O X
# 0.26510000019334257

# on a 4x4 board
# p best_move_prune

# {:value=>1, :move=>0}
# X O O X
# X O
# X
#
# 45.212250999873504

# ^ this looks odd! ... what is going on?

# board = (AVAILABLE * BOARD_SIZE).chars
# board[0] = 'X'
# p best_move_prune('O', board) # => {:value=>-1, :move=>1}

# ^ right. the problem is that the 'O' player just picks a move that leads to a loss ... because all moves lead to a loss.

# we could try to fix this by giving better values to long losses over short losses => picking up a fight is encouraged.

# display(play(:best_move_prune))

# puts Benchmark.realtime { value }
# puts Benchmark.realtime { best_move }
# puts Benchmark.realtime { value_memo }
# puts Benchmark.realtime { best_move_memo }
# puts Benchmark.realtime { best_move_reflect }
# 5.490661000134423
# 6.565301000140607
# 0.08823299990035594
# 0.11649300018325448
# 0.08672400005161762
# 0.0003179998602718115

# puts Benchmark.realtime { play(:best_move_memo) }
# puts Benchmark.realtime { play(:best_move_reflect) }

# 0.17226799996569753
# 1.00000761449337e-05 ??
# 7.999828085303307e-06 ??

# TODO:
# - cut down computation time by using insights about the game: symmetries
# - alpha-beta-pruning
# - get more interesting play on 4x4 board? ... watching computers play a solved game is boring


# ---- Putting up a fight

# payoff method that favors long plays over short ones:

# def payoff(player, state)
#   if winner?(player, state)
#     100 - move_count(state)
#   elsif winner?(opponent(player), state)
#     -100 + move_count(state)
#   else
#     0
#   end
# end



# OLD STUFF

# negamax with memoization and "reflections": value

# this is unlikely to be helpful

def swap(state)
  state.map do |marker|
    case marker
    when P1 then P2
    when P2 then P1
    else
      AVAILABLE
    end
  end
end

def best_move_reflect(player, state, table = {})
  if table[state.join]
    return table[state.join]
  elsif table[reflect(state).join]
    return table[state.join] = {
      value: -table[reflect(state).join][:value],
      move: table[reflect(state).join][:move]
    }
  end

  if terminal?(state)
    table[state.join] = { value: payoff(player, state), choice: nil }
  else
    values = available_moves(state).map do |move|
      state[move] = player
      value = {
        value: -(best_move_reflect(opponent(player), state, table))[:value],
        move: move
      }
      state[move] = AVAILABLE
      value
    end
    table[state.join] = values.max_by { |value| value[:value] }
  end
end

## INTERESTING, BUT COMPLICATED

# alpha-beta pruning: value
def value_prune(player, state, alpha = -10, beta = 10)
  if terminal?(state)
    payoff(player, state)
  else
    best = -10
    available_moves(state).each do |move|
      state[move] = player
      val = -value_prune(opponent(player), state, -beta, -alpha)
      state[move] = AVAILABLE
      best = [best, val].max
      alpha = [alpha, val].max
      break if alpha >= beta
    end
    best
  end
end

# alpha-beta pruning: value and best move
def best_move_prune(player, state, alpha = -10, beta = 10)
  if terminal?(state)
    { value: payoff(player, state), move: nil }
  else
    best = { value: -10, move: nil}
    available_moves(state).each do |move|
      state[move] = player
      value = {
        value: -best_move_prune(opponent(player), state, -beta, -alpha)[:value],
        move: move
      }
      state[move] = AVAILABLE
      best = value if value[:value] > best[:value]
      alpha = [alpha, value[:value]].max
      break if alpha >= beta
    end
    best
  end
end
