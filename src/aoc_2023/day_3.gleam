import gleam/io
import gleam/string
import gleam/list
import gleam/int
import gleam/set
import simplifile

pub fn main() {
  let assert Ok(txt) = simplifile.read("./input/day_3/real.txt")

  txt
  |> part_1
  |> int.to_string
  |> io.println

  txt
  |> part_2
  |> int.to_string
  |> io.println
}

pub type Item {
  Number(inner: Int)
  Period
  Symbol(inner: String)
}

pub type CoordItem {
  CoordItem(coord: List(#(Int, Int)), item: Item)
}

pub fn part_1(input: String) -> Int {
  let grid = parse_grid(input)
  grid
  |> list.filter(is_number)
  |> list.filter(fn(item) {
    list.any(
      get_adj_coords(item),
      fn(c) { list.any(grid, is_symbol_with_coord(_, c)) },
    )
  })
  |> list.map(to_number_unchecked)
  |> int.sum
}

pub fn part_2(input: String) -> Int {
  let grid = parse_grid(input)
  grid
  |> list.filter(is_asterisk)
  |> list.map(fn(ci) {
    let nums =
      grid
      |> list.filter(fn(item) {
        ci
        |> get_adj_coords
        |> set.from_list
        |> set.intersection(set.from_list(item.coord))
        |> set.size >= 1
      })
      |> list.filter(is_number)

    case list.length(nums) >= 2 {
      True -> {
        nums
        |> list.map(to_number_unchecked)
        |> int.product
      }
      False -> 0
    }
  })
  |> int.sum
}

fn is_symbol_with_coord(item: CoordItem, coord: #(Int, Int)) -> Bool {
  case item {
    CoordItem([t], Symbol(_)) -> t == coord
    _ -> False
  }
}

fn to_number_unchecked(item: CoordItem) -> Int {
  let assert CoordItem(_, Number(n)) = item
  n
}

fn is_number(input: CoordItem) -> Bool {
  case input.item {
    Number(_) -> True
    _ -> False
  }
}

fn is_asterisk(input: CoordItem) -> Bool {
  case input.item {
    Symbol("*") -> True
    _ -> False
  }
}

fn get_adj_coords(input: CoordItem) -> List(#(Int, Int)) {
  input.coord
  |> list.map(adj_coords)
  |> list.flatten
}

fn adj_coords(coord: #(Int, Int)) -> List(#(Int, Int)) {
  let #(x, y) = coord
  [
    #(x - 1, y - 1),
    #(x, y - 1),
    #(x + 1, y - 1),
    #(x - 1, y),
    #(x + 1, y),
    #(x - 1, y + 1),
    #(x, y + 1),
    #(x + 1, y + 1),
  ]
  |> list.filter(fn(coord) {
    let #(x, y) = coord
    x >= 0 && y >= 0
  })
}

fn parse_grid(input: String) -> List(CoordItem) {
  string.split(input, "\n")
  |> list.index_map(parse_line)
  |> list.flatten
}

fn parse_line(x_coord: Int, line: String) -> List(CoordItem) {
  use acc, char, y_coord <- list.index_fold(string.to_graphemes(line), [])
  case char, int.parse(char), acc {
    // Found a  period
    ".", _, _ -> [CoordItem([#(x_coord, y_coord)], Period), ..acc]

    // Found a symbol (not a period and didn't parse as an integer)
    _, Error(_), _ -> [CoordItem([#(x_coord, y_coord)], Symbol(char)), ..acc]

    // Found a digit while in the middle of building a number, so we append
    // the digit to the number
    _, Ok(n), [CoordItem(coords, Number(num)), ..rest] -> [
      CoordItem([#(x_coord, y_coord), ..coords], Number(append_digit(num, n))),
      ..rest
    ]

    // Found the first digit of a number
    _, Ok(n), _ -> [CoordItem([#(x_coord, y_coord)], Number(n)), ..acc]
  }
}

fn append_digit(num: Int, digit: Int) -> Int {
  let assert Ok(num) = int.digits(num, 10)
  let assert Ok(new) = int.undigits(list.append(num, [digit]), 10)
  new
}
