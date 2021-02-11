defmodule Practice.Palindrome do
    def check(word) do
      word == String.reverse(word)
    end
  end