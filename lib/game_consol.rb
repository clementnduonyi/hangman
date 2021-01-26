class SecretWord
    attr_accessor :words

    def initialize
        @words = generate_word

    end

    private
    def generate_word
        filename = '5desk.txt'
        File.open(filename, 'r').readlines.each do |line|
            if line.length <= 12 && line.length >= 5 && /[[:lower:]]/.match(line[0])
                line = line.chomp
                #words.push(line)
            end
        end
    end
end


class GameConsol
    attr_accessor :secret_word, :show_guesses, :guess_count, :guesses

    def initialize
        #play_maker  
        @secret_word = SecretWord.new.words
        @show_guesses = '_' * secret_word.length
        @guess_count = 0
        @guesses = String.new
    end

    def display
        puts "Enetr [1] to play new game"
        puts "Enter [2] to load your saved game"
        load_saved_game if options == '2'
        play_maker
    end
    #end


    private
    def play_maker
        puts "You can save your progress by entering  's'. To play, enter 'p'"
        options = gets.chomp
        if %w[P p].include?(options)
            puts "You have 10 chnaces to guess the the secrete word right"
            guesses = gets.chomp
            guess_count += 1 unless guesses == 10.times
        end
    
    end
    
end
game = GameConsol.new
game.display
