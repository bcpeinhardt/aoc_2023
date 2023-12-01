import gleam/io
import gleam/string
import gleam/list
import gleam/int
import simplifile

pub fn main() {
  let assert Ok(txt) = simplifile.read("./input/day_1/real.txt")

  txt
  |> part_1
  |> int.to_string
  |> io.println

  txt
  |> part_2
  |> int.to_string
  |> io.println
}

pub fn part_1(input: String) -> Int {
  input
  |> string.split("\n")
  |> list.map(fn(str) {
    let lst =
      str
      |> string.to_graphemes
      |> list.filter_map(int.parse)
    let assert Ok(first) = list.first(lst)
    let assert Ok(last) = list.last(lst)
    10 * first + last
  })
  |> list.fold(0, fn(acc, x) { acc + x })
}

pub fn part_2(input: String) -> Int {
  input
  |> string.split("\n")
  |> list.map(fn(str) { 10 * first_digit(str) + last_digit(str) })
  |> list.fold(0, fn(acc, x) { acc + x })
}

pub fn first_digit(input: String) -> Int {
  case input {
    "one" <> _ | "1" <> _ -> 1
    "two" <> _ | "2" <> _ -> 2
    "three" <> _ | "3" <> _ -> 3
    "four" <> _ | "4" <> _ -> 4
    "five" <> _ | "5" <> _ -> 5
    "six" <> _ | "6" <> _ -> 6
    "seven" <> _ | "7" <> _ -> 7
    "eight" <> _ | "8" <> _ -> 8
    "nine" <> _ | "9" <> _ -> 9
    _ -> first_digit(string.drop_left(input, 1))
  }
}

pub fn last_digit(input: String) -> Int {
  case string.reverse(input) {
    "eno" <> _ | "1" <> _ -> 1
    "owt" <> _ | "2" <> _ -> 2
    "eerht" <> _ | "3" <> _ -> 3
    "ruof" <> _ | "4" <> _ -> 4
    "evif" <> _ | "5" <> _ -> 5
    "xis" <> _ | "6" <> _ -> 6
    "neves" <> _ | "7" <> _ -> 7
    "thgie" <> _ | "8" <> _ -> 8
    "enin" <> _ | "9" <> _ -> 9
    _ -> last_digit(string.drop_right(input, 1))
  }
}
