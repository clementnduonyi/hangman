require 'yaml'

class SecretWord
    attr_accessor :words

    def initialize
        @words = generate_word

    end

    private
    def generate_word
        filename = '5desk.txt'
        dictionary = File.readlines(filename)
        loop do
            line = dictionary[rand(dictionary.length)].strip.downcase
            if line.length <= 12 && line.length >= 5 
                return line
                
            end
        end
    end
end


class GameConsol
    attr_accessor :secret_word, :show_guesses, :guess_chances, :guesses

    def initialize 
        @secret_word = SecretWord.new.words
        @show_guesses = '_' * secret_word.length
        @guess_chances = 10
        @guesses = String.new
    end

    def start()
        puts "Enetr [1] to play new game"
        puts "Enter [2] to load your saved game"
        if choice == '2'
            load_saved_game
        end
        play_maker
             
    end
    #end

    
    def display()
        puts "You have #{@guess_chances} chances to guess the the secrete word right"
        puts @show_guesses
        puts "\n#{@guesses}"
    end


    def guess_work
        loop do
            display()
            puts 'Make a guess(a - z): '
            guess = gets.chomp.downcase

            return guess if valid_point?(guess)
      
            break
        end
        guess_work
    end
 
    def valid_point?(guess)
        print "\nA repeated guess!\n" if @guesses.include?(guess)
       
        if secret_word.include?(guess) && !show_guesses.include?(guess)
            print "\nCorrect Guess!\n"
            self.guess_chances -= 0
        elsif !secret_word.include?(guess) 
            print "\nWrong Guess!\n"
            self.guess_chances -= 1
    
        end

    end

    def evaluate(guess)
        if /[[:alpha:]]/.match(guess) && guess.length == 1
            secret_word.length.times do |letter|
                if guess == @secret_word[letter]
                show_guesses[letter] = guess
                    
                end
            end
        else
            print "\nInvalid guess. Retry!\n"
        end
        saved() if %w[SAVE save].include?(guess) 
      
                
    end

    def win?
        if @secret_word == show_guesses
            true
        end
    end

    def end_game
        if win?
            puts "You guessed Right and you still have #{guess_chances} trial(s) left!"
            puts
            puts "Secret word:  #{secret_word}"
        elsif !win?
            puts "You could not guess the secret word and you have #{guess_chances} trial(s) left!"
            puts
            puts "Secret word: #{secret_word}"
        end
    end



    private

    def play_maker
        puts "You can save your progress by entering [save]."
        puts "To play, enter [play]"
        options = gets.chomp
        if %w[PLAY play].include?(options)
        end
        new_game()
    end

    def new_game
        while guess_chances != 0
            guess = guess_work
            guesses.concat(guess)
            evaluate(guess)
            break if win? || guess_chances == 0
        
        end
        end_game()
    end

    def choice
        choice = gets.chomp
        if %w[1 2].include?(choice)
            return choice
        else
            puts "Invalid input. Retry!"
        end
    end

    def saved
        puts 'Type in file name'

        my_game = gets.chomp

        if !Dir.exist?('games')
            Dir.mkdir('games')
        end
        File.open("./games/#{my_game}.yml", 'w') do |file|
            YAML.dump([].push(self), file)
            exit
        end
    end

    def load_saved_game
        unless Dir.exist?('games')
            puts 'No saved games found. Starting new game...'
            sleep(3)
            return
        end
        game_log = saved_games
        puts game_log
        deserialized(load_game_file(game_log))
        #end
    end

    def load_game_file(game_log)
        loop do
            print "\nEnter game name to load\n"
            load_file = gets.chomp
            if game_log.include?(load_file)
                return load_file
            else
                puts "#{load_file} could not be found. Retry!"
            end
        end
    end

    def deserialized(load_file)
        yaml = YAML.load_file("./games/#{load_file}.yml")
        @secret_word = yaml[0].secret_word
        @show_guesses = yaml[0].show_guesses
        @guess_chances = yaml[0].guess_chances
        @guesses = yaml[0].guesses
    end

    def saved_games
        Dir['./games/*'].map do |file|
            file.split('/')[-1].split('.')[0]
        end
    end






   
   
              
    
end
game = GameConsol.new
game.start()
