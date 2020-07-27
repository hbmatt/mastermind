class Mastermind
  attr_accessor :colors, :player, :computer, :rounds

  def initialize
    @rounds = 0
    @colors = %w[R O Y G B V]
    @feedback = [0,0]
    @player = Player.new('Player')
    @computer = Computer.new('Computer')
  end

  def start_game
    puts "+---------------------------------------------------------------+
    \rWelcome to Mastermind!\n"

    choose_role()
  end

  def choose_role
    puts "Do you want to play as:
    \r1. Codemaker
    \r2. Codebreaker"

    role = gets.chomp.to_i

    until role == 1 || role == 2
      puts "You can't do that! Please enter 1 or 2.
      \rDo you want to play as:
      \r1. Codemaker
      \r2. Codebreaker"
      role = gets.chomp.to_i
    end

    if role == 1
      start_codemaker()
    elsif role == 2
      start_codebreaker()
    end
  end

  def start_codemaker
    player.make_key
    puts "\nIf the computer can guess the secret code within 12 rounds, the computer wins.\n\n"
    play_rounds(@computer, @player)
  end

  def start_codebreaker
    puts "\nThe computer will generate a random code of 4 colors from ROYGBV.
    \rThe code can only contain one of each color.
    \rIf you can guess the secret code within 12 rounds, you win!\n"

    computer.generate_key(@colors)
    play_rounds(@player, @computer)
  end

  def play_rounds(breaker, maker)
    until @rounds > 12
      breaker.player_guess(@colors, maker, @rounds)
      check_colors(breaker.guess, maker.key)
      check_position(breaker.guess, maker.key)

      if breaker == @computer
        pause_game()
      end

      if check_win?(breaker.guess, maker.key)
        end_game("#{breaker.name}", maker)
      else
        reset_feedback()
        @rounds += 1
      end
    end

    end_game("#{maker.name}", maker)
  end

  def check_colors(guess, key)
    i = 3
    color_counter = []
    until i < 0
      if key.include?(guess[i]) && !color_counter.include?(guess[i])
        @feedback[0] += 1
        color_counter.push(guess[i])
      else 
        @feedback[0]
      end
      i -= 1
    end

    puts "Correct Colors: #{@feedback[0]}"
  end

  def check_position(guess, key)
    if @feedback[0] != 0
      i = 3
      until i < 0
        guess[i] == key[i] ? @feedback[1] += 1 : @feedback[1]
        i -= 1
      end
      puts "Correct Positions: #{@feedback[1]}"
    else
      @feedback[1]
    end
  end

  def pause_game
    puts "Press 'Enter' to continue."
    gets
  end

  def reset_feedback
    @feedback = [0,0]
  end

  def check_win?(guess, key)
    guess == key
  end

  def end_game(winner, loser)
    puts "\nGame over! #{winner} wins.
    \rThe secret code was #{loser.key.join}.\n\n"
    restart()
  end

  def restart
    puts "Play again? [Y/N]"
    restart = gets.chomp.upcase
    
    until restart == 'Y' || restart == 'N'
      puts "Play again? [Y/N]"
      restart = gets.chomp.upcase
    end

    if restart == 'Y'
      puts "\n"
      Mastermind.new.start_game
    else
      exit
    end
  end

end

class Player
  attr_accessor :guess, :key, :name

  def initialize(name)
    @name = name
    @guess = []
    @key = []
  end

  def make_key
    puts "\nCreate a code from ROYGBV for the computer to break.
    \rThe code can only contain one of each color.
    \rEnter a four-letter combination of ROYGBV:"
    player_key = gets.chomp.upcase.split('')

    until check_key?(player_key)
      puts "\nYou can't do that! Try again.
      \rEnter a four-letter combination of ROYGBV:"
      player_key = gets.chomp.upcase.split('')
    end
    
    store_key(player_key)
  end

  def check_key?(key)
    key.include?(/[^ROYGBV]/) ? false : true
    key.uniq == key ? true : false
  end

  def store_key(key)
    @key = key
  end

  def player_guess(colors, computer, rounds)
    puts "\nWhat is your guess? Enter a four-letter combination of ROYGBV:"
    guess_string = gets.chomp.upcase

    until check_guess?(guess_string)
      puts "You can't do that!
      \rEnter a four-letter combination of ROYGBV:"
      guess_string = gets.chomp.upcase
    end

    guess_array = guess_string.split('')
    store_guess(guess_array)
  end

  def check_guess?(guess)
    guess.match?(/[^ROYGBV]/) ? false : true
  end

  def store_guess(guess)
    @guess = guess
  end
end

class Computer
  attr_accessor :key, :guess, :name

  def initialize(name)
    @name = name
    @key = []
    @guess = []
    @valid_colors = []
    @position = []
    @color = []
  end

  def generate_key(colors)
    @key = colors.sample(4)
  end

  def player_guess(colors, player, rounds)
    if rounds < 6
      guess_colors(rounds, colors)
      store_colors(@guess, player.key)
    else
      store_position(@guess, player.key)
      @guess = @valid_colors.sample(4)
      push_position()
    end

    puts "The computer guesses #{@guess.join}."
  end

  def guess_colors(rounds, colors)
    @guess = Array.new(4,colors[rounds])
  end

  def store_colors(guess, key)
    if key.include?(guess[0])
      @valid_colors.push(guess[0])
    end
  end

  def store_position(guess, key)
    i = 3
    until i < 0
      if guess[i] == key[i]
        @position.push(i)
        @color.push(guess[i])
      end
      i -= 1
    end
  end


  def push_position
    i = @position.length - 1

    until i < 0
      @guess[@position[i]] = @color[i]
      i -= 1
    end
  end
end

Mastermind.new.start_game