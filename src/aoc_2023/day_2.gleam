import gleam/io
import gleam/string
import gleam/list
import gleam/int
import simplifile

pub fn main() {
  let assert Ok(txt) = simplifile.read("./input/day_2/real.txt")

  txt
  |> part_1
  |> int.to_string
  |> io.println

  txt
  |> part_2
  |> int.to_string
  |> io.println
}

pub type Game {
  Game(id: Int, pulls: List(MarbleCount))
}

pub type MarbleCount {
  MarbleCount(red: Int, green: Int, blue: Int)
}

pub fn part_1(input: String) -> Int {
  string.split(input, "\n")
  |> list.map(fn(game) {
    let Game(n, marble_counts) = parse_game(game)
    case list.all(marble_counts, is_valid_count) {
      True -> n
      False -> 0
    }
  })
  |> int.sum
}

pub fn part_2(input: String) -> Int {
  string.split(input, "\n")
  |> list.map(fn(game) {
    let Game(_, marble_counts) = parse_game(game)
    let MarbleCount(x, y, z) = min_marble_count(marble_counts)
    x * y * z
  })
  |> int.sum
}

fn parse_game(input: String) -> Game {
  let assert Ok(#(game, cubes)) = string.split_once(input, ": ")
  let assert "Game " <> n = game
  let assert Ok(n) = int.parse(n)

  let marble_counts =
    string.split(cubes, ";")
    |> list.map(string.trim)
    |> list.map(marble_count_from_round)

  Game(n, marble_counts)
}

pub fn is_valid_count(input: MarbleCount) -> Bool {
  let MarbleCount(red, green, blue) = input
  red <= 12 && green <= 13 && blue <= 14
}

pub fn marble_count_from_round(round: String) -> MarbleCount {
  use acc, pull <- list.fold(string.split(round, ","), MarbleCount(0, 0, 0))
  let assert Ok(#(count, color)) = string.split_once(string.trim(pull), " ")
  let assert Ok(n) = int.parse(string.trim(count))
  case color {
    "red" -> MarbleCount(..acc, red: acc.red + n)
    "green" -> MarbleCount(..acc, green: acc.green + n)
    "blue" -> MarbleCount(..acc, blue: acc.blue + n)
  }
}

pub fn min_marble_count(marble_counts: List(MarbleCount)) -> MarbleCount {
  use acc, x <- list.fold(marble_counts, MarbleCount(0, 0, 0))
  MarbleCount(
    red: int.max(acc.red, x.red),
    green: int.max(acc.green, x.green),
    blue: int.max(acc.blue, x.blue),
  )
}
