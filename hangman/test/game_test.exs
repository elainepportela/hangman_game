defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns valid structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      { ^game, _ } = Game.make_move(game, "l")
    end
  end

  test "first and second ocurrence of a letter" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "l")
    assert game.game_state != :already_used
    { game, _tally } = Game.make_move(game, "l")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("war")
    { game, _tally } = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "guessed the word" do
    game = Game.new_game("war")
    { game, _tally } = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "a")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "r")
    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "guessed the word list comprehession" do
    moves = [
      {"w", :good_guess},
      {"a", :good_guess},
      {"r", :won},
    ]
    game = Game.new_game("war")
    Enum.reduce(moves, game, fn ({guess, state}, game) ->
      { game, _tally } = Game.make_move(game, guess)
      assert game.game_state == state
      game
    end)
  end

  test "a bad guess is recognized" do
    game = Game.new_game("war")
    { game, _tally } = Game.make_move(game, "l")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "lost the game" do
    game = Game.new_game("war")
    { game, _tally } = Game.make_move(game, "b")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
    { game, _tally } = Game.make_move(game, "c")
    assert game.game_state == :bad_guess
    assert game.turns_left == 5
    { game, _tally } = Game.make_move(game, "d")
    assert game.game_state == :bad_guess
    assert game.turns_left == 4
    { game, _tally } = Game.make_move(game, "f")
    assert game.game_state == :bad_guess
    assert game.turns_left == 3
    { game, _tally } = Game.make_move(game, "g")
    assert game.game_state == :bad_guess
    assert game.turns_left == 2
    { game, _tally } = Game.make_move(game, "h")
    assert game.game_state == :bad_guess
    assert game.turns_left == 1
    { game, _tally } = Game.make_move(game, "i")
    assert game.game_state == :lost
    assert game.turns_left == 0
  end

end
