# encoding: utf-8
#
module Internals

  #
  #
  module Query

    # This class primarily handles switching through similar token constellations.
    #
    class Tokens # :nodoc:all

      # Basically delegates to its internal tokens array.
      #
      self.delegate *[Enumerable.instance_methods, :slice!, :[], :uniq!, :last, :reject!, :length, :size, :empty?, :each, :exit, { :to => :@tokens }].flatten

      #
      #
      def initialize tokens = []
        @tokens = tokens
      end
      def self.processed words
        new words.collect! { |word| Token.processed word }
      end

      # Tokenizes each token.
      #
      # Note: Passed tokenizer needs to offer #normalize(text).
      #
      def tokenize_with tokenizer
        @tokens.each { |token| token.tokenize_with(tokenizer) }
      end

      # Generates an array in the form of
      # [
      #  [combination],                           # of token 1
      #  [combination, combination, combination], # of token 2
      #  [combination, combination]               # of token 3
      # ]
      #
      def possible_combinations_in type
        @tokens.inject([]) do |combinations, token|
          possible_combinations = token.possible_combinations_in type

          # Note: Optimization for ignoring tokens that allocate to nothing and
          # can be ignored.
          # For example in a special search, where "florian" is not
          # mapped to any category.
          #
          possible_combinations ? combinations << possible_combinations : combinations
        end
      end

      # Makes the last of the tokens partial.
      #
      def partialize_last
        @tokens.last.partial = true unless empty?
      end

      # Caps the tokens to the maximum.
      #
      def cap maximum
        @tokens.slice!(maximum..-1) if cap?(maximum)
      end
      def cap? maximum
        @tokens.size > maximum
      end

      # Rejects blank tokens.
      #
      def reject
        @tokens.reject! &:blank?
      end

      # Returns a solr query.
      #
      def to_solr_query
        @tokens.map(&:to_solr).join ' '
      end

      #
      #
      def originals
        @tokens.map(&:original)
      end

      def == other
        self.tokens == other.tokens
      end

      # Just join the token original texts.
      #
      def to_s
        originals.join ' '
      end

    end

  end

end