class Mastermind
  attr_accessor :colors, :player, :computer

  def initialize
    @rounds = 12
    @colors = %w[R O Y G B V]
    @feedback = [0,0]
    @player = Player.new
    @computer = Computer.new
  end

  def start_game
    player = @player
    computer = @computer

    puts "+---------------------------------------------------------------+
    \rWelcome to Mastermind!\n
    \rThe computer will generate a random code of 4 colors from ROYGBV.
    \rThe code can only contain one of each color.
    \rIf you can guess the secret code within 12 rounds, you win!\n"
    
    computer.generate_key(@colors)

    until @rounds < 1
      player.player_guess
      check_colors(player.guess, computer.key)
      check_position(player.guess, computer.key)
      if check_win?(player.guess, computer.key)
        end_game("Player")
      else
        reset_feedback()
        @rounds -= 1
      end
    end

    end_game("Computer")
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

  def reset_feedback
    @feedback = [0,0]
  end

  def check_win?(guess, key)
    guess == key
  end

  def end_game(winner)
    puts "\nGame over! #{winner} wins.
    \rThe secret code was #{@computer.key.join}.\n\n"
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
  attr_accessor :guess

  def initialize
    @guess = []
  end

  def player_guess
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
  attr_accessor :key

  def initialize
    @key = []
  end

  def generate_key(colors)
    @key = colors.sample(4)
  end
end

Mastermind.new.start_game